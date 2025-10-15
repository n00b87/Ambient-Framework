Function Ambient_UI_CreateMenu(control_index, w, h, spriteSheet, frame_width, frame_height)
	menu_index = Ambient_UI_Global_Menu_Index
	element_id = Ambient_UI_Global_Element_Index
	
	Ambient_UI_Global_Menu_Index = Ambient_UI_Global_Menu_Index + 1
	Ambient_UI_Global_Element_Index = Ambient_UI_Global_Element_Index + 1
	
	Ambient_UI_InternalArray_Resize()
	
	Ambient_UI_Global_Menu[menu_index].ID = element_id
	Ambient_UI_Global_Menu[menu_index].Parent_ID = -1
	Ambient_UI_Global_Menu[menu_index].Visible = FALSE
	Ambient_UI_Global_Menu[menu_index].Control_Index = control_index
	Ambient_UI_Global_Menu[menu_index].NavigateKeyboard = TRUE
	Ambient_UI_Global_Menu[menu_index].NavigateMouse = TRUE
	Ambient_UI_Global_Menu[menu_index].WrapSelection = FALSE
	Ambient_UI_Global_Menu[menu_index].ActionReady = TRUE
	Ambient_UI_Global_Menu[menu_index].UseHighlightColor = FALSE
	Ambient_UI_Global_Menu[menu_index].HighlightColor = RGB(255,255,255)
	
	For i = 0 To ArraySize(Ambient_UI_Global_Menu[menu_index].SoundEffect, 1) - 1
		Ambient_UI_Global_Menu[menu_index].SoundEffect[i] = -1
	Next
	
	For i = 0 To ArraySize(Ambient_UI_Global_Menu[menu_index].SpriteAnimation, 1) - 1
		Ambient_UI_Global_Menu[menu_index].SpriteAnimation[i] = 0
	Next
	
	Ambient_UI_Global_Menu[menu_index].SpriteSheet = spriteSheet
	Ambient_UI_Global_Menu[menu_index].Sprite_FrameWidth = frame_width
	Ambient_UI_Global_Menu[menu_index].Sprite_FrameHeight = frame_height
	
	Ambient_UI_Global_Menu[menu_index].MenuOptions = DimMatrix(1, 1)
	SetMatrixValue(Ambient_UI_Global_Menu[menu_index].MenuOptions, 0, 0, -1)
	
	Ambient_UI_Global_Menu[menu_index].CurrentItem = 0
	
	Ambient_UI_Global_Menu[menu_index].Width = w
	Ambient_UI_Global_Menu[menu_index].Height = h
	Ambient_UI_Global_Menu[menu_index].OptionWidth = frame_width
	Ambient_UI_Global_Menu[menu_index].OptionHeight = frame_height
	
	z_index = Core.Z_Index
	Core.Z_Index = Core.Z_Index + 3
	
	Ambient_UI_Global_Menu[menu_index].BackCanvas = OpenCanvas(w, h, 0, 0, w, h, 1)
	SetCanvasVisible(Ambient_UI_Global_Menu[menu_index].BackCanvas, FALSE)
	SetCanvasZ(Ambient_UI_Global_Menu[menu_index].BackCanvas, z_index + 2)
	
	Ambient_UI_Global_Menu[menu_index].FrontCanvas = OpenCanvas(w, h, 0, 0, w, h, 1)
	SetCanvasVisible(Ambient_UI_Global_Menu[menu_index].FrontCanvas, FALSE)
	SetCanvasZ(Ambient_UI_Global_Menu[menu_index].FrontCanvas, z_index)
	
	Ambient_UI_Global_Menu[menu_index].SpriteCanvas = OpenCanvasSpriteLayer(0, 0, w, h)
	SetCanvasVisible(Ambient_UI_Global_Menu[menu_index].SpriteCanvas, FALSE)
	SetCanvasZ(Ambient_UI_Global_Menu[menu_index].SpriteCanvas, z_index + 1)
	SetCanvasPhysics2D(Ambient_UI_Global_Menu[menu_index].SpriteCanvas, FALSE)
	
	Ambient_UI_Global_Element_List[element_id, 0] = AMBIENT_UI_ELEMENT_TYPE_MENU
	Ambient_UI_Global_Element_List[element_id, 1] = menu_index
	Ambient_UI_Global_Element_List[element_id, 2] = 0
	Ambient_UI_Global_Element_List[element_id, 3] = 0
	
	Return element_id
