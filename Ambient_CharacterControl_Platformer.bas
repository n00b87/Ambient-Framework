Include Once
Include "Ambient_Utils.bas"


Sub Ambient_SetPlatformAnimation(control_index, platform_animation, animation_id)
	If control_index < 0 Or control_index >= AMBIENT_MAX_IO_CONTROLS Then
		Return
	End If
	
	If platform_animation < 0 Or platform_animation >= MAX_AMBIENT_PLAYER_ANIMATION Then
		Return
	End If
	
	Core.IO.Platformer_Control[control_index].player_animation[platform_animation].ID = animation_id
End Sub

Sub Ambient_SetPlatformControlActor(control_index, actor)
	If control_index < 0 Or control_index >= AMBIENT_MAX_IO_CONTROLS Then
		Return
	End If
	
	Core.IO.Platformer_Control[control_index].player_actor = actor
	
	If Not ActorExists(actor) Then
		Core.IO.Platformer_Control[control_index].player_actor = -1
	End If
	
	Dim min_bbx, min_bby, min_bbz, max_bbx, max_bby, max_bbz
	GetActorAABB(actor, min_bbx, min_bby, min_bbz, max_bbx, max_bby, max_bbz)
	
	Core.IO.Platformer_Control[control_index].min_bbx = min_bbx
	Core.IO.Platformer_Control[control_index].min_bby = min_bby
	Core.IO.Platformer_Control[control_index].min_bbz = min_bbz
	
	''Print "Min BBY: "; min_bby
	
	Core.IO.Platformer_Control[control_index].max_bbx = max_bbx
	Core.IO.Platformer_Control[control_index].max_bby = max_bby
	Core.IO.Platformer_Control[control_index].max_bbz = max_bbz
	
	mesh_index = Serenity_GetActorMeshIndex(actor)
	
	For i = 0 To MAX_AMBIENT_PLAYER_ANIMATION-1
		animation_name$ = Core.IO.Platformer_Control[control_index].player_animation[i].Name$
		animation_id = Serenity_GetMeshAnimationIDByName(mesh_index, animation_name$)
		
		If animation_id >= 0 Then
			'Print "Set Animation: "; animation_name$; " = "; animation_id
			Ambient_SetPlatformAnimation(control_index, i, animation_id)
		End If		
	Next
	
	'Print "IDLE: "; Core.IO.Platformer_Control[control_index].player_animation[AMBIENT_PLAYER_ANIMATION_IDLE].ID
	SetActorAnimation(actor, Core.IO.Platformer_Control[control_index].player_animation[AMBIENT_PLAYER_ANIMATION_IDLE].ID, -1)
End Sub



Sub Ambient_ClearLevelCollisionActors()
	For control_index = 0 To AMBIENT_MAX_IO_CONTROLS-1
		ClearStack_N(Core.IO.Platformer_Control[control_index].level_collision_stack)
	Next
End Sub

Sub Ambient_AddLevelCollisionActor(actor)
	For control_index = 0 To AMBIENT_MAX_IO_CONTROLS-1
		Push_N(Core.IO.Platformer_Control[control_index].level_collision_stack, actor)
	Next
End Sub


