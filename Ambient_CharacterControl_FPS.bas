Include Once

Sub Ambient_SetCharacterControllerFPS(flag)
	If flag Then
		SetMouseRelative(true)
	Else
		SetMouseRelative(false)
	End If
End Sub

Sub Ambient_MouseDelta_FPS(cam_control_index, ByRef dx, ByRef dy)
	move_mouse = false
	
	Core.IO.FPS_CameraControl[cam_control_index].prev_mx = Core.IO.FPS_CameraControl[cam_control_index].mx
	Core.IO.FPS_CameraControl[cam_control_index].prev_my = Core.IO.FPS_CameraControl[cam_control_index].my
	
	GetMouse(Core.IO.FPS_CameraControl[cam_control_index].mx, Core.IO.FPS_CameraControl[cam_control_index].my, Core.IO.FPS_CameraControl[cam_control_index].mb1, Core.IO.FPS_CameraControl[cam_control_index].mb2, Core.IO.FPS_CameraControl[cam_control_index].mb3)
	
	Dim w, h
	GetCanvasSize(Core.IO.ControlCanvas[cam_control_index], w, h)
	w = w-1
	h = h-1
	
	If Core.IO.FPS_CameraControl[cam_control_index].mx <= 0 And Core.IO.FPS_CameraControl[cam_control_index].prev_mx > 0 Then
		Core.IO.FPS_CameraControl[cam_control_index].mx = w
		move_mouse = True
	ElseIf Core.IO.FPS_CameraControl[cam_control_index].mx >= w And Core.IO.FPS_CameraControl[cam_control_index].prev_mx < w Then
		Core.IO.FPS_CameraControl[cam_control_index].mx = 0
		move_mouse = True
	End If
    
  If Core.IO.FPS_CameraControl[cam_control_index].my <= 0 And Core.IO.FPS_CameraControl[cam_control_index].prev_my > 0 Then
		Core.IO.FPS_CameraControl[cam_control_index].my = h
		move_mouse = True
	ElseIf Core.IO.FPS_CameraControl[cam_control_index].my >= h And Core.IO.FPS_CameraControl[cam_control_index].prev_my < h Then
		Core.IO.FPS_CameraControl[cam_control_index].my = 0
		move_mouse = True
	End If
	
	If move_mouse Then
		WarpMouse(Core.IO.FPS_CameraControl[cam_control_index].mx, Core.IO.FPS_CameraControl[cam_control_index].my)
		dx = 0
		dy = 0
	Else
		dx = Core.IO.FPS_CameraControl[cam_control_index].mx - Core.IO.FPS_CameraControl[cam_control_index].prev_mx
		dy = Core.IO.FPS_CameraControl[cam_control_index].my - Core.IO.FPS_CameraControl[cam_control_index].prev_my
	End If
End Sub


Sub Ambient_FPSControl_Keyboard_Mouse(cam_control_index)
	If Core.IO.ControlCanvas[cam_control_index] < 0 Then
		Return
	End If
	
	MOVE_FORWARD_KEY = Core.IO.Action[AMBIENT_ACTION_ID_UP].Action_Keyboard_Key
	MOVE_BACKWARD_KEY = Core.IO.Action[AMBIENT_ACTION_ID_DOWN].Action_Keyboard_Key
	MOVE_LEFT_KEY = Core.IO.Action[AMBIENT_ACTION_ID_LEFT].Action_Keyboard_Key
	MOVE_RIGHT_KEY = Core.IO.Action[AMBIENT_ACTION_ID_RIGHT].Action_Keyboard_Key
	
	RAISE_KEY = Core.IO.Action[AMBIENT_ACTION_ID_RAISE].Action_Keyboard_Key
	LOWER_KEY = Core.IO.Action[AMBIENT_ACTION_ID_LOWER].Action_Keyboard_Key
	
	
	current_canvas = ActiveCanvas()
	Canvas(Core.IO.ControlCanvas[cam_control_index])

	Dim dx, dy
	Ambient_MouseDelta_FPS(cam_control_index, dx, dy)
	
	dx = dx * Core.IO.FPS_CameraControl[cam_control_index].Sensitivity
	dy = dy * Core.IO.FPS_CameraControl[cam_control_index].Sensitivity
	
	dim xr,yr,zr
	GetCameraRotation(xr, yr, zr)
	SetCameraRotation(xr, yr+dx, zr)
	
	'Print "DY = "; xr + dy
	If (xr + dy) >= Core.IO.FPS_CameraControl[cam_control_index].MinAngle And (xr + dy) <= Core.IO.FPS_CameraControl[cam_control_index].MaxAngle Then
		RotateCamera(dy, 0, 0)
	End If
	
	If Key(MOVE_FORWARD_KEY) Then
		TranslateCamera(0,0,Core.IO.FPS_CameraControl[cam_control_index].MoveSpeed)
    ElseIf Key(MOVE_BACKWARD_KEY) Then
		TranslateCamera(0,0,-1*Core.IO.FPS_CameraControl[cam_control_index].MoveSpeed)
	End If

	If Key(MOVE_LEFT_KEY) Then 
		TranslateCamera(-1*Core.IO.FPS_CameraControl[cam_control_index].MoveSpeed,0,0)
	ElseIf Key(MOVE_RIGHT_KEY) Then
		TranslateCamera(Core.IO.FPS_CameraControl[cam_control_index].MoveSpeed,0,0)
	End If

	If Key(RAISE_KEY) Then
		Dim crx, cry, crz
		GetCameraPosition(crx, cry, crz)
		SetCameraPosition(crx, cry+Core.IO.FPS_CameraControl[cam_control_index].MoveSpeed, crz)
	ElseIf Key(LOWER_KEY) Then
		Dim crx, cry, crz
		GetCameraPosition(crx, cry, crz)
		SetCameraPosition(crx, cry-Core.IO.FPS_CameraControl[cam_control_index].MoveSpeed, crz)
	End If
	
	Canvas(current_canvas)
