Include Once


Const AMBIENT_UI_ELEMENT_TYPE_NONE			= 0
Const AMBIENT_UI_ELEMENT_TYPE_MENU			= 1
Const AMBIENT_UI_ELEMENT_TYPE_TEXTFIELD	= 2
Const AMBIENT_UI_ELEMENT_TYPE_BUTTON		= 3
Const AMBIENT_UI_ELEMENT_TYPE_LISTBOX		= 4


Const AMBIENT_UI_ELEMENT_STATE_NONE				 = 0
Const AMBIENT_UI_ELEMENT_STATE_PRESSED			 = 1
Const AMBIENT_UI_ELEMENT_STATE_RELEASED		 = 2
Const AMBIENT_UI_ELEMENT_STATE_HIGHLIGHTED	 = 3
Const AMBIENT_UI_ELEMENT_STATE_TEXT_RETURN		= 4

Const AMBIENT_UI_MAX_ELEMENT_STATES = 5

Type Ambient_UI_Button
	Dim ID
	Dim Parent_ID
	
	Dim Control_Index
	
	'If -1, then it will use the parent width and height
	Dim Width
	Dim Height
	
	Dim ButtonType 'Text or Bitmap
	
	Dim Style
	
	'For each button state
	Dim BorderColor[3]
	Dim BkgColor[3]
	
	Dim Text$
	Dim Image_ID[3]
	
	Dim State
End Type



Const AMBIENT_UI_CURSOR_STYLE_FLASHING_NONE = 0
Const AMBIENT_UI_CURSOR_STYLE_FLASHING_BOX = 1

Type Ambient_UI_TextCursor
	Dim ID
	Dim Parent_ID
	
	Dim Style
	Dim Color
	
	Dim Position
	
	Dim Visible
End Type


Const AMBIENT_UI_FONT_TYPE_TEXT	= 0
Const AMBIENT_UI_FONT_TYPE_BITMAP	= 1 'Text will be displayed as Tilemaps (NOT IMPLEMENTED YET)

Type Ambient_UI_TextField
	Dim ID
	Dim Parent_ID
	
	Dim Control_Index
	
	Dim Visible
	
	Dim State
	
	Dim ActionReady 'For RETURN Key
	
	Dim Font_Type
	Dim Font_ID
	Dim Font_Tilesheet_ID
	Dim Font_Tileset_ID
	Dim Font_Tilemap_ID
	
	Dim ScrollPosition As Ambient_Vector2D
	
	Dim Editable
	
	Dim Rows
	Dim Columns
	
	Dim WrapText
	
	Dim CrawlText
	Dim Crawl_Timer
	Dim Crawl_Delay
	Dim Crawl_CurrentTextLength
	
	'If -1, then it will use the parent width and height
	Dim Width
	Dim Height
	
	Dim BorderColor
	Dim BkgColor
	Dim TextColor
	Dim Highlight_BkgColor
	Dim Highlight_TextColor
	
	Dim Cursor As Ambient_UI_TextCursor
	
	Dim Text$
	
	Dim BackCanvas
	Dim FrontCanvas
	
	Dim Manual_BackCanvas_Render
End Type


Type Ambient_UI_MenuOption
	Dim ID
	
	Dim TextColor
	
	Dim Text$
	
	Dim TextOffsetX
	Dim TextOffsetY
	
	Dim OffsetX
	Dim OffsetY
	
	Dim State 
	Dim Sprite_ID 'Sprites will hold different animations for when selected, highlighted, etc.
	
	Dim Animation[AMBIENT_UI_MAX_ELEMENT_STATES] '0 - NONE, 1 - HIGHLIGHTED, 2 - SELECTED
End Type

Const AMBIENT_UI_STATE_CHANGE_ITEM_CHANGE	= 0
Const AMBIENT_UI_STATE_CHANGE_ITEM_SELECT	= 1
Const AMBIENT_UI_STATE_CHANGE_REJECT			= 2
Const AMBIENT_UI_STATE_CHANGE_CANCEL			= 3

Const AMBIENT_UI_MAX_STATE_CHANGE	= 5

Type Ambient_UI_Menu
	Dim ID
	Dim Parent_ID
	
	Dim Visible
	
	Dim Control_Index
	
	Dim NavigateKeyboard
	Dim NavigateMouse
	
	Dim WrapSelection
	
	'If -1, then it will use the parent width and height
	Dim Width
	Dim Height
	
	Dim OptionWidth
	Dim OptionHeight
	
	Dim State
	Dim ActionReady
	Dim SoundEffect[AMBIENT_UI_MAX_STATE_CHANGE]
	
	Dim UseHighlightColor
	Dim HighlightColor
	
	Dim MenuStyle
	Dim Font_ID
	Dim SpriteSheet
	Dim Sprite_FrameWidth
	Dim Sprite_FrameHeight
	Dim SpriteAnimation[AMBIENT_UI_MAX_ELEMENT_STATES]
	Dim CurrentItem
	Dim MenuOptions 'Matrix
	Dim NumOptions
	Dim BackCanvas
	Dim SpriteCanvas
	Dim FrontCanvas
End Type

Type Ambient_UI_Panel
	Dim Element_ID 'Matrix; This matrix will store the IDs and positions
End Type


Dim Ambient_UI_Global_Button_Index
Dim Ambient_UI_Global_Button[99] As Ambient_UI_Button