End Function

Function Ambient_UI_AddMenuItem(element_id, x, y, text$, text_x, text_y)
	If element_id < 0 Or element_id >= ArraySize(Ambient_UI_Global_Element_List, 1) Then
		Return -1
	End If
	
	menu_index = Ambient_UI_Global_Element_List[element_id, 1]
	
	If Ambient_UI_Global_Element_List[element_id, 0] <> AMBIENT_UI_ELEMENT_TYPE_MENU Then
		Return -1
	End If
	
	If menu_index < 0 Or menu_index >= ArraySize(Ambient_UI_Global_Menu, 1) Then
		Return -1
	End If
	
	item_index = Ambient_UI_Global_MenuOption_Index
	Ambient_UI_Global_MenuOption_Index = Ambient_UI_Global_MenuOption_Index + 1
	
	Ambient_UI_InternalArray_Resize()
	
	Ambient_UI_Global_MenuOption[item_index].Text$ = Trim(text$)
	Ambient_UI_Global_MenuOption[item_index].TextOffsetX = text_x
	Ambient_UI_Global_MenuOption[item_index].TextOffsetY = text_y
	Ambient_UI_Global_MenuOption[item_index].TextColor = RGB(255, 255, 255)
	
	For i = 0 To ArraySize(Ambient_UI_Global_MenuOption[item_index].Animation, 1) - 1
		Ambient_UI_Global_MenuOption[item_index].Animation[i] = Ambient_UI_Global_Menu[menu_index].SpriteAnimation[i]
	Next
	
	Ambient_UI_Global_MenuOption[item_index].OffsetX = x
	Ambient_UI_Global_MenuOption[item_index].OffsetY = y
	
	current_canvas = ActiveCanvas()
	
	spriteSheet = Ambient_UI_Global_Menu[menu_index].SpriteSheet
	
	If ImageExists(spriteSheet) Then
		frame_width = Ambient_UI_Global_Menu[menu_index].Sprite_FrameWidth
		frame_height = Ambient_UI_Global_Menu[menu_index].Sprite_FrameHeight
		Canvas(Ambient_UI_Global_Menu[menu_index].SpriteCanvas)
		Ambient_UI_Global_MenuOption[item_index].Sprite_ID = CreateSprite(spriteSheet, frame_width, frame_height)
	End If
	
	Canvas(current_canvas)
	
	Ambient_UI_Global_Menu[menu_index].NumOptions = Ambient_UI_Global_Menu[menu_index].NumOptions + 1
	
	Dim m_rows, m_cols
	GetMatrixSize(Ambient_UI_Global_Menu[menu_index].MenuOptions, m_rows, m_cols)
	
	If m_cols <> Ambient_UI_Global_Menu[menu_index].NumOptions Then
		new_matrix = DimMatrix(1, Ambient_UI_Global_Menu[menu_index].NumOptions)
		For i = 0 To Ambient_UI_Global_Menu[menu_index].NumOptions-1
			SetMatrixValue(new_matrix, 0, i, MatrixValue(Ambient_UI_Global_Menu[menu_index].MenuOptions, 0, i))
		Next
		DeleteMatrix(Ambient_UI_Global_Menu[menu_index].MenuOptions)
		Ambient_UI_Global_Menu[menu_index].MenuOptions = new_matrix
	End If
	
	SetMatrixValue(Ambient_UI_Global_Menu[menu_index].MenuOptions, 0, Ambient_UI_Global_Menu[menu_index].NumOptions-1, item_index)
	
	Return (Ambient_UI_Global_Menu[menu_index].NumOptions-1)
End Function


