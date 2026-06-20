#Requires AutoHotkey v2.0
#SingleInstance Force

; ============================================================================
;  Entry point. Run / reload THIS file only — it assembles the whole config.
;
;  Modifier symbols:   # Win    + Shift    ! Alt    ^ Ctrl    & combine keys
;
;  Division of labour:
;    * Raycast  -> app launch/switch, window management.
;    * This     -> macOS-style in-app shortcuts, text navigation, mouse buttons.
; ============================================================================

SendMode "Input"           ; fast, reliable key delivery
SetWorkingDir A_ScriptDir  ; consistent base dir

#Include "%A_ScriptDir%/macos.ahk"
#Include "%A_ScriptDir%/keyboard-mouse.ahk"
