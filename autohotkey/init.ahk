#Requires AutoHotkey v2.0

; ---- KEYS ----
; # = Windows
; + = Shift
; ! = Alt
; ^ = Ctrl
; & = combine keys.

; ---- DEBUGGING ----
; #Warn  ; Uncomment to enable warnings to assist with detecting common errors.
; Uncomment for key history
; #InstallKeybdHook
; KeyHistory
; -------------------

SendMode "Input" ; Recommended for new scripts due to its superior speed and reliability.
;SetWorkingDir(A_ScriptDir)  ; Ensures a consistent starting directory.

#Include "%A_ScriptDir%/keyboard-mouse.ahk"
#Include "%A_ScriptDir%/window-management.ahk"
#Include "%A_ScriptDir%/macos.ahk"
#Include "%A_ScriptDir%/apps.ahk"
#Include "%A_ScriptDir%/winkey.ahk"