Function Ambient_UI_GetMenuItem(element_id, item_num) As Ambient_UI_MenuOption
	Dim null_item As Ambient_UI_MenuOption
	null_item.Text$ = ""
	null_item.TextOffsetX = 0
	null_item.TextOffsetY = 0
	null_item.Sprite_ID = -1
	
	If element_id < 0 Or element_id >= ArraySize(Ambient_UI_Global_Element_List, 1) Then
		Return null_item
	End If
	
	menu_index = Ambient_UI_Global_Element_List[element_id, 1]
	
	If Ambient_UI_Global_Element_List[element_id, 0] <> AMBIENT_UI_ELEMENT_TYPE_MENU Then
		Return null_item
	End If
	
	If menu_index < 0 Or menu_index >= ArraySize(Ambient_UI_Global_Menu, 1) Then
		Return null_item
	End If
	
	
	m_matrix = Ambient_UI_Global_Menu[menu_index].MenuOptions
	
	Dim m_rows, m_cols
	GetMatrixSize(m_matrix, m_rows, m_cols)
	item_index = MatrixValue(m_matrix, 0, item_num)
	
	Return Ambient_UI_Global_MenuOption[item_index]
End Function


Function Ambient_UI_GenerateMenuAnimation(element_id, menu_state, animation_length, ByRef animation_frames, animation_speed)
	If element_id < 0 Or element_id >= ArraySize(Ambient_UI_Global_Element_List, 1) Then
		Return FALSE
	End If
	
	menu_index = Ambient_UI_Global_Element_List[element_id, 1]
	
	If Ambient_UI_Global_Element_List[element_id, 0] <> AMBIENT_UI_ELEMENT_TYPE_MENU Then
		Return FALSE
	End If
	
	If menu_index < 0 Or menu_index >= ArraySize(Ambient_UI_Global_Menu, 1) Then
		Return FALSE
	End If
	
	If menu_state < 0 Or menu_state >= AMBIENT_UI_MAX_ELEMENT_STATES Then
		Return FALSE
	End If
	
	m_matrix = Ambient_UI_Global_Menu[menu_index].MenuOptions
	
	Dim m_rows, m_cols
	GetMatrixSize(m_matrix, m_rows, m_cols)
	
	For i = 0 To m_cols-1
		item_index = MatrixValue(m_matrix, 0, i)
		
		If item_index < 0 Or item_index >= ArraySize(Ambient_UI_Global_MenuOption, 1) Then
			Continue
		End If
		
		item_sprite = Ambient_UI_Global_MenuOption[item_index].Sprite_ID
		Ambient_UI_Global_MenuOption[item_index].Animation[menu_state] = CreateSpriteAnimation(item_sprite, animation_length, animation_speed)
		
		For frame_num = 0 To animation_length-1
			SetSpriteAnimationFrame(item_sprite, Ambient_UI_Global_MenuOption[item_index].Animation[menu_state], frame_num, animation_frames[frame_num])
		Next
	Next
	
	Return TRUE
End Function

Function Ambient_UI_SetMenuItemAnimation(element_id, item_num, menu_state, animation_id)
	If element_id < 0 Or element_id >= ArraySize(Ambient_UI_Global_Element_List, 1) Then
		Return FALSE
	End If
	
	menu_index = Ambient_UI_Global_Element_List[element_id, 1]
	
	If Ambient_UI_Global_Element_List[element_id, 0] <> AMBIENT_UI_ELEMENT_TYPE_MENU Then
		Return FALSE
	End If
	
	If menu_index < 0 Or menu_index >= ArraySize(Ambient_UI_Global_Menu, 1) Then
		Return FALSE
	End If
	
	If menu_state < 0 Or menu_state >= AMBIENT_UI_MAX_ELEMENT_STATES Then
		Return FALSE
	End If
	
	m_matrix = Ambient_UI_Global_Menu[menu_index].MenuOptions
	
	Dim m_rows, m_cols
	GetMatrixSize(m_matrix, m_rows, m_cols)
	item_index = MatrixValue(m_matrix, 0, item_num)
	
	Ambient_UI_Global_MenuOption[item_index].Animation[menu_state] = animation_id
		
	Return TRUE
End Function

