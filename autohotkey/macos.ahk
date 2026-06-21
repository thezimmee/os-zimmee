#Requires AutoHotkey v2.0

; ============================================================================
;  macOS-style keys on Windows  —  "Option 1": Left-Alt-as-Command
; ----------------------------------------------------------------------------
;  Gotchas baked into this design (all verified the hard way):
;
;  1. A key can't be BOTH a remap (LAlt::LControl) AND a custom-combo prefix
;     (LAlt & key) — the first "LAlt & x" kills the remap. So carve-outs use a
;     #HotIf context, which does NOT make LAlt a prefix.
;  2. The remap holds LCtrl DOWN while the thumb is held, so carve-out keys
;     arrive as Ctrl+<key>; a plain hotkey won't match. => wildcard (*) prefix.
;  3. A carve-out that lifts the held Ctrl ({LCtrl up}) must RESTORE it (if the
;     thumb is still down) or the next Cmd+C in the same hold becomes plain "c".
;     RestoreCmd() does that.
;
;  {Blind} preserves a physically-held Shift, so one line also covers selection.
;  Corner LCtrl stays a real Ctrl (Mac "Control" + native word-nav). RAlt is
;  untouched (real Alt). App launch/switch/window mgmt are Raycast's job.
; ============================================================================

; ---- Command key: covers every standard Ctrl shortcut at once --------------
LAlt::LControl

; ---- Carve-outs: active ONLY while the left thumb is physically held -------
#HotIf GetKeyState("LAlt", "P")

; App switcher (Cmd+Tab): hold thumb -> switcher opens; tap Tab to advance
; (Shift = reverse); release thumb -> commit.
*Tab::
{
    Send "{Blind}{LCtrl up}{Alt down}{Tab}"      ; open switcher, advance once
    KeyWait "Tab"
    while GetKeyState("LAlt", "P") {              ; while thumb still held
        if GetKeyState("Tab", "P") {
            Send GetKeyState("Shift", "P") ? "{Blind}+{Tab}" : "{Blind}{Tab}"
            KeyWait "Tab"
        }
        Sleep 15
    }
    Send "{Alt up}"                              ; thumb released -> commit
    RestoreCmd()
}

; Text navigation
*Left::                                          ; Cmd+Left  = line start
{
    Send "{Blind}{LCtrl up}{Home}"
    RestoreCmd()
}
*Right::                                         ; Cmd+Right = line end
{
    Send "{Blind}{LCtrl up}{End}"
    RestoreCmd()
}
*Up::   Send "{Blind}{Home}"                     ; Cmd+Up   = doc start (Ctrl held -> Ctrl+Home)
*Down:: Send "{Blind}{End}"                      ; Cmd+Down = doc end
*Backspace::                                     ; Cmd+Backspace = delete to line start
{
    Send "{Blind}{LCtrl up}+{Home}{BS}"
    RestoreCmd()
}

; Quit (Cmd+Q) = close active window. Comment out if it bites.
*q::Send "{Blind}{LCtrl up}!{F4}"

#HotIf

; Re-press the Command (Ctrl) the remap was holding, so Cmd+<letter> keeps
; working within the same thumb-hold after a carve-out lifted it.
RestoreCmd() {
    if GetKeyState("LAlt", "P")
        Send "{Blind}{LCtrl down}"   ; Blind: re-press Ctrl WITHOUT disturbing a held Shift
}

; (Mac Option+Arrow word-nav and Option+Backspace word-delete are the native
;  Ctrl+Arrow / Ctrl+Backspace on the corner Ctrl key — no mapping needed.)