End Sub


Sub Ambient_FPSControl_Keyboard_Only(cam_control_index)
	If Core.IO.ControlCanvas[cam_control_index] < 0 Then
		Return
	End If
	
	current_canvas = ActiveCanvas()
	Canvas(Core.IO.ControlCanvas[cam_control_index])
	
	MOVE_FORWARD_KEY = Core.IO.Action[AMBIENT_ACTION_ID_UP].Action_Keyboard_Key
	MOVE_BACKWARD_KEY = Core.IO.Action[AMBIENT_ACTION_ID_DOWN].Action_Keyboard_Key
	MOVE_LEFT_KEY = Core.IO.Action[AMBIENT_ACTION_ID_LEFT].Action_Keyboard_Key
	MOVE_RIGHT_KEY = Core.IO.Action[AMBIENT_ACTION_ID_RIGHT].Action_Keyboard_Key
	
	LOOK_UP_KEY = Core.IO.Action[AMBIENT_ACTION_ID_UP_2].Action_Keyboard_Key
	LOOK_DOWN_KEY = Core.IO.Action[AMBIENT_ACTION_ID_DOWN_2].Action_Keyboard_Key
	LOOK_LEFT_KEY = Core.IO.Action[AMBIENT_ACTION_ID_LEFT_2].Action_Keyboard_Key
	LOOK_RIGHT_KEY = Core.IO.Action[AMBIENT_ACTION_ID_RIGHT_2].Action_Keyboard_Key
	
	RAISE_KEY = Core.IO.Action[AMBIENT_ACTION_ID_RAISE].Action_Keyboard_Key
	LOWER_KEY = Core.IO.Action[AMBIENT_ACTION_ID_LOWER].Action_Keyboard_Key
	
	If Key(MOVE_FORWARD_KEY) Then
		TranslateCamera(0,0,Core.IO.FPS_CameraControl[cam_control_index].MoveSpeed)
   ElseIf Key(MOVE_BACKWARD_KEY) Then
		TranslateCamera(0,0,-1 * Core.IO.FPS_CameraControl[cam_control_index].MoveSpeed)
	End If

	If Key(MOVE_LEFT_KEY) Then 
		TranslateCamera(-1 * Core.IO.FPS_CameraControl[cam_control_index].MoveSpeed,0,0)
	ElseIf Key(MOVE_RIGHT_KEY) Then
		TranslateCamera(Core.IO.FPS_CameraControl[cam_control_index].MoveSpeed,0,0)
	End If

	If Key(RAISE_KEY) Then
		Dim crx, cry, crz
		GetCameraPosition(crx, cry, crz)
		SetCameraPosition(crx, cry+Core.IO.FPS_CameraControl[cam_control_index].MoveSpeed, crz)
	ElseIf Key(LOWER_KEY) Then
		Dim crx, cry, crz
		GetCameraPosition(crx, cry, crz)
		SetCameraPosition(crx, cry-Core.IO.FPS_CameraControl[cam_control_index].MoveSpeed, crz)
	End If


	rotate_speed = Core.IO.FPS_CameraControl[cam_control_index].MoveSpeed * Core.IO.FPS_CameraControl[cam_control_index].Sensitivity
	
	If Key(LOOK_UP_KEY) Then
		RotateCamera(rotate_speed, 0, 0)
	ElseIf Key(LOOK_DOWN_KEY) Then
		RotateCamera(-1 * rotate_speed, 0, 0)
	End If

	If Key(LOOK_LEFT_KEY) Then
		Dim crx, cry, crz
		GetCameraRotation(crx, cry, crz)
		RotateCamera(-1*crx, 0, 0)
		RotateCamera(0, -1 * rotate_speed, 0)
		RotateCamera(crx, 0, 0)
	ElseIf Key(LOOK_RIGHT_KEY) Then
		Dim crx, cry, crz
		GetCameraRotation(crx, cry, crz)
		SetCameraRotation(crx, cry+rotate_speed, crz)
	End If
	
	Canvas(current_canvas)
End Sub


