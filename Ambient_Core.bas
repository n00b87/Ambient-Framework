Include Once
Include "serenity.bas"
Include "Ambient_Structures.bas"

'CORE OBJECT
'-----------------------------------------
Dim Core As Ambient_Core


'WINDOW PROPERTIES
'-----------------------------------------
Function Ambient_GetWindowSize() As Ambient_Size
	Return Core.WindowSize
End Function

Function Ambient_SetWindowSize(w, h)
	If WindowExists() Then
		SetWindowSize(w, h)
		GetWindowSize(Core.WindowSize.Width, Core.WindowSize.Height)
		Return ( (Core.WindowSize.Width = w) AND (Core.WindowSize.Height = h) )
	End If
	Return FALSE
End Function

Function Ambient_GetWindowFullscreen()
	Return Core.Fullscreen
End Function

Function Ambient_SetWindowFullscreen(flag)
	If WindowExists() Then
		SetWindowFullscreen(flag)
		Core.Fullscreen = WindowIsFullscreen()
		Return (Core.Fullscreen = flag)
	End If
	Return FALSE
End Function

Function Ambient_GetWindowVSync()
	Return Core.VSync
End Function

Function Ambient_SetWindowVSync(flag)
	If WindowExists() Then
		Core.VSync = flag 'RCBasic does not have a function built-in to return the VSync flag; I will make sure to add it to the next release
		SetWindowVSync(flag)
		Return TRUE
	End If
	Return FALSE
End Function

Function Ambient_GetWindowTargetFPS()
	Return Core.TargetFPS
End Function

Function Ambient_SetWindowTargetFPS(tgt_fps)
	If WindowExists() Then
		SetFPS(tgt_fps)
		Core.TargetFPS = tgt_fps
		Return TRUE
	End If
	Return FALSE
End Function


'GAME STATE
'----------------------------------------
Function Ambient_GetGameState(control_index)
	Return Core.GameState[control_index].State
End Function

Sub Ambient_SetGameState(control_index, n_state)
	Core.GameState[control_index].State = n_state
End Sub


'IO
'----------------------------------------
Include "Ambient_Joystick.bas"
Include "Ambient_CharacterControl_FPS.bas"
Include "Ambient_CharacterControl_Platformer.bas"


Sub Ambient_SetCameraControl(cam_control_index, canvas_id, camera_control_type)
	Core.CameraControlType[cam_control_index] = camera_control_type
	
	Core.IO.ControlCanvas[cam_control_index] = canvas_id
	
	Core.IO.Joystick_Index[cam_control_index] = -1
	
	Select Case Core.CameraControlType[cam_control_index]
	Case AMBIENT_CAMERA_CONTROL_FIRST_PERSON_KEYBOARD_ONLY
		Ambient_SetCharacterControllerFPS(false)
		Core.IO.Active_ControlType[cam_control_index] = AMBIENT_CONTROL_TYPE_KEYBOARD_MOUSE
	Case AMBIENT_CAMERA_CONTROL_FIRST_PERSON_KEYBOARD_MOUSE
		Ambient_SetCharacterControllerFPS(true)
		Core.IO.Active_ControlType[cam_control_index] = AMBIENT_CONTROL_TYPE_KEYBOARD_MOUSE
	Case AMBIENT_CAMERA_CONTROL_FIRST_PERSON_JOYSTICK
		Core.IO.Active_ControlType[cam_control_index] = AMBIENT_CONTROL_TYPE_JOYSTICK
		If Core.IO.Joystick_Index[cam_control_index] < 0 Then
			Core.IO.Joystick_Index[cam_control_index] = 0
		End If
	Case AMBIENT_CAMERA_CONTROL_FIRST_PERSON_TOUCH
		Core.IO.Active_ControlType[cam_control_index] = AMBIENT_CONTROL_TYPE_TOUCH
		
	Default
		Core.IO.Active_ControlType[cam_control_index] = AMBIENT_CONTROL_TYPE_KEYBOARD_MOUSE
	End Select
End Sub

Sub Ambient_SetControlJoystick(control_index, joystick_id)
	Core.IO.Joystick_Index[control_index] = joystick_id
