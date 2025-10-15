Include Once

Const AMBIENT_MAX_IO_CONTROLS = 8

Const AMBIENT_MAX_FPS_CONTROLS = 8

Const AMBIENT_MAX_JOYSTICKS = AMBIENT_MAX_IO_CONTROLS
Const AMBIENT_MAX_JOY_BUTTONS = 30

Const AMBIENT_MAX_SIMULTANEOUS_KEYS = 4


Const AMBIENT_GAME_STATE_NONE = 0
Const AMBIENT_GAME_STATE_CHARACTER_CONTROL = 1
Const AMBIENT_GAME_STATE_MENU = 2


Const AMBIENT_CAMERA_CONTROL_FIRST_PERSON_KEYBOARD_ONLY 		= 0
Const AMBIENT_CAMERA_CONTROL_FIRST_PERSON_KEYBOARD_MOUSE		= 1
Const AMBIENT_CAMERA_CONTROL_FIRST_PERSON_JOYSTICK					= 2
Const AMBIENT_CAMERA_CONTROL_FIRST_PERSON_TOUCH						= 3
Const AMBIENT_CAMERA_CONTROL_THIRD_PERSON								= 4


Const AMBIENT_CONTROL_TYPE_KEYBOARD_MOUSE = 0
Const AMBIENT_CONTROL_TYPE_JOYSTICK			 = 1
Const AMBIENT_CONTROL_TYPE_TOUCH				 = 2


Const AMBIENT_ACTION_ID_UP 		= 1
Const AMBIENT_ACTION_ID_DOWN 	= 2
Const AMBIENT_ACTION_ID_LEFT 	= 3
Const AMBIENT_ACTION_ID_RIGHT 	= 4

Const AMBIENT_ACTION_ID_UP_2 		= 5
Const AMBIENT_ACTION_ID_DOWN_2 	= 6
Const AMBIENT_ACTION_ID_LEFT_2 	= 7
Const AMBIENT_ACTION_ID_RIGHT_2 	= 8

Const AMBIENT_ACTION_ID_RAISE = 9
Const AMBIENT_ACTION_ID_LOWER = 10

Const AMBIENT_ACTION_ID_JUMP = 11

Const AMBIENT_ACTION_ID_CONFIRM 		= 12
Const AMBIENT_ACTION_ID_CANCEL			= 13
Const AMBIENT_ACTION_ID_MENU_OPEN		= 14

Const AMBIENT_ACTION_ID_MENU_PREVIOUS	=	15
Const AMBIENT_ACTION_ID_MENU_NEXT			=	16
Const AMBIENT_ACTION_ID_MENU_SELECT		=	17
Const AMBIENT_ACTION_ID_MENU_CANCEL		=	18

Const AMBIENT_ACTION_ID_MENU_UP			=	19
Const AMBIENT_ACTION_ID_MENU_DOWN			=	20
Const AMBIENT_ACTION_ID_MENU_LEFT			=	21
Const AMBIENT_ACTION_ID_MENU_RIGHT		=	22

Const AMBIENT_ACTION_ID_CAMERA_ROTATE_UP			=	23
Const AMBIENT_ACTION_ID_CAMERA_ROTATE_DOWN		=	24
Const AMBIENT_ACTION_ID_CAMERA_ROTATE_LEFT		=	25
Const AMBIENT_ACTION_ID_CAMERA_ROTATE_RIGHT	=	26


AMBIENT_ACTION_INDEX = 30	'This variable needs to be increased if more actions are added

Const AMBIENT_MAX_ACTION_KEYS = 99


Const AMBIENT_SOUND_CHANNEL_UI = 0

Type Ambient_Vector2D
	Dim x
	Dim y
End Type

Const Ambient_Size = Serenity_Size

Type Ambient_ActionKey
	Dim Action_Keyboard_Key
	
	Dim Action_Joystick_Button
	
	Dim Action_Joystick_Axis
	
	Dim Min_X
	Dim Max_X
	
	Dim Min_Y
	Dim Max_Y
	
	Dim Action_Touch_Vector As Ambient_Vector2D