Function Ambient_UI_SetMenuSoundEffect(element_id, state_change, sound_id)
	If element_id < 0 Or element_id >= ArraySize(Ambient_UI_Global_Element_List, 1) Then
		Return FALSE
	End If
	
	menu_index = Ambient_UI_Global_Element_List[element_id, 1]
	
	If Ambient_UI_Global_Element_List[element_id, 0] <> AMBIENT_UI_ELEMENT_TYPE_MENU Then
		Return FALSE
	End If
	
	If menu_index < 0 Or menu_index >= ArraySize(Ambient_UI_Global_Menu, 1) Then
		Return FALSE
	End If
	
	If state_change < 0 Or state_change >= AMBIENT_UI_MAX_STATE_CHANGE Then
		Return FALSE
	End If
	
	Ambient_UI_Global_Menu[menu_index].SoundEffect[state_change] = sound_id
	
	Return TRUE
End Function


Function Ambient_UI_UseMenuHighlightColor(element_id, highlight_flag)
	If element_id < 0 Or element_id >= ArraySize(Ambient_UI_Global_Element_List, 1) Then
		Return FALSE
	End If
	
	menu_index = Ambient_UI_Global_Element_List[element_id, 1]
	
	If Ambient_UI_Global_Element_List[element_id, 0] <> AMBIENT_UI_ELEMENT_TYPE_MENU Then
		Return FALSE
	End If
	
	If menu_index < 0 Or menu_index >= ArraySize(Ambient_UI_Global_Menu, 1) Then
		Return FALSE
	End If
	
	Ambient_UI_Global_Menu[menu_index].UseHighlightColor = highlight_flag
	
	Return TRUE
End Function


Function Ambient_UI_SetMenuHighlightColor(element_id, highlight_color)
	If element_id < 0 Or element_id >= ArraySize(Ambient_UI_Global_Element_List, 1) Then
		Return FALSE
	End If
	
	menu_index = Ambient_UI_Global_Element_List[element_id, 1]
	
	If Ambient_UI_Global_Element_List[element_id, 0] <> AMBIENT_UI_ELEMENT_TYPE_MENU Then
		Return FALSE
	End If
	
	If menu_index < 0 Or menu_index >= ArraySize(Ambient_UI_Global_Menu, 1) Then
		Return FALSE
	End If
	
	Ambient_UI_Global_Menu[menu_index].HighlightColor = highlight_color
	
	Return TRUE
End Function