End Sub
	
Sub Ambient_SetActionKey(action_id, controller_type, key_value)
	If action_id < 0 OR action_id >= AMBIENT_MAX_ACTION_KEYS Then
		Return
	End If
	
	Select Case controller_type
	Case AMBIENT_CONTROL_TYPE_KEYBOARD_MOUSE
		Core.IO.Action[action_id].Action_Keyboard_Key = key_value
	Case AMBIENT_CONTROL_TYPE_JOYSTICK
		Core.IO.Action[action_id].Action_Joystick_Button = key_value
	End Select
End Sub

Function Ambient_AddActionKey()
	action_key_index = AMBIENT_ACTION_INDEX
	AMBIENT_ACTION_INDEX = AMBIENT_ACTION_INDEX + 1
	Return action_key_index
End Function


'WINDOW MANAGEMENT
'----------------------------------------
Sub Ambient_Init(title$, w, h, fullscreen, vsync, tgt_fps)
	OpenWindowEx(title$, WINDOWPOS_CENTERED, WINDOWPOS_CENTERED, w, h, WindowMode(1,fullscreen,0,0,0), 0, true, vsync)
	SetFPS(tgt_fps)
	
	'Initial Windows Properties
	Core.WindowSize.Width = w
	Core.WindowSize.Height = h
	Core.Fullscreen = fullscreen
	Core.VSync = vsync
	Core.TargetFPS = tgt_fps
	
	Core.Tmp_Canvas = OpenCanvas(w, h, 0, 0, w, h, 1)
	SetCanvasVisible(Core.Tmp_Canvas, FALSE)
	
	Core.UI_Font = LoadFont("fonts/FreeMono.ttf", 12)
	
	'Default Camera Control
	For cam_control_index = 0 To AMBIENT_MAX_IO_CONTROLS-1
		Core.CameraControlType[cam_control_index] = -1
		Core.IO.Active_ControlType[cam_control_index] = -1
		Core.IO.ControlCanvas[cam_control_index] = -1
		Core.IO.Joystick_Index[cam_control_index] = -1
	Next
	
	Core.CameraControlType[0] = AMBIENT_CAMERA_CONTROL_FIRST_PERSON_KEYBOARD_ONLY
	Core.IO.Active_ControlType[0] = AMBIENT_CONTROL_TYPE_KEYBOARD_MOUSE
	
	'Default FPS Properties
	For i = 0 To AMBIENT_MAX_FPS_CONTROLS-1
		Core.IO.FPS_CameraControl[i].MoveSpeed = 10
		Core.IO.FPS_CameraControl[i].Sensitivity = 0.5
		Core.IO.FPS_CameraControl[i].Controller_Type = -1
		Core.IO.FPS_CameraControl[i].MinAngle = -85
		Core.IO.FPS_CameraControl[i].MaxAngle = 85
	Next
	
	'Initialize Platformer Controller
	For i = 0 To AMBIENT_MAX_IO_CONTROLS-1
		Ambient_PlatformerControl_Init(i)
	Next
	
	'Default Game State
	For control_index = 0 To AMBIENT_MAX_IO_CONTROLS-1
		Core.GameState[control_index].State = AMBIENT_GAME_STATE_CHARACTER_CONTROL
		Core.GameState[control_index].ActiveMenu_Stack = CreateStack_N()
		ClearStack_N(Core.GameState[control_index].ActiveMenu_Stack)
		Core.GameState[control_index].ActiveTextField_ID = -1
		Core.GameState[control_index].TextField_Stack = CreateStack_N()
	Next
	
	'Default Keyboard Action Keys
	Core.IO.Action[AMBIENT_ACTION_ID_UP].Action_Keyboard_Key = K_W
	Core.IO.Action[AMBIENT_ACTION_ID_DOWN].Action_Keyboard_Key = K_S
	Core.IO.Action[AMBIENT_ACTION_ID_LEFT].Action_Keyboard_Key = K_A
	Core.IO.Action[AMBIENT_ACTION_ID_RIGHT].Action_Keyboard_Key = K_D
	
	Core.IO.Action[AMBIENT_ACTION_ID_UP_2].Action_Keyboard_Key = K_UP
	Core.IO.Action[AMBIENT_ACTION_ID_DOWN_2].Action_Keyboard_Key = K_DOWN
	Core.IO.Action[AMBIENT_ACTION_ID_LEFT_2].Action_Keyboard_Key = K_LEFT
	Core.IO.Action[AMBIENT_ACTION_ID_RIGHT_2].Action_Keyboard_Key = K_RIGHT
	
	Core.IO.Action[AMBIENT_ACTION_ID_RAISE].Action_Keyboard_Key = K_R
	Core.IO.Action[AMBIENT_ACTION_ID_LOWER].Action_Keyboard_Key = K_F
	
	Core.IO.Action[AMBIENT_ACTION_ID_MENU_OPEN].Action_Keyboard_Key = K_TAB
	Core.IO.Action[AMBIENT_ACTION_ID_MENU_PREVIOUS].Action_Keyboard_Key = K_UP
	Core.IO.Action[AMBIENT_ACTION_ID_MENU_NEXT].Action_Keyboard_Key = K_DOWN
	Core.IO.Action[AMBIENT_ACTION_ID_MENU_SELECT].Action_Keyboard_Key = K_RETURN
	Core.IO.Action[AMBIENT_ACTION_ID_MENU_CANCEL].Action_Keyboard_Key = K_ESCAPE
	
	Core.IO.Action[AMBIENT_ACTION_ID_CAMERA_ROTATE_UP].Action_Keyboard_Key = -1
	Core.IO.Action[AMBIENT_ACTION_ID_CAMERA_ROTATE_DOWN].Action_Keyboard_Key = -1
	Core.IO.Action[AMBIENT_ACTION_ID_CAMERA_ROTATE_LEFT].Action_Keyboard_Key = -1
	Core.IO.Action[AMBIENT_ACTION_ID_CAMERA_ROTATE_RIGHT].Action_Keyboard_Key = -1
	
	Core.IO.Action[AMBIENT_ACTION_ID_JUMP].Action_Keyboard_Key = K_SPACE
	
	
	'Default Joystick Action Keys
	For i = 0 To AMBIENT_MAX_JOYSTICKS-1
		Core.IO.Joystick[i].AxisActivation = 4000
		
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_CAMERA_ROTATE_UP].Action_Joystick_Button = -1
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_CAMERA_ROTATE_UP].Action_Joystick_Axis = -1
		
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_CAMERA_ROTATE_UP].Min_X = -32768
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_CAMERA_ROTATE_UP].Max_X = 32767
		
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_CAMERA_ROTATE_UP].Min_Y = -32768
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_CAMERA_ROTATE_UP].Max_Y = 32767
		
		
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_CAMERA_ROTATE_DOWN].Action_Joystick_Button = -1
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_CAMERA_ROTATE_DOWN].Action_Joystick_Axis = -1
		
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_CAMERA_ROTATE_DOWN].Min_X = -32768
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_CAMERA_ROTATE_DOWN].Max_X = 32767
		
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_CAMERA_ROTATE_DOWN].Min_Y = -32768
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_CAMERA_ROTATE_DOWN].Max_Y = 32767
		
		
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_CAMERA_ROTATE_LEFT].Action_Joystick_Button = 9
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_CAMERA_ROTATE_LEFT].Action_Joystick_Axis = -1
		
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_CAMERA_ROTATE_LEFT].Min_X = -32768
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_CAMERA_ROTATE_LEFT].Max_X = 32767
		
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_CAMERA_ROTATE_LEFT].Min_Y = -32768
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_CAMERA_ROTATE_LEFT].Max_Y = 32767
		
		
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_CAMERA_ROTATE_RIGHT].Action_Joystick_Button = 10
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_CAMERA_ROTATE_RIGHT].Action_Joystick_Axis = -1
		
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_CAMERA_ROTATE_RIGHT].Min_X = -32768
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_CAMERA_ROTATE_RIGHT].Max_X = 32767
		
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_CAMERA_ROTATE_RIGHT].Min_Y = -32768
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_CAMERA_ROTATE_RIGHT].Max_Y = 32767
		
		
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_JUMP].Action_Joystick_Button = 0
		
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_LEFT].Action_Joystick_Button = -1
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_LEFT].Action_Joystick_Axis = 0
		
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_LEFT].Min_X = -32768
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_LEFT].Max_X = 32767
		
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_LEFT].Min_Y = -32768
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_LEFT].Max_Y = 32767
		
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_RIGHT].Action_Joystick_Button = -1
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_RIGHT].Action_Joystick_Axis = 0
		
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_RIGHT].Min_X = -32768
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_RIGHT].Max_X = 32767
		
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_RIGHT].Min_Y = -32768
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_RIGHT].Max_Y = 32767
		
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_UP].Action_Joystick_Button = -1
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_UP].Action_Joystick_Axis = 1
		
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_UP].Min_X = -32768
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_UP].Max_X = 32767
		
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_UP].Min_Y = -32768
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_UP].Max_Y = 32767
		
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_DOWN].Action_Joystick_Button = -1
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_DOWN].Action_Joystick_Axis = 1
		
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_DOWN].Min_X = -32768
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_DOWN].Max_X = 32767
		
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_DOWN].Min_Y = -32768
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_DOWN].Max_Y = 32767
		
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_LEFT_2].Action_Joystick_Button = -1
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_LEFT_2].Action_Joystick_Axis = 2
		
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_LEFT_2].Min_X = -32768
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_LEFT_2].Max_X = 32767
		
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_LEFT_2].Min_Y = -32768
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_LEFT_2].Max_Y = 32767
		
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_RIGHT_2].Action_Joystick_Button = -1
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_RIGHT_2].Action_Joystick_Axis = 2
		
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_RIGHT_2].Min_X = -32768
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_RIGHT_2].Max_X = 32767
		
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_RIGHT_2].Min_Y = -32768
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_RIGHT_2].Max_Y = 32767
		
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_UP_2].Action_Joystick_Button = -1
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_UP_2].Action_Joystick_Axis = 3
		
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_UP_2].Min_X = -32768
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_UP_2].Max_X = 32767
		
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_UP_2].Min_Y = -32768
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_UP_2].Max_Y = 32767
		
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_DOWN_2].Action_Joystick_Button = -1
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_DOWN_2].Action_Joystick_Axis = 3
		
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_DOWN_2].Min_X = -32768
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_DOWN_2].Max_X = 32767
		
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_DOWN_2].Min_Y = -32768
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_DOWN_2].Max_Y = 32767
		
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_RAISE].Action_Joystick_Button = 9
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_LOWER].Action_Joystick_Button = 10
		
		
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_MENU_OPEN].Action_Joystick_Button = 3
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_MENU_PREVIOUS].Action_Joystick_Button = 11
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_MENU_NEXT].Action_Joystick_Button = 12
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_MENU_SELECT].Action_Joystick_Button = 0
		Core.IO.Joystick[i].Action[AMBIENT_ACTION_ID_MENU_CANCEL].Action_Joystick_Button = 1
		
	Next