Sub Ambient_PlatformerControl_Init(control_index)
	Core.IO.Platformer_Control[control_index].player_actor = -1
	Core.IO.Platformer_Control[control_index].level = -1
	Core.IO.Platformer_Control[control_index].level_collision_stack = CreateStack_N()


	'Forces applied when the player moves
	Core.IO.Platformer_Control[control_index].player_linear_force = 500
	Core.IO.Platformer_Control[control_index].player_angular_force = 500
	Core.IO.Platformer_Control[control_index].player_jump_force = 1200
	Core.IO.Platformer_Control[control_index].player_jump_linear_force = 0
	Core.IO.Platformer_Control[control_index].player_jump_ready = FALSE
	Core.IO.Platformer_Control[control_index].player_ground_test = FALSE

	'These variables will store the animations once set below
	Core.IO.Platformer_Control[control_index].player_animation[AMBIENT_PLAYER_ANIMATION_IDLE].Name$ = "IDLE"
	Core.IO.Platformer_Control[control_index].player_animation[AMBIENT_PLAYER_ANIMATION_IDLE].ID = 0
	
	Core.IO.Platformer_Control[control_index].player_animation[AMBIENT_PLAYER_ANIMATION_RUN].Name$ = "RUN"
	Core.IO.Platformer_Control[control_index].player_animation[AMBIENT_PLAYER_ANIMATION_RUN].ID = 0
	
	Core.IO.Platformer_Control[control_index].player_animation[AMBIENT_PLAYER_ANIMATION_JUMP].Name$ = "JUMP"
	Core.IO.Platformer_Control[control_index].player_animation[AMBIENT_PLAYER_ANIMATION_JUMP].ID = 0

	Core.IO.Platformer_Control[control_index].mode_switch = False

	'I am setting up some matrices that I use to get the direction the
	'player is facing. GetActorPosition() is not reliable since it is
	'prone to gimbal lock so the prefered method is to calculate the
	'direction from the actor's transform matrix using a forward vector
	'
	'NOTE: Matrices are not automatically cleaned up once out of scope
	'      so if you are not creating a matrix in global scope then you
	'      must call DeleteMatrix() to clean them up
	Core.IO.Platformer_Control[control_index].player_m = DimMatrix(4, 4)
	Core.IO.Platformer_Control[control_index].forward_m = DimMatrix(4, 4)
	Core.IO.Platformer_Control[control_index].result_m = DimMatrix(4, 4)

	'This matrix is just setting a forward vector so it won't change
	SetIdentityMatrix(Core.IO.Platformer_Control[control_index].forward_m, 4)
	SetMatrixTranslation(Core.IO.Platformer_Control[control_index].forward_m, 0, 0, -100000)
End Sub



'A simple 3rd person camera to follow the player
Function Ambient_PlatformPlayer_Camera(control_index)
	Dim cam_x, cam_y, cam_z
	
	player_actor = Core.IO.Platformer_Control[control_index].player_actor
	player_m = Core.IO.Platformer_Control[control_index].player_m
	forward_m = Core.IO.Platformer_Control[control_index].forward_m
	result_m = Core.IO.Platformer_Control[control_index].result_m
	
	current_canvas = ActiveCanvas()
	Canvas(Core.IO.ControlCanvas[control_index])
	
	GetCameraPosition(cam_x, cam_y, cam_z)
	
	Dim px, py, pz
	GetActorPosition(player_actor, px, py, pz)
	
	Dim rx, ry, rz
	GetActorRotation(player_actor, rx, ry, rz)
	
	tx = 1 - (cam_x - px)
	ty = 30 - (cam_y - py)
	tz = -75 -(cam_z - pz)
	
	If Core.IO.Platformer_Control[control_index].mode_switch Then
		Core.IO.Platformer_Control[control_index].mode_switch = False
		SetCameraPosition(px+1, py+30, pz-75)
		SetCameraRotation(0, 0, 0)
	Else
		Dim rv As Ambient_Vector2D
		
		GetActorTransform(player_actor, player_m)
		MultiplyMatrix(player_m, forward_m, result_m)
		Dim mx, my, mz
		GetMatrixTranslation(result_m, mx, my, mz)
		cam_rot_y = Ambient_GetHeading2D(px, pz, mx, mz)
		rv = Ambient_RotatePoint2D(px+1, pz-75, px, pz, 90-cam_rot_y)
		SetCameraPosition(rv.x, py+30, rv.y)
		SetCameraRotation(0, 90-cam_rot_y, 0)
	End If
	
	Canvas(current_canvas)
End Function


