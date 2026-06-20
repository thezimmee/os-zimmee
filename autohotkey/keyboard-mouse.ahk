#Requires AutoHotkey v2.0

; ============================================================================
;  Mouse buttons on keyboard keys.  (Raycast doesn't do this — AHK's job.)
; ============================================================================

F1::LButton
F2::RButton
F3::MButton

; ---- CapsLock --------------------------------------------------------------
; Undecided — historically used as both LButton and Ctrl. Pick a role and
; uncomment. Examples:
;   SetCapsLockState "AlwaysOff"
;   CapsLock::LButton          ; left-click
;   CapsLock::Escape           ; macOS-ish (or a Hyper modifier)