End Sub


'UI
Include "Ambient_UI_Core.bas"


'UPDATE
'----------------------------------------
Sub Ambient_AutoConfigureGameState()
	Dim mx, my, mb1, mb2, mb3
	For control_index = 0 To AMBIENT_MAX_IO_CONTROLS-1
		If Core.IO.Active_ControlType[control_index] = AMBIENT_CONTROL_TYPE_TOUCH Then
			Continue
		End If
		
		c_type = -1
		
		If Core.IO.Joystick_Index[control_index] < 0 Then
			Continue
		End If
		
		joy_num = Core.IO.Joystick_Index[control_index]
		
		If Not JoystickIsConnected(joy_num) Then
			Continue
		End If
		
		For i = 0 To NumJoyButtons(joy_num)-1
			If JoyButton(joy_num, i) Then
				c_type = AMBIENT_CONTROL_TYPE_JOYSTICK
				Exit For
			End If
		Next
		
		If c_type < 0 Then
			If InKey <> 0 Then
				c_type = AMBIENT_CONTROL_TYPE_KEYBOARD_MOUSE
			ElseIf MouseButton(1) Or MouseButton(2) Or MouseButton(3) Then
				c_type = AMBIENT_CONTROL_TYPE_KEYBOARD_MOUSE
			End If
		End If
		
		'Only set type if it changed
		If c_type >= 0 Then
			Core.IO.Active_ControlType[control_index] = c_type
		End If
	Next