End Type

Type Ambient_Joystick
	Dim AxisActivation
	Dim Joystick_Button[AMBIENT_MAX_JOY_BUTTONS]
	Dim Joystick_Axis[AMBIENT_MAX_JOY_BUTTONS]
	Dim Joystick_Hat[AMBIENT_MAX_JOY_BUTTONS]
	Dim Action[AMBIENT_MAX_ACTION_KEYS] As Ambient_ActionKey
End Type

Type Ambient_FPS_Control
	Dim Controller_Type
	Dim MoveSpeed
	Dim Sensitivity
	Dim mx
	Dim my
	Dim prev_mx
	Dim prev_my
	Dim mb1
	Dim mb2
	Dim mb3
	Dim MinAngle
	Dim MaxAngle
End Type


Const AMBIENT_PLAYER_ANIMATION_IDLE = 0
Const AMBIENT_PLAYER_ANIMATION_WALK = 1
Const AMBIENT_PLAYER_ANIMATION_RUN = 2
Const AMBIENT_PLAYER_ANIMATION_JUMP = 3

Const MAX_AMBIENT_PLAYER_ANIMATION = 4

Type Ambient_Character_Animation
	Dim Name$
	Dim ID
End Type


Type Ambient_Platformer_Control
	Dim player_actor
	Dim level
	Dim level_collision_stack
	Dim min_bbx, min_bby, min_bbz
	Dim max_bbx, max_bby, max_bbz
	
	'Forces applied when the player moves
	Dim player_linear_force
	Dim player_angular_force
	Dim player_jump_force
	Dim player_jump_linear_force
	Dim player_jump_ready
	Dim player_ground_test
	
	Dim player_animation[MAX_AMBIENT_PLAYER_ANIMATION] As Ambient_Character_Animation
	
	Dim mode_switch
	
	'I am setting up some matrices that I use to get the direction the
	'player is facing. GetActorPosition() is not reliable since it is
	'prone to gimbal lock so the prefered method is to calculate the
	'direction from the actor's transform matrix using a forward vector
	'
	'NOTE: Matrices are not automatically cleaned up once out of scope
	'      so if you are not creating a matrix in global scope then you
	'      must call DeleteMatrix() to clean them up
	Dim player_m
	Dim forward_m
	Dim result_m
End Type


Type Ambient_IO
	Dim Active_ControlType[AMBIENT_MAX_IO_CONTROLS]
	Dim ControlCanvas[AMBIENT_MAX_IO_CONTROLS]
	Dim Joystick_Index[AMBIENT_MAX_IO_CONTROLS]
	
	
	'Control Type Objects
	Dim FPS_CameraControl[AMBIENT_MAX_FPS_CONTROLS] As Ambient_FPS_Control
	Dim Platformer_Control[AMBIENT_MAX_IO_CONTROLS] As Ambient_Platformer_Control
	
	'Joystick and Action Keys
	Dim Joystick[AMBIENT_MAX_JOYSTICKS] As Ambient_Joystick
	Dim Action[AMBIENT_MAX_ACTION_KEYS] As Ambient_ActionKey
	
	Dim Prev_MousePosition As Ambient_Vector2D
End Type

Type Ambient_GameState
	Dim State
	Dim Prev_State 'State before menu
	Dim ActiveMenu_Stack 'Menus will take over input from the character controller while State = AMBIENT_GAME_STATE_MENU
	
	Dim ActiveTextField_ID 'Only 1 textfield will be active (editable) at a time
	
	Dim TextField_Stack
	
	Dim State_Timer
End Type

Type Ambient_Core
	Dim WindowSize As Ambient_Size
	Dim VSync
	Dim TargetFPS
	Dim Fullscreen
	
	Dim UI_Font
	
	Dim CameraControlType[AMBIENT_MAX_IO_CONTROLS]
	
	Dim IO As Ambient_IO
	
	Dim GameState[AMBIENT_MAX_IO_CONTROLS] As Ambient_GameState
	
	Dim Z_Index
	
	Dim Tmp_Canvas
	
	Dim Pre_Attr_Color
End Type