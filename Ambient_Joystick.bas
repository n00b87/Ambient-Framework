Include Once

Sub Ambient_UpdateJoystickState(joy_num)
	For i = 0 to (AMBIENT_MAX_JOY_BUTTONS-1)
		Core.IO.Joystick[joy_num].Joystick_Button[i] = 0
		Core.IO.Joystick[joy_num].Joystick_Axis[i] = 0
		Core.IO.Joystick[joy_num].Joystick_Hat[i] = 0
	Next
	
	If NumJoyHats(joy_num) > 0 Then
		For i = 0 to NumJoyHats(joy_num)-1
			Core.IO.Joystick[joy_num].Joystick_Hat[i] = JoyHat(joy_num, i)
		Next
	End If
	
	If NumJoyButtons(joy_num) > 0 Then
		For i = 0 to NumJoyButtons(joy_num) - 1
			Core.IO.Joystick[joy_num].Joystick_Button[i] = JoyButton(joy_num, i)
		Next
	End If
	
	If NumJoyAxes(joy_num) > 0 Then
		For i = 0 to NumJoyAxes(joy_num) - 1
			Core.IO.Joystick[joy_num].Joystick_Axis[i] = JoyAxis(joy_num, i)
		Next
	End If
End Sub