End Sub

Sub Ambient_CharacterControl_Update()
	
	For control_index = 0 To AMBIENT_MAX_IO_CONTROLS-1
	
		If Core.GameState[control_index].State <> AMBIENT_GAME_STATE_CHARACTER_CONTROL Then
			Continue
		End If
		
		Select Case Core.IO.Active_ControlType[control_index]
		
		Case AMBIENT_CONTROL_TYPE_KEYBOARD_MOUSE
			
			Select Case Core.CameraControlType[control_index]
			
			Case AMBIENT_CAMERA_CONTROL_FIRST_PERSON_KEYBOARD_ONLY
				Ambient_FPSControl_Keyboard_Only(control_index)
			
			Case AMBIENT_CAMERA_CONTROL_FIRST_PERSON_KEYBOARD_MOUSE
				Ambient_FPSControl_Keyboard_Mouse(control_index)
				
			Case AMBIENT_CAMERA_CONTROL_THIRD_PERSON
				Ambient_PlatformControl_Update(control_index)
			
			End Select
		
		Case AMBIENT_CONTROL_TYPE_JOYSTICK
		
			Select Case Core.CameraControlType[control_index]
			
			Case AMBIENT_CAMERA_CONTROL_FIRST_PERSON_JOYSTICK
				Ambient_FPSControl_Joystick(control_index)
			
			Case AMBIENT_CAMERA_CONTROL_THIRD_PERSON
				Ambient_PlatformControl_Update(control_index)
			
			End Select
		
		Case AMBIENT_CONTROL_TYPE_TOUCH
		
			Select Case Core.CameraControlType[control_index]
			
			Case AMBIENT_CAMERA_CONTROL_FIRST_PERSON_TOUCH
				Ambient_FPSControl_Touch(control_index)
				
			Case AMBIENT_CAMERA_CONTROL_THIRD_PERSON
				Ambient_PlatformControl_Update(control_index)
				
			End Select
		
		End Select	
	
	Next
	
	'Update the state for each Joystick
	'For i = 0 To AMBIENT_MAX_JOYSTICKS-1
	'	Ambient_UpdateJoystickState(i)
	'Next