Sub Ambient_FPSControl_Joystick(cam_control_index)
	If Core.IO.ControlCanvas[cam_control_index] < 0 Then
		Return
	End If
	
	current_canvas = ActiveCanvas()
	Canvas(Core.IO.ControlCanvas[cam_control_index])
	
	joy_num = Core.IO.Joystick_Index[cam_control_index]
	
	If joy_num < 0 Then
		Return
	End If
	
	MOVE_HORIZONTAL_AXIS = Core.IO.Joystick[joy_num].Action[AMBIENT_ACTION_ID_LEFT].Action_Joystick_Axis
	MOVE_VERTICAL_AXIS = Core.IO.Joystick[joy_num].Action[AMBIENT_ACTION_ID_UP].Action_Joystick_Axis
	
	LOOK_HORIZONTAL_AXIS = Core.IO.Joystick[joy_num].Action[AMBIENT_ACTION_ID_LEFT_2].Action_Joystick_Axis
	LOOK_VERTICAL_AXIS = Core.IO.Joystick[joy_num].Action[AMBIENT_ACTION_ID_UP_2].Action_Joystick_Axis
	
	min_x = Core.IO.Joystick[joy_num].Action[AMBIENT_ACTION_ID_LEFT].Min_X
	max_x = Core.IO.Joystick[joy_num].Action[AMBIENT_ACTION_ID_LEFT].Max_X
	
	min_y = Core.IO.Joystick[joy_num].Action[AMBIENT_ACTION_ID_UP].Min_Y
	max_y = Core.IO.Joystick[joy_num].Action[AMBIENT_ACTION_ID_UP].Max_Y
	
	RAISE_KEY = Core.IO.Joystick[joy_num].Action[AMBIENT_ACTION_ID_RAISE].Action_Joystick_Button
	LOWER_KEY = Core.IO.Joystick[joy_num].Action[AMBIENT_ACTION_ID_LOWER].Action_Joystick_Button
	
	hz = JoyAxis(joy_num, MOVE_HORIZONTAL_AXIS)
	vt = JoyAxis(joy_num, MOVE_VERTICAL_AXIS)
	
	hz_pct = Abs(hz) / (Abs(hz)+Abs(vt))
	vt_pct = Abs(vt) / (Abs(hz)+Abs(vt))
	
	move_speed = Core.IO.FPS_CameraControl[cam_control_index].MoveSpeed
	
	move_horizontal = (JoyAxis(joy_num, MOVE_HORIZONTAL_AXIS) / max_x) * (move_speed * hz_pct)
	move_vertical = (JoyAxis(joy_num, MOVE_VERTICAL_AXIS) / max_y) * (move_speed * vt_pct) * -1
	
	If Abs(hz) < Core.IO.Joystick[joy_num].AxisActivation Then
		move_horizontal = 0
	End If
	
	If Abs(vt) < Core.IO.Joystick[joy_num].AxisActivation Then
		move_vertical = 0
	End If
	
	'print "spd: "; move_horizontal;", "; JoyAxis(joy_num, MOVE_HORIZONTAL_AXIS);", "; max_x;", "; move_speed;", ";hz_pct
	
	TranslateCamera(move_horizontal,0,move_vertical)
	

	If JoyButton(joy_num, RAISE_KEY) Then
		Dim crx, cry, crz
		GetCameraPosition(crx, cry, crz)
		SetCameraPosition(crx, cry+Core.IO.FPS_CameraControl[cam_control_index].MoveSpeed, crz)
	ElseIf JoyButton(joy_num, LOWER_KEY) Then
		Dim crx, cry, crz
		GetCameraPosition(crx, cry, crz)
		SetCameraPosition(crx, cry-Core.IO.FPS_CameraControl[cam_control_index].MoveSpeed, crz)
	End If


	rotate_speed = Core.IO.FPS_CameraControl[cam_control_index].MoveSpeed * Core.IO.FPS_CameraControl[cam_control_index].Sensitivity
	
	hz = JoyAxis(joy_num, LOOK_HORIZONTAL_AXIS)
	vt = JoyAxis(joy_num, LOOK_VERTICAL_AXIS)
	
	hz_pct = Abs(hz) / (Abs(hz)+Abs(vt))
	vt_pct = Abs(vt) / (Abs(hz)+Abs(vt))
	
	look_horizontal = (JoyAxis(joy_num, LOOK_HORIZONTAL_AXIS) / max_x) * (rotate_speed * hz_pct)
	look_vertical = (JoyAxis(joy_num, LOOK_VERTICAL_AXIS) / max_y) * (rotate_speed * vt_pct)
	
	If Abs(hz) < Core.IO.Joystick[joy_num].AxisActivation Then
		look_horizontal = 0
	End If
	
	If Abs(vt) < Core.IO.Joystick[joy_num].AxisActivation Then
		look_vertical = 0
	End If
	
	RotateCamera(look_vertical, 0, 0)

	Dim crx, cry, crz
	GetCameraRotation(crx, cry, crz)
	SetCameraRotation(crx, cry+look_horizontal, crz)
	
	Canvas(current_canvas)
End Sub


Sub Ambient_FPSControl_Touch(cam_control_index)
End Sub