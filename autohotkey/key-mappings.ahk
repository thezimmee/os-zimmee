; This script assumes that Alt and Ctrl characters have been swapped.

; -----KEY GUIDE-----
; # Win. (the key with the Windows logo) therefore `Send #e` would hold down Win and then press E.
; + Shift. For example, `Send, +abC` would send the text "AbC", and `Send, !+a` would press Alt+Shift+A.
; ^ Alt (because of remapkey). For example, `Send, This is text!a` would send the keys "This is text" and then press Alt+A. Note: !A produces a different effect in some programs than !a. This is because !A presses Alt+Shift+A and !a presses Alt+A. If in doubt, use lowercase.
; ! Ctrl (because of remapkey). For example, `Send, ^!a` would press Ctrl+Alt+A, and Send, ^{Home} would send Ctrl+Home. Note: ^A produces a different effect in some programs than ^a. This is because ^A presses Ctrl+Shift+A and ^a presses Ctrl+A. If in doubt, use lowercase.Sends Ctrl. For example, Send, ^!a would press Ctrl+Alt+A, and Send, ^{Home} would send Ctrl+Home. Note: ^A produces a different effect in some programs than ^a. This is because ^A presses Ctrl+Shift+A and ^a presses Ctrl+A. If in doubt, use lowercase.
; & An ampersand may be used between any two keys or mouse buttons to combine them into a custom hotkey.

; #Warn  ; Uncomment to enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
;SetWorkingDir(A_ScriptDir)  ; Ensures a consistent starting directory.

; Uncomment for key history
; #InstallKeybdHook
; KeyHistory

; Disable CapsLock.
; -----------------
SetCapsLockState, alwaysoff

; Keyboard mouse.
; ---------------
CapsLock::LButton
F1::LButton
!CapsLock::RButton
F2::RButton
+CapsLock::CapsLock

; CapsLock::Send {Blind}{Ctrl Down}{LWin Down}
; CapsLock Up::Send {Blind}{Ctrl Up}{LWin Up}

; MacOS shortcuts.
------------------
; App and tab switching
;Ctrl & Tab::AltTab
;!Tab::Send ^{Tab}

; Quit the active app
;^q::Send !{f4}
;^q::WinClose A

; Insertion point movement
;^Left::Send {Home}
;^Right::Send {End}
;^Up::Send ^{Home}
;^Down::Send ^{End}
;+^Left::Send +{Home}
;+^Right::Send +{End}
;+^Up::Send +^{Home}
;+^Down::Send +^{End}
;#Left::Send ^{Left}
;#Right::Send ^{Right}
;+#Left::Send +^{Left}
;+#Right::Send +^{Right}



;LCtrl::Alt
;LAlt::Ctrl      
;LCtrl & Tab::AltTab
;Shift & Tab::ShiftAltTab ;also triggered by shift+alt+tab

; Window management.
; ------------------

#j::#Left
#l::#Right
#i::#Up
#k::#Down
CapsLock & i::Send #{i}

; App management.
; ---------------

CapsLock & k::
	IfWinNotExist ahk_exe brave.exe
		run, "C:\Program Files\BraveSoftware\Brave-Browser\Application"
	WinWait, ahk_exe brave.exe
	winactivate, ahk_exe brave.exe