End Sub

Sub Ambient_UI_Update()
	tmp_stack = CreateStack_N()
	
	SHOW_MENUS = TRUE
	SHOW_TEXTFIELDS = TRUE
	
	For control_index = 0 To AMBIENT_MAX_IO_CONTROLS-1
		'----------MENUS---------------
		If SHOW_MENUS Then
			ClearStack_N(tmp_stack)
			For i = 0 To Stack_Size_N(Core.GameState[control_index].ActiveMenu_Stack)-1
				element_id = Pop_N(Core.GameState[control_index].ActiveMenu_Stack)
				
				active_menu_flag = FALSE
				If i = 0 Then
					active_menu_flag = (Core.GameState[control_index].ActiveTextField_ID < 0)
				End If
				
				Push_N(tmp_stack, element_id)
				
				If Not Ambient_UI_IsVisible(element_id) Then
					Continue
				End If
				
				If Ambient_UI_Global_Element_List[element_id, 0] = AMBIENT_UI_ELEMENT_TYPE_MENU Then
					x = Ambient_UI_Global_Element_List[element_id, 2]
					y = Ambient_UI_Global_Element_List[element_id, 3]
					Ambient_UI_Render_Menu(active_menu_flag, Ambient_UI_Global_Element_List[element_id, 1], x, y)
				End If
			Next
			
			For i = 0 To Stack_Size_N(tmp_stack)-1
				Push_N(Core.GameState[control_index].ActiveMenu_Stack, Pop_N(tmp_stack))
			Next
		End If
		
		
		'----------TEXTFIELDS---------------
		If SHOW_TEXTFIELDS Then
			ClearStack_N(tmp_stack)
			For i = 0 To Stack_Size_N(Core.GameState[control_index].TextField_Stack) - 1
				element_id = Pop_N(Core.GameState[control_index].TextField_Stack)
				
				Push_N(tmp_stack, element_id)
				
				
				If element_id >= 0 And element_id < ArraySize(Ambient_UI_Global_Element_List, 1) Then
					tf_index = Ambient_UI_Global_Element_List[element_id, 1]
					x = Ambient_UI_Global_Element_List[element_id, 2]
					y = Ambient_UI_Global_Element_List[element_id, 3]
					
					active_tfield_flag = (element_id = Core.GameState[control_index].ActiveTextField_ID)
					
					Ambient_UI_Render_TextField(active_tfield_flag, tf_index, x, y)
				End If
			Next
			
			For i = 0 To Stack_Size_N(tmp_stack)-1
				Push_N(Core.GameState[control_index].TextField_Stack, Pop_N(tmp_stack))
			Next
		End If
	Next
	
	DeleteStack_N(tmp_stack)
	
	'TODO: Other UI Elements Here
	