Function Ambient_PlatformPlayer_Camera_Manual(control_index)
	CAMERA_ROTATE_LEFT = 0
	CAMERA_ROTATE_RIGHT = 0
	
	Select Case Core.IO.Active_ControlType[control_index]
		
		Case AMBIENT_CONTROL_TYPE_KEYBOARD_MOUSE
		
			CAMERA_ROTATE_LEFT = Key(Core.IO.Action[AMBIENT_ACTION_ID_CAMERA_ROTATE_LEFT].Action_Keyboard_Key)
			CAMERA_ROTATE_RIGHT = Key(Core.IO.Action[AMBIENT_ACTION_ID_CAMERA_ROTATE_RIGHT].Action_Keyboard_Key)
			
		Case AMBIENT_CONTROL_TYPE_JOYSTICK
			
			joy_num = Core.IO.Joystick_Index[control_index]
			
			axis_activation = Core.IO.Joystick[joy_num].AxisActivation
			
			CAMERA_ROTATE_LEFT_BUTTON = JoyButton(joy_num, Core.IO.Joystick[joy_num].Action[AMBIENT_ACTION_ID_CAMERA_ROTATE_LEFT].Action_Joystick_Button)
			CAMERA_ROTATE_LEFT_AXIS = (JoyAxis(joy_num, Core.IO.Joystick[joy_num].Action[AMBIENT_ACTION_ID_CAMERA_ROTATE_LEFT].Action_Joystick_Axis) <= (-1 * axis_activation))
			CAMERA_ROTATE_LEFT = CAMERA_ROTATE_LEFT_BUTTON OR CAMERA_ROTATE_LEFT_AXIS
			
			CAMERA_ROTATE_RIGHT_BUTTON = JoyButton(joy_num, Core.IO.Joystick[joy_num].Action[AMBIENT_ACTION_ID_CAMERA_ROTATE_RIGHT].Action_Joystick_Button)
			CAMERA_ROTATE_RIGHT_AXIS = (JoyAxis(joy_num, Core.IO.Joystick[joy_num].Action[AMBIENT_ACTION_ID_CAMERA_ROTATE_RIGHT].Action_Joystick_Axis) <= (-1 * axis_activation))
			CAMERA_ROTATE_RIGHT = CAMERA_ROTATE_RIGHT_BUTTON OR CAMERA_ROTATE_RIGHT_AXIS
			
	End Select


	Dim cam_x, cam_y, cam_z
	
	player_actor = Core.IO.Platformer_Control[control_index].player_actor
	player_m = Core.IO.Platformer_Control[control_index].player_m
	forward_m = Core.IO.Platformer_Control[control_index].forward_m
	result_m = Core.IO.Platformer_Control[control_index].result_m
	
	current_canvas = ActiveCanvas()
	Canvas(Core.IO.ControlCanvas[control_index])
	
	GetCameraPosition(cam_x, cam_y, cam_z)
	
	Dim px, py, pz
	GetActorPosition(player_actor, px, py, pz)
	
	Dim rx, ry, rz
	GetActorRotation(player_actor, rx, ry, rz)
	
	tx = 1 - (cam_x - px)
	ty = 30 - (cam_y - py)
	tz = -75 -(cam_z - pz)
	
	If Core.IO.Platformer_Control[control_index].mode_switch Then
		Core.IO.Platformer_Control[control_index].mode_switch = False
		SetCameraPosition(px+1, py+30, pz-75)
		SetCameraRotation(0, 0, 0)
	Else
		Dim rv As Ambient_Vector2D
		
		GetActorTransform(player_actor, player_m)
		MultiplyMatrix(player_m, forward_m, result_m)
		Dim mx, my, mz
		GetMatrixTranslation(result_m, mx, my, mz)
		cam_rot_y = Ambient_GetHeading2D(px, pz, mx, mz)
		rv = Ambient_RotatePoint2D(px+1, pz-75, px, pz, 90-cam_rot_y)
		SetCameraPosition(rv.x, py+30, rv.y)
		SetCameraRotation(0, 90-cam_rot_y, 0)
	
	End If
	
	Canvas(current_canvas)
End Function