Sub Ambient_UI_Render_Menu(active_menu_flag, menu_index, x, y)
	If menu_index < 0 Or menu_index >= ArraySize(Ambient_UI_Global_Menu, 1) Then
		Return
	End If
	
	control_index = Ambient_UI_Global_Menu[menu_index].Control_Index
	
	If control_index < 0 Or control_index >= AMBIENT_MAX_IO_CONTROLS Then
		Return
	End If
	
	active_menu = -1
	
	If active_menu_flag Then
		active_menu = Ambient_UI_Global_Menu[menu_index].ID
	End If
	
	
	m_width = Ambient_UI_Global_Menu[menu_index].Width
	m_height = Ambient_UI_Global_Menu[menu_index].Height
	
	option_width = Ambient_UI_Global_Menu[menu_index].OptionWidth
	option_height = Ambient_UI_Global_Menu[menu_index].OptionHeight
	
	m_matrix = Ambient_UI_Global_Menu[menu_index].MenuOptions
	
	Dim m_matrix_rows, m_matrix_cols
	GetMatrixSize(m_matrix, m_matrix_rows, m_matrix_cols)
	
	menu_option_array_size = ArraySize(Ambient_UI_Global_MenuOption, 1)
	
	active_item_state = -1
	
	active_item = Ambient_UI_Global_Menu[menu_index].CurrentItem
	
	state_time = Timer() - Core.GameState[control_index].State_Timer
	
	state_change = -1
	
	key_state_delay = 200 'ms
	
	key_state_ready = (state_time >= key_state_delay)
	
	
	If key_state_ready Then
		Core.GameState[control_index].State_Timer = Timer()
	End If
	
	cancel_flag = FALSE
	
	If active_menu = Ambient_UI_Global_Menu[menu_index].ID Then
		Select Case Core.IO.Active_ControlType[control_index]
		
		Case AMBIENT_CONTROL_TYPE_KEYBOARD_MOUSE
			menu_open_key = Core.IO.Action[AMBIENT_ACTION_ID_MENU_OPEN].Action_Keyboard_Key
			menu_previous_key = Core.IO.Action[AMBIENT_ACTION_ID_MENU_PREVIOUS].Action_Keyboard_Key
			menu_next_key = Core.IO.Action[AMBIENT_ACTION_ID_MENU_NEXT].Action_Keyboard_Key
			menu_select_key = Core.IO.Action[AMBIENT_ACTION_ID_MENU_SELECT].Action_Keyboard_Key
			menu_cancel_key = Core.IO.Action[AMBIENT_ACTION_ID_MENU_CANCEL].Action_Keyboard_Key
			
			nav_keyboard = Ambient_UI_Global_Menu[menu_index].NavigateKeyboard
			nav_mouse = Ambient_UI_Global_Menu[menu_index].NavigateMouse
			
			If Key(menu_select_key) And key_state_ready And Ambient_UI_Global_Menu[menu_index].ActionReady Then
				active_item_state = AMBIENT_UI_ELEMENT_STATE_PRESSED
				Ambient_UI_Global_Menu[menu_index].ActionReady = FALSE
			ElseIf Key(menu_cancel_key) And key_state_ready And Ambient_UI_Global_Menu[menu_index].ActionReady Then
				active_item_state = AMBIENT_UI_ELEMENT_STATE_PRESSED
				cancel_flag = TRUE
				Ambient_UI_Global_Menu[menu_index].ActionReady = FALSE
			ElseIf key_state_ready Then
				active_item_state = AMBIENT_UI_ELEMENT_STATE_HIGHLIGHTED
			End If
			
			If Not (Key(menu_cancel_key) Or Key(menu_select_key) Or MouseButton(1) Or MouseButton(3)) Then
				Ambient_UI_Global_Menu[menu_index].ActionReady = TRUE
			End If
			
			If nav_keyboard And Key(menu_previous_key) And key_state_ready Then
				active_item = Ambient_UI_Global_Menu[menu_index].CurrentItem - 1
				'Print "Active Item: "; active_item
				
			ElseIf nav_keyboard And Key(menu_next_key) And key_state_ready Then
				active_item = Ambient_UI_Global_Menu[menu_index].CurrentItem + 1
				'Print "Active Item: "; active_item
				
			ElseIf nav_mouse Then
				mouse_x = MouseX()
				mouse_y = MouseY()
				
				For i = 0 To (m_matrix_cols-1)
					menu_option_index = MatrixValue(m_matrix, 0, i)
					If menu_option_index < 0 Or menu_option_index >= menu_option_array_size Then
						Continue
					End If
					
					mx1 = x + Ambient_UI_Global_MenuOption[menu_option_index].OffsetX
					my1 = y + Ambient_UI_Global_MenuOption[menu_option_index].OffsetY
					
					mx2 = mx1 + option_width
					my2 = my1
					
					mx3 = mx2
					my3 = my2 + option_height
					
					mx4 = mx1
					my4 = my3
					
					If PointInQuad(mouse_x, mouse_y, mx1, my1, mx2, my2, mx3, my3, mx4, my4) Then
						If Distance2D(Core.IO.Prev_MousePosition.X, Core.IO.Prev_MousePosition.Y, MouseX(), MouseY()) >= 1 Then
							active_item = i
						End If
						
						If MouseButton(1) And key_state_ready And Ambient_UI_Global_Menu[menu_index].ActionReady Then
							active_item_state = AMBIENT_UI_ELEMENT_STATE_PRESSED
							Ambient_UI_Global_Menu[menu_index].ActionReady = FALSE
						ElseIf MouseButton(3) And key_state_ready And Ambient_UI_Global_Menu[menu_index].ActionReady Then
							active_item_state = AMBIENT_UI_ELEMENT_STATE_PRESSED
							cancel_flag = TRUE
							Ambient_UI_Global_Menu[menu_index].ActionReady = FALSE
						ElseIf active_item_state <> AMBIENT_UI_ELEMENT_STATE_PRESSED Then
							active_item_state = AMBIENT_UI_ELEMENT_STATE_HIGHLIGHTED
						End If
						
						Exit For
					End If
				Next
			End If
			
		Case AMBIENT_CONTROL_TYPE_JOYSTICK
			joy_num = Core.IO.Joystick_Index[control_index]
	
			menu_open_jbutton = -1
			menu_previous_jbutton = -1
			menu_next_jbutton = -1
			menu_select_jbutton = -1
			menu_cancel_jbutton = -1
			
			If joy_num >= 0 And joy_num < AMBIENT_MAX_JOYSTICKS Then
				menu_open_jbutton = Core.IO.Joystick[joy_num].Action[AMBIENT_ACTION_ID_MENU_OPEN].Action_Joystick_Button
				menu_previous_jbutton = Core.IO.Joystick[joy_num].Action[AMBIENT_ACTION_ID_MENU_PREVIOUS].Action_Joystick_Button
				menu_next_jbutton = Core.IO.Joystick[joy_num].Action[AMBIENT_ACTION_ID_MENU_NEXT].Action_Joystick_Button
				menu_select_jbutton = Core.IO.Joystick[joy_num].Action[AMBIENT_ACTION_ID_MENU_SELECT].Action_Joystick_Button
				menu_cancel_jbutton = Core.IO.Joystick[joy_num].Action[AMBIENT_ACTION_ID_MENU_CANCEL].Action_Joystick_Button
			End If
		
			If JoyButton(joy_num, menu_select_jbutton) And key_state_ready And Ambient_UI_Global_Menu[menu_index].ActionReady Then
				active_item_state = AMBIENT_UI_ELEMENT_STATE_PRESSED
				Ambient_UI_Global_Menu[menu_index].ActionReady = FALSE
			ElseIf JoyButton(joy_num, menu_cancel_jbutton) And key_state_ready And Ambient_UI_Global_Menu[menu_index].ActionReady Then
				active_item_state = AMBIENT_UI_ELEMENT_STATE_PRESSED
				cancel_flag = TRUE
				Ambient_UI_Global_Menu[menu_index].ActionReady = FALSE
			ElseIf key_state_ready Then
				active_item_state = AMBIENT_UI_ELEMENT_STATE_HIGHLIGHTED
			End If
			
			If Not (JoyButton(joy_num, menu_cancel_jbutton) Or JoyButton(joy_num, menu_select_jbutton)) Then
				Ambient_UI_Global_Menu[menu_index].ActionReady = TRUE
			End If
			
			If JoyButton(joy_num, menu_previous_jbutton) And key_state_ready Then
				active_item = Ambient_UI_Global_Menu[menu_index].CurrentItem - 1
				'Print "Active Item: "; active_item
				
			ElseIf JoyButton(joy_num, menu_next_jbutton) And key_state_ready Then
				active_item = Ambient_UI_Global_Menu[menu_index].CurrentItem + 1
				'Print "Active Item: "; active_item
			End If
		
		Case AMBIENT_CONTROL_TYPE_TOUCH
			'TODO
		
		End Select
	End If
	
	
	If active_item >= 0 And active_item < m_matrix_cols And active_item <> Ambient_UI_Global_Menu[menu_index].CurrentItem Then
		state_change = AMBIENT_UI_STATE_CHANGE_ITEM_CHANGE
	End If
	
	If active_item_state = AMBIENT_UI_ELEMENT_STATE_PRESSED Then
		If cancel_flag Then
			state_change = AMBIENT_UI_STATE_CHANGE_CANCEL
		Else
			state_change = AMBIENT_UI_STATE_CHANGE_ITEM_SELECT
		End If
	End If
	
	
	If Ambient_UI_Global_Menu[menu_index].WrapSelection Then
		If active_item < 0 Then
			active_item = m_matrix_cols-1
		ElseIf active_item >= m_matrix_cols Then
			active_item = 0
		End If
	Else
		If active_item < 0 Then
			active_item = 0
		ElseIf active_item >= m_matrix_cols Then
			active_item = m_matrix_cols - 1
		End If
	End If
	
	Ambient_UI_Global_Menu[menu_index].CurrentItem = active_item
	
	current_canvas = ActiveCanvas()
	
	'Set Menu option positions
	Canvas(Ambient_UI_Global_Menu[menu_index].SpriteCanvas)
	
	For i = 0 To (m_matrix_cols-1)
		menu_option_index = MatrixValue(m_matrix, 0, i)
		If menu_option_index < 0 Or menu_option_index >= menu_option_array_size Then
			Continue
		End If
		
		sprite_id = Ambient_UI_Global_MenuOption[menu_option_index].Sprite_ID
		mx = Ambient_UI_Global_MenuOption[menu_option_index].OffsetX
		my = Ambient_UI_Global_MenuOption[menu_option_index].OffsetY
		
		If Not SpriteExists(sprite_id) Then
			Continue
		End If
		
		SetSpriteVisible(sprite_id, TRUE)
		SetSpritePosition(sprite_id, mx, my)
		
		If active_item = i Then
			'Print "Active Item: "; i
			If Ambient_UI_Global_MenuOption[menu_option_index].State <> active_item_state And active_item_state >= 0 Then
				'Print "Active Item: "; i
				'Print "Set Animation State: "; active_item_state
				If active_item_state >= 0 And active_item_state < ArraySize(Ambient_UI_Global_MenuOption[menu_option_index].Animation, 1) Then
					SetSpriteAnimation(Ambient_UI_Global_MenuOption[menu_option_index].Sprite_ID, Max(Ambient_UI_Global_MenuOption[menu_option_index].Animation[active_item_state], 0), -1)
				Else
					SetSpriteAnimation(Ambient_UI_Global_MenuOption[menu_option_index].Sprite_ID, 0, -1)
				End If
				
			End If
			
			If state_change >= 0 Then
				If Ambient_UI_Global_Menu[menu_index].SoundEffect[state_change] >= 0 Then
					If SoundExists(Ambient_UI_Global_Menu[menu_index].SoundEffect[state_change]) Then
						StopSound(AMBIENT_SOUND_CHANNEL_UI)
						PlaySound(Ambient_UI_Global_Menu[menu_index].SoundEffect[state_change], AMBIENT_SOUND_CHANNEL_UI, 0)
					End If
				End If
			End If
			
			Ambient_UI_Global_MenuOption[menu_option_index].State = active_item_state
		Else
			If Ambient_UI_Global_MenuOption[menu_option_index].State <> 0 Then
				SetSpriteAnimation(Ambient_UI_Global_MenuOption[menu_option_index].Sprite_ID, Max(Ambient_UI_Global_MenuOption[menu_option_index].Animation[0], 0), -1)
			End If
			
			Ambient_UI_Global_MenuOption[menu_option_index].State = 0
		End If
		
	Next
	
	Ambient_UI_Global_Menu[menu_index].State = state_change
	
	'Set Menu Text positions
	front_canvas = Ambient_UI_Global_Menu[menu_index].FrontCanvas
	Canvas(front_canvas)
	ClearCanvas()
	
	SetFont(Core.UI_Font)
	
	For i = 0 To (m_matrix_cols-1)
		menu_option_index = MatrixValue(m_matrix, 0, i)
		If menu_option_index < 0 Or menu_option_index >= menu_option_array_size Then
			Continue
		End If
		
		sprite_id = Ambient_UI_Global_MenuOption[menu_option_index].Sprite_ID
		mx = Ambient_UI_Global_MenuOption[menu_option_index].OffsetX
		my = Ambient_UI_Global_MenuOption[menu_option_index].OffsetY
		
		If Ambient_UI_Global_MenuOption[menu_option_index].Text$ <> "" Then
			Canvas(Core.Tmp_Canvas)
			ClearCanvas()
			
			If Ambient_UI_Global_Menu[menu_index].CurrentItem = i And Ambient_UI_Global_Menu[menu_index].UseHighlightColor Then
				SetColor(Ambient_UI_Global_Menu[menu_index].HighlightColor)
			Else
				SetColor(Ambient_UI_Global_MenuOption[menu_option_index].TextColor)
			End If
			
			DrawText(Ambient_UI_Global_MenuOption[menu_option_index].Text$, Ambient_UI_Global_MenuOption[menu_option_index].TextOffsetX, Ambient_UI_Global_MenuOption[menu_option_index].TextOffsetY)
			img = CanvasClip(0, 0, option_width, option_height)
			ColorKey(img, -1)
			Canvas(front_canvas)
			DrawImage(img, mx, my)
			DeleteImage(img)
		End If
	Next
	
	
	Canvas(current_canvas)
	
	SetCanvasViewport(Ambient_UI_Global_Menu[menu_index].BackCanvas, x, y, m_width, m_height)
	SetCanvasOffset(Ambient_UI_Global_Menu[menu_index].BackCanvas, 0, 0)
	SetCanvasVisible(Ambient_UI_Global_Menu[menu_index].BackCanvas, TRUE)
	
	SetCanvasViewport(Ambient_UI_Global_Menu[menu_index].SpriteCanvas, x, y, m_width, m_height)
	SetCanvasOffset(Ambient_UI_Global_Menu[menu_index].SpriteCanvas, 0, 0)
	SetCanvasVisible(Ambient_UI_Global_Menu[menu_index].SpriteCanvas, TRUE)
	
	SetCanvasViewport(Ambient_UI_Global_Menu[menu_index].FrontCanvas, x, y, m_width, m_height)
	SetCanvasOffset(Ambient_UI_Global_Menu[menu_index].FrontCanvas, 0, 0)
	SetCanvasVisible(Ambient_UI_Global_Menu[menu_index].FrontCanvas, TRUE)
