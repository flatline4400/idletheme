#include <Timers.au3>
#include <MsgBoxConstants.au3>
#include <WinAPIFiles.au3>
#include <StringConstants.au3>
#include <TrayConstants.au3>

;TraySetIcon ("pifmgr.dll",33)
TraySetIcon("arrow_key_white.ico", 0)
TraySetToolTip("IdleTheme")
AutoItSetOption("TrayAutoPause", 0)
#pragma compile (Icon, "arrow_key_white.ico")
#pragma compile(inputboxres, true)
Opt("TrayMenuMode", 3)
Opt("TrayOnEventMode", 1)

;define defaults
Global $timer1 = 900000  ; First timeout in ms (default 15min)
Global $timer2 = 3600000  ; Second timeout in ms (default 60min)
Global $timer3 = 7200000  ; Third timeout in ms (default 120min)
Global $insane = 0
Global $newtimer = 0, $oldtimer = 0
Global $timer1setmenu, $timer2setmenu, $timer3setmenu, $loopsetmenu
Global $loop = "No"
Global $idletimer = 0, $looptimer = 0, $loopnumber = 0



Init()
Traymenu()

While 1
	Sleep(100)

	$idletimer = _Timer_GetIdleTime()
	$looptimer = ($idletimer - ($timer3 * $loopnumber))
	;ConsoleWrite ("idle:" & $idletimer & "  loop:" & $looptimer & "  number:" & $loopnumber & @CRLF)

	If $looptimer > $timer1 And $looptimer < $timer2 And Not ProcessExists("IdleButton1.exe") Then
		If ProcessExists("IdleButton3.exe") Then ProcessClose("IdleButton3.exe")
		Run(".\IdleButton1.exe")
	ElseIf $looptimer > $timer2 And $looptimer < $timer3 And Not ProcessExists("IdleButton2.exe") Then
		ProcessClose("IdleButton1.exe")
		Run(".\IdleButton2.exe")
	ElseIf $looptimer > $timer3 And $looptimer < ($timer3 + $timer1) And Not ProcessExists("IdleButton3.exe") Then
		ProcessClose("IdleButton2.exe")
		Run(".\IdleButton3.exe")
		If $loop = "Yes" Then $loopnumber = $loopnumber + 1
	ElseIf $idletimer < 100 Then
		If ProcessExists("IdleButton1.exe") Then ProcessClose("IdleButton1.exe")
		If ProcessExists("IdleButton2.exe") Then ProcessClose("IdleButton2.exe")
		If ProcessExists("IdleButton3.exe") Then ProcessClose("IdleButton3.exe")
		$loopnumber = 0
		$looptimer = 0
	EndIf

WEnd



Func Init()
	Local $sEnvVar = EnvGet("APPDATA")
	Global Const $iniFileName = $sEnvVar & "\Idletheme\Idletheme.ini"
	Global Const $iniFilePath = $sEnvVar & "\Idletheme"

	;Check if folder and file exist.  If not, create them.

	If Not FileExists($iniFilePath) Then
		DirCreate($iniFilePath)
	EndIf

	If Not FileExists($iniFileName) Then
		WriteIni()
	EndIf

	LoadIni()
	If SanityCheck() Then
		MsgBox($MB_SYSTEMMODAL, "", "Invalid timer values in " & $iniFileName)
		Exit
	EndIf
EndFunc   ;==>Init

Func LoadIni()
	;Load defaults
	$timer1 = Number(IniRead($iniFileName, "General", "Timer1", 100000))
	$timer2 = Number(IniRead($iniFileName, "General", "Timer2", 200000))
	$timer3 = Number(IniRead($iniFileName, "General", "Timer3", 300000))
	$loop = IniRead($iniFileName, "General", "Loop", "No")
EndFunc   ;==>LoadIni

Func WriteIni()
	IniWrite($iniFileName, "General", "Timer1", $timer1)
	IniWrite($iniFileName, "General", "Timer2", $timer2)
	IniWrite($iniFileName, "General", "Timer3", $timer3)
	IniWrite($iniFileName, "General", "Loop", $loop)
EndFunc   ;==>WriteIni

Func SanityCheck()
	If Not StringIsDigit($timer1) Then
		$insane = 1
		Return 1
	ElseIf Not StringIsDigit($timer2) Then
		$insane = 1
		Return 1
	ElseIf Not StringIsDigit($timer3) Then
		$insane = 1
		Return 1
	ElseIf $timer1 < 100 Then
		$insane = 1
		Return 1
	ElseIf $timer2 < $timer1 Then
		$insane = 1
		Return 1
	ElseIf $timer3 < $timer2 Then
		$insane = 1
		Return 1
	EndIf
	If $loop = "Yes" Or $loop = "No" Then
		$insane = 0
	Else
		$insane = 1
		Return 1
	EndIf
	$insane = 0
EndFunc   ;==>SanityCheck