End Sub

Sub Ambient_Update()
	'Assign Joysticks to control_index
	Dim connected_joystick[AMBIENT_MAX_IO_CONTROLS]
	Dim used_joystick[AMBIENT_MAX_IO_CONTROLS]
	
	ArrayFill(connected_joystick, FALSE)
	ArrayFill(used_joystick, FALSE)
	
	
	For i = 0 To ArraySize(Core.IO.Joystick_Index, 1)-1
		If JoystickIsConnected(i) Then
			connected_joystick[i] = TRUE
		End If
		
		If Not JoystickIsConnected(Core.IO.Joystick_Index[i]) Then
			Core.IO.Joystick_Index[i] = -1
		End If
		
		If Core.IO.Joystick_Index[i] >= 0 And Core.IO.Joystick_Index[i] < AMBIENT_MAX_IO_CONTROLS Then
			used_joystick[ Core.IO.Joystick_Index[i] ] = TRUE
		End If
	Next
	
	For i = 0 To AMBIENT_MAX_IO_CONTROLS-1
		If Core.IO.Joystick_Index[i] < 0 Then
			For joy_num = 0 To AMBIENT_MAX_IO_CONTROLS-1
				If connected_joystick[joy_num] And (Not used_joystick[joy_num]) Then
					Core.IO.Joystick_Index[i] = joy_num
					used_joystick[joy_num] = TRUE
					Exit For
				End If
			Next
		End If
	Next
	
	'Check if Textfield is active
	TFIELD_ACTIVE = FALSE
	tmp_stack = CreateStack_N()
	For control_index = 0 To AMBIENT_MAX_IO_CONTROLS-1
		ClearStack_N(tmp_stack)
		For i = 0 To Stack_Size_N(Core.GameState[control_index].TextField_Stack) - 1
			element_id = Pop_N(Core.GameState[control_index].TextField_Stack)
			Push_N(tmp_stack, element_id)
			
			If element_id >= 0 And element_id < ArraySize(Ambient_UI_Global_Element_List, 1) Then
				
				tf_index = Ambient_UI_Global_Element_List[element_id, 1]
			
				If tf_index >= 0 Or tf_index < ArraySize(Ambient_UI_Global_TextField, 1) Then
					If Ambient_UI_Global_TextField[tf_index].Editable Then
						TFIELD_ACTIVE = TRUE
						'Print "TF: "; tf_index
						Exit For
					End If
				End If
				
			End If
		Next
		
		For i = 0 To Stack_Size_N(tmp_stack) - 1
			Push_N(Core.GameState[control_index].TextField_Stack, Pop_N(tmp_stack))
		Next
	Next
	
	DeleteStack_N(tmp_stack)

	Ambient_AutoConfigureGameState()
	Ambient_UI_Update()
	
	If Not TFIELD_ACTIVE Then
		Ambient_CharacterControl_Update()
	End If
	
	Core.IO.Prev_MousePosition.X = MouseX()
	Core.IO.Prev_MousePosition.Y = MouseY()
	
	Update()
End Sub