Dim Ambient_UI_Global_TextField_Index
Dim Ambient_UI_Global_TextField[99] As Ambient_UI_TextField

Dim Ambient_UI_Global_MenuOption_Index
Dim Ambient_UI_Global_MenuOption[99] As Ambient_UI_MenuOption

Dim Ambient_UI_Global_Menu_Index
Dim Ambient_UI_Global_Menu[99] As Ambient_UI_Menu


Dim Ambient_UI_Global_Element_Index
Dim Ambient_UI_Global_Element_List[299, 4]
' Fist index is Element ID
' Second Index has the following:
'		0 - Element Type
'		1 - Index in array of Element Type
' 		2 - X
' 		3 - Y




Sub Ambient_UI_Init()
	For i = 0 To ArraySize(Ambient_UI_Global_Element_List, 1)-1
		Ambient_UI_Global_Element_List[i, 0] = -1
	Next
	
	For i = 0 To ArraySize(Ambient_UI_Global_Menu, 1)-1
		Ambient_UI_Global_Menu[i].ID = -1
	Next
	
	For i = 0 To ArraySize(Ambient_UI_Global_MenuOption, 1)-1
		Ambient_UI_Global_MenuOption[i].ID = -1
	Next
	
	For i = 0 To ArraySize(Ambient_UI_Global_TextField, 1)-1
		Ambient_UI_Global_TextField[i].ID = -1
	Next
	
	For i = 0 To ArraySize(Ambient_UI_Global_Button, 1)-1
		Ambient_UI_Global_Button[i].ID = -1
	Next
	
	Ambient_UI_Global_Element_Index = 0
	Ambient_UI_Global_Menu_Index = 0
	Ambient_UI_Global_MenuOption_Index = 0
	Ambient_UI_Global_TextField_Index = 0
	Ambient_UI_Global_Button_Index = 0
End Sub

Sub Ambient_UI_InternalArray_Resize()
	If Ambient_UI_Global_Menu_Index >= ArraySize(Ambient_UI_Global_Menu, 1) Then
		new_size = ArraySize(Ambient_UI_Global_Menu, 1) + 100
		ReDim Ambient_UI_Global_Menu[new_size]
	End If
	
	If Ambient_UI_Global_MenuOption_Index >= ArraySize(Ambient_UI_Global_MenuOption, 1) Then
		new_size = ArraySize(Ambient_UI_Global_MenuOption, 1) + 100
		ReDim Ambient_UI_Global_MenuOption[new_size]
	End If
	
	If Ambient_UI_Global_TextField_Index >= ArraySize(Ambient_UI_Global_TextField, 1) Then
		new_size = ArraySize(Ambient_UI_Global_TextField, 1) + 100
		ReDim Ambient_UI_Global_TextField[new_size]
	End If
	
	If Ambient_UI_Global_Button_Index >= ArraySize(Ambient_UI_Global_Button, 1) Then
		new_size = ArraySize(Ambient_UI_Global_Button, 1) + 100
		ReDim Ambient_UI_Global_Button[new_size]
	End If
	
	If Ambient_UI_Global_Element_Index >= ArraySize(Ambient_UI_Global_Element_List, 1) Then
		new_size = ArraySize(Ambient_UI_Global_Element_List, 1) + 100
		ReDim Ambient_UI_Global_Element_List[new_size, 4]
	End If
End Sub




Function Ambient_UI_SetPosition(element_id, x, y)
	If element_id < 0 Or element_id >= ArraySize(Ambient_UI_Global_Element_List, 1) Then
		Return -1
	End If
	
	Ambient_UI_Global_Element_List[element_id, 2] = x
	Ambient_UI_Global_Element_List[element_id, 3] = y
End Function


Function Ambient_UI_SetVisible(element_id, flag)
	If element_id < 0 Or element_id >= ArraySize(Ambient_UI_Global_Element_List, 1) Then
		Return FALSE
	End If
	
	Select Case Ambient_UI_Global_Element_List[element_id, 0]
	Case AMBIENT_UI_ELEMENT_TYPE_MENU
		menu_index = Ambient_UI_Global_Element_List[element_id, 1]
		
		If menu_index < 0 Or menu_index >= ArraySize(Ambient_UI_Global_Menu, 1) Then
			Return FALSE
		End If
		
		Ambient_UI_Global_Menu[menu_index].Visible = flag
		
	'TODO: Add other element types to this select case block
	End Select
	
	
	Return TRUE
End Function


Function Ambient_UI_IsVisible(element_id)
	If element_id < 0 Or element_id >= ArraySize(Ambient_UI_Global_Element_List, 1) Then
		Return FALSE
	End If
	
	Select Case Ambient_UI_Global_Element_List[element_id, 0]
	Case AMBIENT_UI_ELEMENT_TYPE_MENU
		menu_index = Ambient_UI_Global_Element_List[element_id, 1]
		
		If menu_index < 0 Or menu_index >= ArraySize(Ambient_UI_Global_Menu, 1) Then
			Return FALSE
		End If
		
		Return Ambient_UI_Global_Menu[menu_index].Visible
		
	'TODO: Add other element types to this select case block
	End Select
	
	Return FALSE
End Function


Include "Ambient_UI_Menu.bas"
Include "Ambient_UI_TextField.bas"












