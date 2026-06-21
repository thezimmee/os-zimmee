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

; ---- Option key: the Win-position key becomes Alt, mirroring a Mac's Option.
;      (Synthetic Win from the Hyper key / CapsLock launcher is unaffected.)
LWin::LAlt

; ---- Real Ctrl + real Alt from the two physical keys ------------------------
; The left-Alt key is Command (Ctrl). But while the REAL (corner) Ctrl is also
; physically held, left-Alt reverts to a real Alt, so corner-Ctrl + left-Alt =
; Ctrl+Alt (e.g. for Raycast hotkeys that need both). Works because the global
; LAlt::LControl above has no #HotIf (lowest priority), so this variant outranks it.
#HotIf GetKeyState("LCtrl", "P")
LAlt::LAlt
#HotIf
; …and the reverse press order (left-Alt held first, then corner Ctrl): the
; corner Ctrl keeps its native Ctrl (~) and adds a real Alt, so the pair reads as
; Ctrl+Alt either way. (Edge: releasing left-Alt before the corner Ctrl can leave
; Alt briefly held until the Ctrl is released.)
#HotIf GetKeyState("LAlt", "P")
~LCtrl::Send "{Blind}{LAlt Down}"
~LCtrl Up::Send "{Blind}{LAlt Up}"
#HotIf

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

; Text navigation. In File Explorer the horizontal/up keys instead navigate
; Back / Forward / Parent (see ExplorerNav below).
*Left::                                          ; Cmd+Left = line start (Explorer: Back)
{
    if ExplorerNav("Left")
        return
    Send "{Blind}{LCtrl up}{Home}"
    RestoreCmd()
}
*Right::                                         ; Cmd+Right = line end (Explorer: Forward)
{
    if ExplorerNav("Right")
        return
    Send "{Blind}{LCtrl up}{End}"
    RestoreCmd()
}
*Up::                                            ; Cmd+Up = doc top (Explorer: parent folder)
{
    if ExplorerNav("Up")
        return
    Send "{Blind}{Home}"
}
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

; In File Explorer, Cmd+Left/Right/Up = Back / Forward / Parent (Alt+Left/Right/Up).
; Clean send (no Blind, no RestoreCmd): a Ctrl re-press right after the nav reads
; as Ctrl+navigation and opens a new window. Returns true if it handled the key.
ExplorerNav(navKey) {
    if !WinActive("ahk_exe explorer.exe")
        return false
    Send "{LCtrl up}!{" navKey "}"
    return true
}

; (Mac Option+Arrow word-nav and Option+Backspace word-delete are the native
;  Ctrl+Arrow / Ctrl+Backspace on the corner Ctrl key — no mapping needed.)