End Sub




Sub Ambient_UI_OpenMenu(element_id)
	If element_id < 0 Or element_id >= ArraySize(Ambient_UI_Global_Element_List, 1) Then
		Return
	End If
	
	If Ambient_UI_Global_Element_List[element_id, 0] <> AMBIENT_UI_ELEMENT_TYPE_MENU Then
		Return
	End If
	
	menu_index = Ambient_UI_Global_Element_List[element_id, 1]
	
	If menu_index < 0 Or menu_index >= ArraySize(Ambient_UI_Global_Menu, 1) Then
		Return
	End If
	
	If Ambient_UI_IsVisible(element_id) Then
		Return
	End If
	
	control_index = Ambient_UI_Global_Menu[menu_index].Control_Index
	
	If control_index < 0 Or control_index >= AMBIENT_MAX_IO_CONTROLS Then
		Return
	End If
	
	
	
	m_stack = Core.GameState[control_index].ActiveMenu_Stack
	Ambient_UI_SetVisible(element_id, TRUE)
	
	Push_N(m_stack, element_id)
	
	If Core.GameState[control_index].State <> AMBIENT_GAME_STATE_MENU Then
		Core.GameState[control_index].Prev_State = Core.GameState[control_index].State
		Core.GameState[control_index].State = AMBIENT_GAME_STATE_MENU
	End If
	
