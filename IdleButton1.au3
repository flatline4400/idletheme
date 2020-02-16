#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         flatline151@hotmail.com

 Script Function:
	Transparent window for IdleTheme / iCUE Profile switcher.

#ce ----------------------------------------------------------------------------


#NoTrayIcon
#include <MsgBoxConstants.au3>
#include <GUIConstantsEx.au3>
#include <ButtonConstants.au3>

AutoItSetOption("GUICloseOnESC", 1)
;TraySetIcon ("arrow_key_green.ico",0)
AutoItSetOption("TrayAutoPause", 0)
#pragma compile (Icon, "arrow_key_green.ico")


_MsgBoxOKOnly('Button', 'Looks like we are idle!')

Func _MsgBoxOKOnly($title, $text = '', $state = @SW_SHOWNORMAL)
	Local $button, $handle, $msg
	Local Const $WS_DLGFRAME = 0x00400000
	$handle = GUICreate($title, 300, 95, 0, 0, $WS_DLGFRAME)
	GUICtrlCreateLabel($text, 20, 10)
	$button = GUICtrlCreateButton('OK', 110, 40, 80, 20, $BS_DEFPUSHBUTTON)
	WinSetTrans("Button", "", 0)
	GUISetState($state)

	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $button
				ExitLoop

		EndSwitch
	WEnd

EndFunc   ;==>_MsgBoxOKOnly
