Include "strings.bas"


Function Ambient_UI_CreateTextField(control_index, viewport_w, viewport_h)
	tf_index = Ambient_UI_Global_TextField_Index
	element_id = Ambient_UI_Global_Element_Index
	
	Ambient_UI_Global_TextField_Index = Ambient_UI_Global_TextField_Index + 1
	Ambient_UI_Global_Element_Index = Ambient_UI_Global_Element_Index + 1
	
	Ambient_UI_InternalArray_Resize()
	
	Ambient_UI_Global_TextField[tf_index].ID = element_id
	Ambient_UI_Global_TextField[tf_index].Parent_ID = -1
	Ambient_UI_Global_TextField[tf_index].Visible = FALSE
	Ambient_UI_Global_TextField[tf_index].Control_Index = control_index
	
	Ambient_UI_Global_TextField[tf_index].Font_Type = AMBIENT_UI_FONT_TYPE_TEXT
	Ambient_UI_Global_TextField[tf_index].Font_ID = Core.UI_Font
	Ambient_UI_Global_TextField[tf_index].Font_Tilesheet_ID = -1
	Ambient_UI_Global_TextField[tf_index].Font_Tileset_ID = -1
	Ambient_UI_Global_TextField[tf_index].Font_Tilemap_ID = -1
	
	Ambient_UI_Global_TextField[tf_index].ScrollPosition.X = 0
	Ambient_UI_Global_TextField[tf_index].ScrollPosition.Y = 0
	
	Ambient_UI_Global_TextField[tf_index].Editable = TRUE
	
	
	Dim t_width, t_height
	If FontExists(Ambient_UI_Global_TextField[tf_index].Font_ID) Then
		SetFont(Ambient_UI_Global_TextField[tf_index].Font_ID)
		GetTextSize("X", t_width, t_height)
	End If
	
	Ambient_UI_Global_TextField[tf_index].Rows = Int(viewport_h / t_height)
	Ambient_UI_Global_TextField[tf_index].Columns = Int(viewport_w / t_width)	
	
	
	Ambient_UI_Global_TextField[tf_index].BorderColor = 0
	Ambient_UI_Global_TextField[tf_index].BkgColor = RGB(255, 255, 255)
	Ambient_UI_Global_TextField[tf_index].TextColor = RGB(0, 0, 0)
	Ambient_UI_Global_TextField[tf_index].Highlight_BkgColor = RGB(169, 236, 245)
	Ambient_UI_Global_TextField[tf_index].Highlight_TextColor = RGB(0, 0, 0)
	
	Ambient_UI_Global_TextField[tf_index].Cursor.Style = AMBIENT_UI_CURSOR_STYLE_FLASHING_BOX
	Ambient_UI_Global_TextField[tf_index].Cursor.Color = RGB(0, 0, 0)
	Ambient_UI_Global_TextField[tf_index].Cursor.Position = 0
	Ambient_UI_Global_TextField[tf_index].Cursor.Visible = TRUE	
	
	
	Ambient_UI_Global_TextField[tf_index].Text$ = ""
	Ambient_UI_Global_TextField[tf_index].WrapText = TRUE
	
	Ambient_UI_Global_TextField[tf_index].CrawlText = FALSE
	
	Ambient_UI_Global_TextField[tf_index].Width = viewport_w
	Ambient_UI_Global_TextField[tf_index].Height = viewport_h
	
	
	'''START HERE
	z_index = Core.Z_Index
	Core.Z_Index = Core.Z_Index + 2
	
	w = viewport_w
	h = viewport_h
	
	Ambient_UI_Global_TextField[tf_index].Manual_BackCanvas_Render = FALSE
	Ambient_UI_Global_TextField[tf_index].BackCanvas = OpenCanvas(w, h, 0, 0, w, h, 1)
	SetCanvasVisible(Ambient_UI_Global_TextField[tf_index].BackCanvas, FALSE)
	SetCanvasZ(Ambient_UI_Global_TextField[tf_index].BackCanvas, z_index + 1)
	
	Ambient_UI_Global_TextField[tf_index].FrontCanvas = OpenCanvas(w, h, 0, 0, w, h, 1)
	SetCanvasVisible(Ambient_UI_Global_TextField[tf_index].FrontCanvas, FALSE)
	SetCanvasZ(Ambient_UI_Global_TextField[tf_index].FrontCanvas, z_index)
	
	
	Ambient_UI_Global_Element_List[element_id, 0] = AMBIENT_UI_ELEMENT_TYPE_TEXTFIELD
	Ambient_UI_Global_Element_List[element_id, 1] = tf_index
	Ambient_UI_Global_Element_List[element_id, 2] = 0
	Ambient_UI_Global_Element_List[element_id, 3] = 0
	
	Return element_id
End Function


Sub Ambient_UI_OpenTextField(element_id)
	If element_id < 0 Or element_id >= ArraySize(Ambient_UI_Global_Element_List, 1) Then
		Return
	End If
	
	If Ambient_UI_Global_Element_List[element_id, 0] <> AMBIENT_UI_ELEMENT_TYPE_TEXTFIELD Then
		Return
	End If
	
	tf_index = Ambient_UI_Global_Element_List[element_id, 1]
	
	If tf_index < 0 Or tf_index >= ArraySize(Ambient_UI_Global_TextField, 1) Then
		Return
	End If
	
	control_index = Ambient_UI_Global_TextField[tf_index].Control_Index
	
	If control_index < 0 Or control_index >= AMBIENT_MAX_IO_CONTROLS Then
		Return
	End If
	
	If Ambient_UI_Global_TextField[tf_index].Editable And Core.GameState[control_index].ActiveTextField_ID < 0 Then
		ReadInput_Start()
		ReadInput_SetText(Ambient_UI_Global_TextField[tf_index].Text$)
		Core.GameState[control_index].ActiveTextField_ID = element_id
	End If
	
	Push_N(Core.GameState[control_index].TextField_Stack, element_id)
End Sub


Sub Ambient_UI_SetTextFieldFocus(element_id)
	If element_id < 0 Or element_id >= ArraySize(Ambient_UI_Global_Element_List, 1) Then
		Return
	End If
	
	If Ambient_UI_Global_Element_List[element_id, 0] <> AMBIENT_UI_ELEMENT_TYPE_TEXTFIELD Then
		Return
	End If
	
	tf_index = Ambient_UI_Global_Element_List[element_id, 1]
	
	If tf_index < 0 Or tf_index >= ArraySize(Ambient_UI_Global_TextField, 1) Then
		Return
	End If
	
	control_index = Ambient_UI_Global_TextField[tf_index].Control_Index
	
	If control_index < 0 Or control_index >= AMBIENT_MAX_IO_CONTROLS Then
		Return
	End If
	
	If Ambient_UI_Global_TextField[tf_index].Editable Then
		ReadInput_Stop()
		ReadInput_Start()
		ReadInput_SetText(Ambient_UI_Global_TextField[tf_index].Text$)
		Core.GameState[control_index].ActiveTextField_ID = element_id
	End If
End Sub



Sub Ambient_UI_CloseTextField(element_id)
	If element_id < 0 Or element_id >= ArraySize(Ambient_UI_Global_Element_List, 1) Then
		Return
	End If
	
	If Ambient_UI_Global_Element_List[element_id, 0] <> AMBIENT_UI_ELEMENT_TYPE_TEXTFIELD Then
		Return
	End If
	
	tf_index = Ambient_UI_Global_Element_List[element_id, 1]
	
	If tf_index < 0 Or tf_index >= ArraySize(Ambient_UI_Global_TextField, 1) Then
		Return
	End If
	
	control_index = Ambient_UI_Global_TextField[tf_index].Control_Index
	
	If control_index < 0 Or control_index >= AMBIENT_MAX_IO_CONTROLS Then
		Return
	End If
	
	
	If Core.GameState[control_index].ActiveTextField_ID = element_id Then
		ReadInput_Stop()
		Core.GameState[control_index].ActiveTextField_ID = -1
	End If
	
	tmp_stack = CreateStack_N()
	
	For i = 0 To Stack_Size_N(Core.GameState[control_index].TextField_Stack) - 1
		tf_id = Pop_N(Core.GameState[control_index].TextField_Stack)
		If tf_id <> element_id Then
			Push_N(tmp_stack, tf_id)
		End If
	Next
	
	ClearStack_N(Core.GameState[control_index].TextField_Stack)
	
	For i = 0 To Stack_Size_N(tmp_stack) - 1
		Push_N(Core.GameState[control_index].TextField_Stack, Pop_N(tmp_stack))
	Next
	
	DeleteStack_N(tmp_stack)
End Sub


Sub Ambient_UI_SetTextFieldScroll(element_id, tf_col, tf_row)
	If element_id < 0 Or element_id >= ArraySize(Ambient_UI_Global_Element_List, 1) Then
		Return
	End If
	
	If Ambient_UI_Global_Element_List[element_id, 0] <> AMBIENT_UI_ELEMENT_TYPE_TEXTFIELD Then
		Return
	End If
	
	tf_index = Ambient_UI_Global_Element_List[element_id, 1]
	
	If tf_index < 0 Or tf_index >= ArraySize(Ambient_UI_Global_TextField, 1) Then
		Return
	End If
	
	control_index = Ambient_UI_Global_TextField[tf_index].Control_Index
	
	If control_index < 0 Or control_index >= AMBIENT_MAX_IO_CONTROLS Then
		Return
	End If
	
	Ambient_UI_Global_TextField[tf_index].ScrollPosition.X = tf_col
	Ambient_UI_Global_TextField[tf_index].ScrollPosition.Y = tf_row
End Sub


Sub Ambient_UI_SetTextFieldEditable(element_id, edit_flag)
	If element_id < 0 Or element_id >= ArraySize(Ambient_UI_Global_Element_List, 1) Then
		Return
	End If
	
	If Ambient_UI_Global_Element_List[element_id, 0] <> AMBIENT_UI_ELEMENT_TYPE_TEXTFIELD Then
		Return
	End If
	
	tf_index = Ambient_UI_Global_Element_List[element_id, 1]
	
	If tf_index < 0 Or tf_index >= ArraySize(Ambient_UI_Global_TextField, 1) Then
		Return
	End If
	
	control_index = Ambient_UI_Global_TextField[tf_index].Control_Index
	
	If control_index < 0 Or control_index >= AMBIENT_MAX_IO_CONTROLS Then
		Return
	End If
	
	Ambient_UI_Global_TextField[tf_index].Editable = edit_flag
	
	If edit_flag Then
		If Core.GameState[control_index].ActiveTextField_ID < 0 Then
			Core.GameState[control_index].ActiveTextField_ID = element_id
			ReadInput_Stop()
			ReadInput_Start()
			ReadInput_SetText(Ambient_UI_Global_TextField[tf_index].Text$)
		End If
	Else
		If Core.GameState[control_index].ActiveTextField_ID = element_id Then
			Core.GameState[control_index].ActiveTextField_ID = -1
			ReadInput_Stop()
		End If
	End If
End Sub


Sub Ambient_UI_SetTextFieldFont(element_id, font_id)
	If element_id < 0 Or element_id >= ArraySize(Ambient_UI_Global_Element_List, 1) Then
		Return
	End If
	
	If Ambient_UI_Global_Element_List[element_id, 0] <> AMBIENT_UI_ELEMENT_TYPE_TEXTFIELD Then
		Return
	End If
	
	tf_index = Ambient_UI_Global_Element_List[element_id, 1]
	
	If tf_index < 0 Or tf_index >= ArraySize(Ambient_UI_Global_TextField, 1) Then
		Return
	End If
	
	control_index = Ambient_UI_Global_TextField[tf_index].Control_Index
	
	If control_index < 0 Or control_index >= AMBIENT_MAX_IO_CONTROLS Then
		Return
	End If
	
	Ambient_UI_Global_TextField[tf_index].Font_ID = font_id
End Sub


Sub Ambient_UI_SetTextFieldFontColor(element_id, font_color)
	If element_id < 0 Or element_id >= ArraySize(Ambient_UI_Global_Element_List, 1) Then
		Return
	End If
	
	If Ambient_UI_Global_Element_List[element_id, 0] <> AMBIENT_UI_ELEMENT_TYPE_TEXTFIELD Then
		Return
	End If
	
	tf_index = Ambient_UI_Global_Element_List[element_id, 1]
	
	If tf_index < 0 Or tf_index >= ArraySize(Ambient_UI_Global_TextField, 1) Then
		Return
	End If
	
	control_index = Ambient_UI_Global_TextField[tf_index].Control_Index
	
	If control_index < 0 Or control_index >= AMBIENT_MAX_IO_CONTROLS Then
		Return
	End If
	
	Ambient_UI_Global_TextField[tf_index].TextColor = font_color
End Sub


Sub Ambient_UI_SetTextFieldValue(element_id, txt$)
	If element_id < 0 Or element_id >= ArraySize(Ambient_UI_Global_Element_List, 1) Then
		Return
	End If
	
	If Ambient_UI_Global_Element_List[element_id, 0] <> AMBIENT_UI_ELEMENT_TYPE_TEXTFIELD Then
		Return
	End If
	
	tf_index = Ambient_UI_Global_Element_List[element_id, 1]
	
	If tf_index < 0 Or tf_index >= ArraySize(Ambient_UI_Global_TextField, 1) Then
		Return
	End If
	
	control_index = Ambient_UI_Global_TextField[tf_index].Control_Index
	
	If control_index < 0 Or control_index >= AMBIENT_MAX_IO_CONTROLS Then
		Return
	End If
	
	Ambient_UI_Global_TextField[tf_index].Text$ = txt$
	
	If Ambient_UI_Global_TextField[tf_index].Editable And Core.GameState[control_index].ActiveTextField_ID = element_id Then
		ReadInput_SetText(txt$)
	End If
End Sub


Sub Ambient_UI_SetTextFieldWrap(element_id, wrap_flag)
	If element_id < 0 Or element_id >= ArraySize(Ambient_UI_Global_Element_List, 1) Then
		Return
	End If
	
	If Ambient_UI_Global_Element_List[element_id, 0] <> AMBIENT_UI_ELEMENT_TYPE_TEXTFIELD Then
		Return
	End If
	
	tf_index = Ambient_UI_Global_Element_List[element_id, 1]
	
	If tf_index < 0 Or tf_index >= ArraySize(Ambient_UI_Global_TextField, 1) Then
		Return
	End If
	
	control_index = Ambient_UI_Global_TextField[tf_index].Control_Index
	
	If control_index < 0 Or control_index >= AMBIENT_MAX_IO_CONTROLS Then
		Return
	End If
	
	Ambient_UI_Global_TextField[tf_index].WrapText = wrap_flag
End Sub


Sub Ambient_UI_OverrideTextFieldBkg(element_id, bkg_flag)
	If element_id < 0 Or element_id >= ArraySize(Ambient_UI_Global_Element_List, 1) Then
		Return
	End If
	
	If Ambient_UI_Global_Element_List[element_id, 0] <> AMBIENT_UI_ELEMENT_TYPE_TEXTFIELD Then
		Return
	End If
	
	tf_index = Ambient_UI_Global_Element_List[element_id, 1]
	
	If tf_index < 0 Or tf_index >= ArraySize(Ambient_UI_Global_TextField, 1) Then
		Return
	End If
	
	control_index = Ambient_UI_Global_TextField[tf_index].Control_Index
	
	If control_index < 0 Or control_index >= AMBIENT_MAX_IO_CONTROLS Then
		Return
	End If
	
	Ambient_UI_Global_TextField[tf_index].Manual_BackCanvas_Render = bkg_flag
End Sub


Sub Ambient_UI_SetTextFieldCrawl(element_id, crawl_flag)
	If element_id < 0 Or element_id >= ArraySize(Ambient_UI_Global_Element_List, 1) Then
		Return
	End If
	
	If Ambient_UI_Global_Element_List[element_id, 0] <> AMBIENT_UI_ELEMENT_TYPE_TEXTFIELD Then
		Return
	End If
	
	tf_index = Ambient_UI_Global_Element_List[element_id, 1]
	
	If tf_index < 0 Or tf_index >= ArraySize(Ambient_UI_Global_TextField, 1) Then
		Return
	End If
	
	control_index = Ambient_UI_Global_TextField[tf_index].Control_Index
	
	If control_index < 0 Or control_index >= AMBIENT_MAX_IO_CONTROLS Then
		Return
	End If
	
	Ambient_UI_Global_TextField[tf_index].CrawlText = crawl_flag
	Ambient_UI_Global_TextField[tf_index].Crawl_Timer = Timer()
End Sub


Sub Ambient_UI_SetTextFieldCrawlDelay(element_id, crawl_delay)
	If element_id < 0 Or element_id >= ArraySize(Ambient_UI_Global_Element_List, 1) Then
		Return
	End If
	
	If Ambient_UI_Global_Element_List[element_id, 0] <> AMBIENT_UI_ELEMENT_TYPE_TEXTFIELD Then
		Return
	End If
	
	tf_index = Ambient_UI_Global_Element_List[element_id, 1]
	
	If tf_index < 0 Or tf_index >= ArraySize(Ambient_UI_Global_TextField, 1) Then
		Return
	End If
	
	control_index = Ambient_UI_Global_TextField[tf_index].Control_Index
	
	If control_index < 0 Or control_index >= AMBIENT_MAX_IO_CONTROLS Then
		Return
	End If
	
	Ambient_UI_Global_TextField[tf_index].Crawl_Delay = crawl_delay
End Sub




Sub Ambient_UI_SetAttributes(attr_param$)
	attr_param$ = attr_param$ + ";"
	cmd_set = 0
	cmd$ = ""
	Dim arg$[5]
	arg_num = 0
	c$ = ""
	For i = 0 To Len(attr_param$)-1
		c$ = Mid(attr_param$, i, 1)
		
		If c$ = ":" Then
			cmd_set = TRUE
			arg_num = 0
			Continue
		ElseIf cmd_set And c$ = "," Then
			arg_num = arg_num + 1
			Continue
		ElseIf c$ = ";" Then
			cmd$ = Trim$(LCase$(cmd$))
			
			Select Case cmd$
			Case "color"
				SetColor(RGB(Val(arg[0]), Val(arg[1]), Val(arg[2])))
				
			Case "reset"
				SetColor(Core.Pre_Attr_Color)
			
			End Select
			
			cmd_set = FALSE
			arg_num = 0
			Continue
		End If
		
		If Not cmd_set Then
			cmd$ = cmd$ + c$
		Else
			arg$[arg_num] = arg$[arg_num] + c$
		End If
	Next
End Sub


Sub Ambient_UI_Render_TextField(active_textfield_flag, tf_index, x, y)
	
	If tf_index < 0 Or tf_index >= ArraySize(Ambient_UI_Global_TextField, 1) Then
		Return
	End If
	
	control_index = Ambient_UI_Global_TextField[tf_index].Control_Index
	
	If control_index < 0 Or control_index >= AMBIENT_MAX_IO_CONTROLS Then
		Return
	End If
	
	Dim t_width, t_height
	If FontExists(Ambient_UI_Global_TextField[tf_index].Font_ID) Then
		SetFont(Ambient_UI_Global_TextField[tf_index].Font_ID)
		GetTextSize("X", t_width, t_height)
	End If
	
	
	m_width = Ambient_UI_Global_TextField[tf_index].Width
	m_height = Ambient_UI_Global_TextField[tf_index].Height
	
	Ambient_UI_Global_TextField[tf_index].Rows = Int(m_height / t_height)
	Ambient_UI_Global_TextField[tf_index].Columns = Int(m_width / t_width)	
	
	m_rows = Ambient_UI_Global_TextField[tf_index].Rows
	m_cols = Ambient_UI_Global_TextField[tf_index].Columns
	
	tf_state = -1
	
	If active_textfield_flag Then
		If Key(K_RETURN) And Ambient_UI_Global_TextField[tf_index].ActionReady Then
			tf_state = AMBIENT_UI_ELEMENT_STATE_TEXT_RETURN
			Ambient_UI_Global_TextField[tf_index].ActionReady = FALSE
			
			If Ambient_UI_Global_TextField[tf_index].Editable Then
				ReadInput_Stop()
			End If
		Else
			If Ambient_UI_Global_TextField[tf_index].Editable Then
				Ambient_UI_Global_TextField[tf_index].Text$ = ReadInput_GetText()
			End If
		End If
			
		If Not Key(K_RETURN) Then
			Ambient_UI_Global_TextField[tf_index].ActionReady = TRUE
		End If
	End If
	
	Ambient_UI_Global_TextField[tf_index].State = tf_state

	current_canvas = ActiveCanvas()
	
	
	'Background Canvas
	back_canvas = Ambient_UI_Global_TextField[tf_index].BackCanvas
	If Not Ambient_UI_Global_TextField[tf_index].Manual_BackCanvas_Render Then
		Canvas(back_canvas)
		ClearCanvas()
		SetColor(Ambient_UI_Global_TextField[tf_index].BkgColor)
		RectFill(0, 0, m_width, m_height)
	End If
	
	
	'Set Menu Text positions
	front_canvas = Ambient_UI_Global_TextField[tf_index].FrontCanvas
	Canvas(front_canvas)
	ClearCanvas()
	
	If Ambient_UI_Global_TextField[tf_index].Font_Type = AMBIENT_UI_FONT_TYPE_TEXT Then
		If FontExists(Ambient_UI_Global_TextField[tf_index].Font_ID) Then
			SetFont(Ambient_UI_Global_TextField[tf_index].Font_ID)
			SetColor(Ambient_UI_Global_TextField[tf_index].TextColor)
			Core.Pre_Attr_Color = Ambient_UI_Global_TextField[tf_index].TextColor
			
			txt$ = Ambient_UI_Global_TextField[tf_index].Text$ + " "
			
			If Ambient_UI_Global_TextField[tf_index].CrawlText Then
				If (Timer() - Ambient_UI_Global_TextField[tf_index].Crawl_Timer) >= Ambient_UI_Global_TextField[tf_index].Crawl_Delay Then
					Ambient_UI_Global_TextField[tf_index].Crawl_Timer = Timer()
					If Ambient_UI_Global_TextField[tf_index].Crawl_CurrentTextLength < Len(Ambient_UI_Global_TextField[tf_index].Text$) Then
						
						attr_len = 0
						If Mid$(txt$, Ambient_UI_Global_TextField[tf_index].Crawl_CurrentTextLength, 3) = "\\$(" Then
							attr_test$ = Mid$(txt$, Ambient_UI_Global_TextField[tf_index].Crawl_CurrentTextLength, Len(txt$))
							attr_len = FindFirstOf(")", attr_test$) + 1
						End If
						
						Ambient_UI_Global_TextField[tf_index].Crawl_CurrentTextLength = (Ambient_UI_Global_TextField[tf_index].Crawl_CurrentTextLength + 1) + attr_len
						'Print "Timer: "; Ambient_UI_Global_TextField[tf_index].Crawl_CurrentTextLength
					End If
				End If
				
				txt$ = Left$(txt$, Ambient_UI_Global_TextField[tf_index].Crawl_CurrentTextLength) + " "
			End If
			
			current_word$ = ""
			t_col = 0 - Ambient_UI_Global_TextField[tf_index].ScrollPosition.X
			t_row = 0 - Ambient_UI_Global_TextField[tf_index].ScrollPosition.Y
			
			num_rows = Ambient_UI_Global_TextField[tf_index].Rows
			num_cols = Ambient_UI_Global_TextField[tf_index].Columns
			
			t_start_row = 0
			t_start_col = 0
			
			For i = 0 To Len(txt$) - 1
				c$ = Mid$(txt$, i, 1)
				t_col = t_col + 1
				
				If c$ = "\n" Then
					t_col = 0
					t_row = t_row+1
					c$ = " "
				End If
				
				'If WrapText, this will make sure t_col is never greater or equal to num_cols
				If Not Ambient_UI_Global_TextField[tf_index].WrapText Then
					num_cols = t_col + 1
				End If
				
				If t_col >= num_cols Then
					t_row = t_row + 1
					t_col = 0
				End If
				
				If c$ = " " Then
					If Trim$(current_word$) <> "" Then
						If Left$(current_word$, 3) = "\\$(" Then
							attr$ = Mid$(current_word$, 3, Len(current_word$))
							end_token = FindFirstOf(")", attr)
							attr_param$ = Left$(attr, end_token)
							current_word$ = Mid$(attr$, Len(attr_param$)+1, Len(current_word$))
							
							Ambient_UI_SetAttributes(attr_param$)
							current_word$ = ""
							t_col = t_start_col
							t_row = t_start_row
							Continue
						End If
					
						If t_row > (t_start_row) Then
							'Start at t_start_row and keep going until all characters are drawn
							t_sub_word$ = Left$(current_word$, num_cols - t_start_col)
							DrawText(t_sub_word$, t_start_col*t_width, t_start_row*t_height)
							current_word$ = Mid$(current_word$, Len(t_sub_word$), Len(current_word$))
							
							t_col = 0
							t_row = t_start_row + 1
							
							While Trim(current_word$) <> ""
								t_col = 0
								t_sub_word$ = Left$(current_word$, num_cols)
								DrawText(t_sub_word$, t_col*t_width, t_row*t_height)
								current_word$ = Mid$(current_word$, Len(t_sub_word$), Len(current_word$))
								
								t_col = Len(t_sub_word$)+1
								
								If t_col >= num_cols Then
									t_row = t_row + 1
								End If
							Wend
						Else
							DrawText(current_word$, t_start_col*t_width, t_start_row*t_height)
						End If
					End If
					current_word$ = ""
					't_col = t_col + 1
					t_start_col = t_col
				Else
					If Trim(current_word$) = "" Then
						t_start_row = t_row
						t_start_col = Max(t_col-1, 0)
					End If
					current_word$ = current_word$ + c$
				End If
			Next
		End If
	End If
	
	
	
	
	
	Canvas(current_canvas)
	
	SetCanvasViewport(Ambient_UI_Global_TextField[tf_index].BackCanvas, x, y, m_width, m_height)
	SetCanvasOffset(Ambient_UI_Global_TextField[tf_index].BackCanvas, 0, 0)
	SetCanvasVisible(Ambient_UI_Global_TextField[tf_index].BackCanvas, TRUE)
	
	SetCanvasViewport(Ambient_UI_Global_TextField[tf_index].FrontCanvas, x, y, m_width, m_height)
	SetCanvasOffset(Ambient_UI_Global_TextField[tf_index].FrontCanvas, 0, 0)
	SetCanvasVisible(Ambient_UI_Global_TextField[tf_index].FrontCanvas, TRUE)
End Sub