End Sub


Sub Ambient_UI_CloseMenu(control_index)
	If control_index < 0 Or control_index >= AMBIENT_MAX_IO_CONTROLS Then
		Return
	End If
	
	m_stack = Core.GameState[control_index].ActiveMenu_Stack
	
	If Stack_Size_N(m_stack) > 0 Then
		element_id = Pop_N(m_stack)
		
		menu_index = -1
		
		If element_id >= 0 Or element_id < ArraySize(Ambient_UI_Global_Element_List, 1) Then
			menu_index = Ambient_UI_Global_Element_List[element_id, 1]
			Ambient_UI_SetVisible(element_id, FALSE)
		End If
	
		If menu_index >= 0 Or menu_index < ArraySize(Ambient_UI_Global_Menu, 1) Then
			SetCanvasVisible(Ambient_UI_Global_Menu[menu_index].BackCanvas, FALSE)
			SetCanvasVisible(Ambient_UI_Global_Menu[menu_index].SpriteCanvas, FALSE)
			SetCanvasVisible(Ambient_UI_Global_Menu[menu_index].FrontCanvas, FALSE)
		End If
	Else
		Return
	End If
	
	If Stack_Size_N(m_stack) <= 0 Then
		Core.GameState[control_index].State = Core.GameState[control_index].Prev_State
		
		If Core.GameState[control_index].State = AMBIENT_GAME_STATE_MENU Then
			Core.GameState[control_index].State = AMBIENT_GAME_STATE_NONE
		End If
	End If
	
End Sub