'This function handles the players controls
Sub Ambient_PlatformPlayer_Control(control_index)
	player_actor = Core.IO.Platformer_Control[control_index].player_actor
	
	PLAYER_KEY_RUN = 0
	PLAYER_KEY_LEFT = 0
	PLAYER_KEY_RIGHT = 0
	PLAYER_KEY_DOWN = 0
	PLAYER_KEY_JUMP = 0
	
	Select Case Core.IO.Active_ControlType[control_index]
		
		Case AMBIENT_CONTROL_TYPE_KEYBOARD_MOUSE
		
			PLAYER_KEY_RUN = Key(Core.IO.Action[AMBIENT_ACTION_ID_UP].Action_Keyboard_Key)
			PLAYER_KEY_LEFT = Key(Core.IO.Action[AMBIENT_ACTION_ID_LEFT].Action_Keyboard_Key)
			PLAYER_KEY_RIGHT = Key(Core.IO.Action[AMBIENT_ACTION_ID_RIGHT].Action_Keyboard_Key)
			PLAYER_KEY_REVERSE = Key(Core.IO.Action[AMBIENT_ACTION_ID_DOWN].Action_Keyboard_Key)
			PLAYER_KEY_JUMP = Key(Core.IO.Action[AMBIENT_ACTION_ID_JUMP].Action_Keyboard_Key)
			
		Case AMBIENT_CONTROL_TYPE_JOYSTICK
			
			joy_num = Core.IO.Joystick_Index[control_index]
			
			axis_activation = Core.IO.Joystick[joy_num].AxisActivation
			
			PLAYER_KEY_RUN_BUTTON = JoyButton(joy_num, Core.IO.Joystick[joy_num].Action[AMBIENT_ACTION_ID_UP].Action_Joystick_Button)
			PLAYER_KEY_RUN_AXIS = (JoyAxis(joy_num, Core.IO.Joystick[joy_num].Action[AMBIENT_ACTION_ID_UP].Action_Joystick_Axis) <= (-1 * axis_activation))
			PLAYER_KEY_RUN = PLAYER_KEY_RUN_BUTTON OR PLAYER_KEY_RUN_AXIS
			
			'Print "Axis: "; PLAYER_KEY_RUN_AXIS
			
			PLAYER_KEY_LEFT_BUTTON = JoyButton(joy_num, Core.IO.Joystick[joy_num].Action[AMBIENT_ACTION_ID_LEFT].Action_Joystick_Button)
			PLAYER_KEY_LEFT_AXIS = (JoyAxis(joy_num, Core.IO.Joystick[joy_num].Action[AMBIENT_ACTION_ID_LEFT].Action_Joystick_Axis) <= (-1 * axis_activation))
			PLAYER_KEY_LEFT = PLAYER_KEY_LEFT_BUTTON OR PLAYER_KEY_LEFT_AXIS
			
			PLAYER_KEY_RIGHT_BUTTON = JoyButton(joy_num, Core.IO.Joystick[joy_num].Action[AMBIENT_ACTION_ID_RIGHT].Action_Joystick_Button)
			PLAYER_KEY_RIGHT_AXIS = (JoyAxis(joy_num, Core.IO.Joystick[joy_num].Action[AMBIENT_ACTION_ID_RIGHT].Action_Joystick_Axis) >= axis_activation)
			PLAYER_KEY_RIGHT = PLAYER_KEY_RIGHT_BUTTON OR PLAYER_KEY_RIGHT_AXIS
			
			PLAYER_KEY_REVERSE_BUTTON = JoyButton(joy_num, Core.IO.Joystick[joy_num].Action[AMBIENT_ACTION_ID_DOWN].Action_Joystick_Button)
			PLAYER_KEY_REVERSE_AXIS = (JoyAxis(joy_num, Core.IO.Joystick[joy_num].Action[AMBIENT_ACTION_ID_DOWN].Action_Joystick_Axis) >= axis_activation)
			PLAYER_KEY_REVERSE = PLAYER_KEY_REVERSE_BUTTON OR PLAYER_KEY_REVERSE_AXIS
			
			PLAYER_KEY_JUMP = JoyButton(joy_num, Core.IO.Joystick[joy_num].Action[AMBIENT_ACTION_ID_JUMP].Action_Joystick_Button)
			
	End Select
	
	'Store the current player animation
	player_animation = GetActorCurrentAnimation(player_actor)
	
	'We need to set the linear and angular factors and velocities to 0 to prevent
	'the forces from being continually applied when the player is idle
	Dim lx, ly, lz
	GetActorLinearFactor(player_actor, lx, ly, lz)
	'SetActorLinearFactor(player_actor, 0, ly, 0)
	Dim ax, ay, az
	GetActorAngularFactor(player_actor, ax, ay, az)
	SetActorAngularFactor(player_actor, 0, 0, 0)
	Dim lfx, lfy, lfz
	GetActorLinearVelocityWorld(player_actor, lfx, lfy, lfz)
	SetActorLinearVelocityWorld(player_actor, 0, lfy, 0)
	Dim afx, afy, afz
	GetActorAngularVelocityWorld(player_actor, afx, afy, afz)
	SetActorAngularVelocityWorld(player_actor, 0, 0, 0)
	ClearActorForces(player_actor)
	action_run = FALSE
	action_jump = FALSE
	
	'If the run key is pressed and the player is on the ground
	'then the current animation is set to the run animation
	If PLAYER_KEY_RUN And Core.IO.Platformer_Control[control_index].player_ground_test Then
		player_animation = Core.IO.Platformer_Control[control_index].player_animation[AMBIENT_PLAYER_ANIMATION_RUN].ID
		action_run = TRUE
	End If
	
	'If the player can jump then set the current animation
	'to the jump animation
	If PLAYER_KEY_JUMP And Core.IO.Platformer_Control[control_index].player_jump_ready Then
		player_animation = Core.IO.Platformer_Control[control_index].player_animation[AMBIENT_PLAYER_ANIMATION_JUMP].ID
		action_jump = TRUE
			If PLAYER_KEY_RUN Then
				Core.IO.Platformer_Control[control_index].player_jump_linear_force = -1 * Core.IO.Platformer_Control[control_index].player_linear_force '-1500
			End If
	End If
	
	'If the player is on the ground and not running then
	'the current animation is set to the idle animation
	If Core.IO.Platformer_Control[control_index].player_ground_test AND (NOT action_run) Then
		player_animation = Core.IO.Platformer_Control[control_index].player_animation[AMBIENT_PLAYER_ANIMATION_IDLE].ID
		SetActorLinearVelocityWorld(player_actor, 0, lfy, 0)
	End If
	
	'If the player is running then apply an impulse to the
	'player
	If action_run Then
		SetActorLinearFactor(player_actor, 1, ly, 1)
		Dim tx, ty, tz
		GetActorLinearVelocityLocal(player_actor, tx, ty, tz)
		If abs(tz) < 20 Then
			ApplyActorCentralImpulseLocal(player_actor, 0, 0, 0 - Core.IO.Platformer_Control[control_index].player_linear_force)
		End If
	End If
	
	'If the player jumps then apply an upward impulse
	If action_jump Then
		SetActorLinearFactor(player_actor, 1, ly, 1)
		ApplyActorCentralImpulseLocal(player_actor, 0, Core.IO.Platformer_Control[control_index].player_jump_force, 0)
		Core.IO.Platformer_Control[control_index].player_jump_ready = FALSE
	End If
	
	'If the player turns then set a torque
	If PLAYER_KEY_LEFT Then
		SetActorAngularFactor(player_actor, 0, 1, 0)
		ApplyActorTorqueImpulseWorld(player_actor, 0, 0 - Core.IO.Platformer_Control[control_index].player_angular_force, 0)
	ElseIf PLAYER_KEY_RIGHT Then
		SetActorAngularFactor(player_actor, 0, 1, 0)
		ApplyActorTorqueImpulseWorld(player_actor, 0, Core.IO.Platformer_Control[control_index].player_angular_force, 0)
	End If
	
	Dim x, y, z
	GetActorPosition(player_actor, x, y, z)

	'Cast a downward ray to check if the player is on the ground
	actor_height = Core.IO.Platformer_Control[control_index].max_bby - Core.IO.Platformer_Control[control_index].min_bby
	n = CastRay3D(x, y, z, x, y - (actor_height/2) - 5, z)
	
	'If n returns 0 hits, then the player is in the air so we set the animation
	'to the jump animation
	If n = 0 Then
		'Print "Air"
		player_animation = Core.IO.Platformer_Control[control_index].player_animation[AMBIENT_PLAYER_ANIMATION_JUMP].ID
		Core.IO.Platformer_Control[control_index].player_ground_test = FALSE
		Core.IO.Platformer_Control[control_index].player_jump_ready = FALSE
		ApplyActorCentralImpulseLocal(player_actor, 0, 0, Core.IO.Platformer_Control[control_index].player_jump_linear_force)
	End If
	
	tmp_stack = CreateStack_N()
	ClearStack_N(tmp_stack)
	
	For i = 0 To Stack_Size_N(Core.IO.Platformer_Control[control_index].level_collision_stack)-1
		level_collision = Pop_N(Core.IO.Platformer_Control[control_index].level_collision_stack)
		Push_N(tmp_stack, level_collision)
		'If n returns a hit or player is colliding with level, then set the ground test flag
		If n Or GetActorCollision(player_actor, level_collision) Then
			Core.IO.Platformer_Control[control_index].player_ground_test = TRUE
			If Not PLAYER_KEY_JUMP Then
				Core.IO.Platformer_Control[control_index].player_jump_ready = TRUE
				Core.IO.Platformer_Control[control_index].player_jump_linear_force = 0
			End If
		End If
	Next
	
	DeleteStack_N(Core.IO.Platformer_Control[control_index].level_collision_stack)
	Core.IO.Platformer_Control[control_index].level_collision_stack = tmp_stack
	
	'Sets the current animation
	If player_animation <> GetActorCurrentAnimation(player_actor) Then
		SetActorAnimation(player_actor, player_animation, -1)
	End If
End Sub


Sub Ambient_PlatformControl_Update(control_index)
	Ambient_PlatformPlayer_Control(control_index)
	Ambient_PlatformPlayer_Camera(control_index)
End Sub