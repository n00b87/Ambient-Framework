Include "Ambient_Core.bas"


title$ = "Ambient"
w = 1280
h = 720
fullscreen = FALSE
vsync = FALSE
tgt_fps = 60


'Open a graphics window
Ambient_Init(title$, w, h, fullscreen, vsync, tgt_fps)

'Open a 3D Canvas
m3d = OpenCanvas3D(0, 0, w, h, 0)

'Core.IO.FPS_CameraControl.ControlCanvas = m3d

'Set the 3D Canvas as the active Canvas (Camera Actions will be done on active canvas)
Canvas(m3d)
SetCanvasZ(m3d, 99)
'SetCanvasVisible(m3d, FALSE)

'Move and Rotate the Camera
SetCameraPosition(0, 10, 0)
SetCameraRotation(-20,0,0)

SetSceneShadowColor(RGBA(0,0,0,50))

'Load a Stage
Serenity_LoadStage("st1")

print "key = "; key(-1)

Ambient_SetCameraControl(0, m3d, AMBIENT_CAMERA_CONTROL_THIRD_PERSON)

gy_index = Serenity_GetActorIndex("gy")
gy_actor = Serenity_GetActorID(gy_index)

Dim min_x, min_y, min_z, max_x, max_y, max_z

GetActorAABB(gy_actor, min_x, min_y, min_z, max_x, max_y, max_z)

min_y = min_y + 300
max_y = max_y - 300

gy_mesh_index = Serenity_GetActorMeshIndex(gy_actor)
mesh = Serenity_GetMeshID(gy_mesh_index)

SetActorShapeEx(gy_actor, ACTOR_SHAPE_CAPSULE, 20, 4)

Print "dbg: "; gy_index; ", "; gy_actor; ", "; mesh
Print "bound: "; min_x; ", "; min_y; ", "; min_z; ", "; max_x; ", "; max_y; ", "; max_z

SetActorGravity(gy_actor, 0, -70, 0)

Ambient_SetPlatformControlActor(0, gy_actor )

test_lv_collision_index = Serenity_GetActorIndex("tl")
test_lv_collision_actor = Serenity_GetActorID(test_lv_collision_index)

Print "test: "; test_lv_collision_index; ", "; test_lv_collision_actor

Ambient_AddLevelCollisionActor(test_lv_collision_actor)

'test menu
control_index = 0
menu_w = 200
menu_h = 220
spriteSheet = LoadImage("ui_textures/test_menu_frame.png")
frame_width = 128
frame_height = 32

menu1 = Ambient_UI_CreateMenu(control_index, w, h, spriteSheet, frame_width, frame_height)

menu1_item1 = Ambient_UI_AddMenuItem(menu1, 20, 20, "item 1", 10, 5)
menu1_item2 = Ambient_UI_AddMenuItem(menu1, 20, 50, "item 2", 10, 5)
menu1_item3 = Ambient_UI_AddMenuItem(menu1, 20, 80, "item 3", 10, 5)
menu1_item4 = Ambient_UI_AddMenuItem(menu1, 20, 110, "item 4", 10, 5)
menu1_item5 = Ambient_UI_AddMenuItem(menu1, 20, 140, "item 5", 10, 5)
menu1_item6 = Ambient_UI_AddMenuItem(menu1, 20, 170, "item 6", 10, 5)
menu1_item7 = Ambient_UI_AddMenuItem(menu1, 20, 200, "item 7", 10, 5)

Ambient_UI_SetMenuSoundEffect(menu1, AMBIENT_UI_STATE_CHANGE_ITEM_CHANGE, LoadSound("ui_sfx/MENU_Pick.wav"))
Ambient_UI_SetMenuSoundEffect(menu1, AMBIENT_UI_STATE_CHANGE_ITEM_SELECT, LoadSound("ui_sfx/MENU A_Select.wav"))
Ambient_UI_SetMenuSoundEffect(menu1, AMBIENT_UI_STATE_CHANGE_CANCEL, LoadSound("ui_sfx/MENU B_Back.wav"))

Ambient_UI_SetPosition(menu1, 100, 100)

'item2_sprite = Ambient_UI_GetMenuItem(menu1, menu1_item2).Sprite_ID
'highlight_animation = CreateSpriteAnimation(item2_sprite, 2, 8)
'SetSpriteAnimationFrame(item2_sprite, highlight_animation, 0, 0)
'SetSpriteAnimationFrame(item2_sprite, highlight_animation, 1, 1)

'Ambient_UI_SetMenuItemAnimation(menu1, menu1_item2, AMBIENT_UI_ELEMENT_STATE_HIGHLIGHTED, highlight_animation)

Dim animation_frames[2]
animation_frames[0] = 0
animation_frames[1] = 1


Ambient_UI_GenerateMenuAnimation(menu1, AMBIENT_UI_ELEMENT_STATE_HIGHLIGHTED, 2, animation_frames, 8)



tfield = Ambient_UI_CreateTextField(0, 200, 100)
tfield2 = Ambient_UI_CreateTextField(0, 200, 100)

Ambient_UI_OpenTextField(tfield)
Ambient_UI_SetPosition(tfield, 100, 500)

Ambient_UI_OpenTextField(tfield2)
Ambient_UI_SetPosition(tfield2, 10, 50)

Ambient_UI_SetTextFieldEditable(tfield, FALSE)
Ambient_UI_SetTextFieldEditable(tfield2, FALSE)

edit_text_flag = FALSE

Ambient_UI_SetTextFieldValue(tfield, "WASD Or Analog Stick - Move\n[SPACE] Or Pad [1] - Jump\n1 - FPS\nM - Open Menu\nK - Close Menu\nT - Edit this textbox\nQ - QUIT")

Ambient_UI_SetTextFieldValue(tfield2, "This is a \\$(color:0,255,0) test of set\nting \\$(reset) at\ntributes")
Ambient_UI_SetTextFieldCrawl(tfield2, TRUE)
Ambient_UI_SetTextFieldCrawlDelay(tfield2, 120)

Ambient_UI_SetMenuHighlightColor(menu1, RGB(0,0,255))
Ambient_UI_UseMenuHighlightColor(menu1, TRUE)


'Main Loop
While WindowExists() And (Not Key(K_Q))
	'Camera_Control(m3d)
	
	If Key(K_1) Then
		Ambient_SetCameraControl(0, m3d, AMBIENT_CAMERA_CONTROL_FIRST_PERSON_KEYBOARD_MOUSE)
	ElseIf Key(K_2) Then
		Ambient_SetCameraControl(0, m3d, AMBIENT_CAMERA_CONTROL_FIRST_PERSON_JOYSTICK)
	End If
	
	If Key(K_M) Then
		Ambient_UI_OpenMenu(menu1)
		While Key(K_M)
			Update()
		Wend
	ElseIf Key(K_K) Then
		Ambient_UI_CloseMenu(control_index)
		While Key(K_K)
			Update()
		Wend
	End If
	
	If Key(K_T) Then
		edit_text_flag = NOT edit_text_flag
		Ambient_UI_SetTextFieldEditable(tfield, edit_text_flag)
		Ambient_UI_SetTextFieldFocus(tfield)
		While Key(K_T)
			Update()
		Wend
	End If
	
	Ambient_Update()
Wend