Func Traymenu()
	TrayCreateItem("IdleTheme")
	TrayCreateItem("")
	Local $iSettings = TrayCreateMenu("Settings")
	$timer1setmenu = TrayCreateItem("Set Timer 1: " & $timer1, $iSettings)
	TrayItemSetOnEvent(-1, "Timer1Set")
	$timer2setmenu = TrayCreateItem("Set Timer 2: " & $timer2, $iSettings)
	TrayItemSetOnEvent(-1, "Timer2Set")
	$timer3setmenu = TrayCreateItem("Set Timer 3: " & $timer3, $iSettings)
	TrayItemSetOnEvent(-1, "Timer3Set")
	$loopsetmenu = TrayCreateItem("Loop:  " & $loop, $iSettings)
	TrayItemSetOnEvent(-1, "Loopset")
	TrayCreateItem("", $iSettings)
	TrayCreateItem("Save Settings", $iSettings)
	TrayItemSetOnEvent(-1, "WriteIni")

	TrayCreateItem("")

	TrayCreateItem("About")
	TrayItemSetOnEvent(-1, "About")

	TrayCreateItem("")

	TrayCreateItem("Exit")
	TrayItemSetOnEvent(-1, "ExitScript")

	TraySetState($TRAY_ICONSTATE_SHOW)
EndFunc   ;==>Traymenu

Func Loopset()
	If $loop = "Yes" Then
		$loop = "No"
	Else
		$loop = "Yes"
	EndIf
	TrayItemSetText($loopsetmenu, "Loop:  " & $loop)
EndFunc   ;==>Loopset

Func About()
	MsgBox($MB_SYSTEMMODAL, "", "IdleTheme version 1.0" & @CRLF & @CRLF & _
			"Ini File: " & $iniFileName & @CRLF & _
			"Install Path: " & @WorkingDir)
EndFunc   ;==>About

Func ExitScript()
	Exit
EndFunc   ;==>ExitScript

Func Timer1Set()
	$insane = 0
	$oldtimer = InputBox("New Value", _
			"Timer 1: " & $timer1 & "  Timer 2: " & $timer2 & "  Timer 3: " & $timer3 & _
			@CRLF & "Enter the new timer value in millisceonds" & @CRLF & "(minimum 100ms)", $timer1, "")
	If @error = 1 Then
		Return 1
	EndIf
	$newtimer = Number($oldtimer)
	If $newtimer < 100 Then
		Invalid()
	ElseIf $newtimer > $timer2 Then
		ConsoleWrite ($newtimer & "greater than timer2 " & $timer2)
		Invalid()
	ElseIf Not StringIsDigit($newtimer) Then
		Invalid()
	ElseIf $insane = 1 Then
		Return 1
	Else
		$timer1 = $newtimer
		TrayItemSetText($timer1setmenu, "Set Timer 1: " & $timer1)
	EndIf
EndFunc   ;==>Timer1Set

Func Timer2Set()
	$insane = 0
	$oldtimer = InputBox("New Value", _
			"Timer 1: " & $timer1 & "  Timer 2: " & $timer2 & "  Timer 3: " & $timer3 & _
			@CRLF & "Enter the new timer value in millisceonds" & @CRLF & "(must be between timer 1 and timer 3)", $timer2, "")
	If @error = 1 Then
		Return 1
	EndIf
	$newtimer = Number($oldtimer)
	If $newtimer < 100 Then
		Invalid()
	ElseIf $newtimer > $timer3 Then
		Invalid()
	ElseIf $newtimer < $timer1 Then
		Invalid()
	ElseIf Not StringIsDigit($newtimer) Then
		Invalid()
	ElseIf $insane = 1 Then
		Return 1
	Else
		$timer2 = $newtimer
		TrayItemSetText($timer2setmenu, "Set Timer 2: " & $timer2)
	EndIf
EndFunc   ;==>Timer2Set

Func Timer3Set()
	$insane = 0
	$newtimer = InputBox("New Value", _
			"Timer 1: " & $timer1 & "  Timer 2: " & $timer2 & "  Timer 3: " & $timer3 & _
			@CRLF & "Enter the new timer value in millisceonds" & @CRLF & "(must be greater than timer 2)", $timer3, "")
	If @error = 1 Then
		Return 1
	EndIf
	$newtimer = Number($oldtimer)
	If $newtimer < 100 Then
		Invalid()
	ElseIf $newtimer < $timer2 Then
		Invalid()
	ElseIf Not StringIsDigit($newtimer) Then
		Invalid()
	ElseIf $insane = 1 Then
		Return 1
	Else
		$timer3 = $newtimer
		TrayItemSetText($timer3setmenu, "Set Timer 3: " & $timer3)
	EndIf
EndFunc   ;==>Timer3Set

Func Invalid()
	MsgBox($MB_SYSTEMMODAL, "", "Invalid timer value.")
	$insane = 1
EndFunc   ;==>Invalid

