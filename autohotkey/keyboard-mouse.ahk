#Requires AutoHotkey v2.0

; ============================================================================
;  Mouse buttons on keyboard keys.  (Raycast doesn't do this — AHK's job.)
; ============================================================================

F1::LButton
F2::RButton
F3::MButton

; ============================================================================
;  CapsLock = Hyper (Win+Alt), for binding shortcuts in OTHER apps (Raycast…).
;  CapsLock is dual-role: tapped ALONE it sends Win+Space (e.g. a launcher);
;  held with another key it's a prefix that emits a real Win+Alt+<key> the
;  focused app receives. The lone-tap fires on release, and only if no combo was
;  used. Win+Alt avoids the AltGr collision Ctrl+Alt has.
;  NOTE: Win+Alt+1..9 open taskbar jump lists, so those may be shadowed by
;  Windows before an app sees them. (SetCapsLockState "AlwaysOff" is in init.ahk.)
; ============================================================================
; Letters + digits…
for hyperChar in StrSplit("abcdefghijklmnopqrstuvwxyz0123456789", "")
    Hotkey("CapsLock & " hyperChar, HyperSend.Bind(hyperChar))
; …punctuation and named keys (explicit list avoids string-escaping headaches).
for hyperChar in [";", "'", ",", ".", "/", "[", "]", "-", "=", "Space", "Enter"]
    Hotkey("CapsLock & " hyperChar, HyperSend.Bind(hyperChar))

; Lone CapsLock tap -> Win+Space (fires on release, only if no combo was used).
Hotkey("CapsLock", (*) => Send("#{Space}"))

; (Win+R/I/X intentionally dropped: the physical Win key is Option/Alt, and gating
; plain letter keys on its physical state is unsafe — a missed key-up leaves them
; firing on bare r/i/x. Reach Run/Settings via the launcher instead.)

; Brace-wrap the key so named keys ({Space}/{Enter}) and punctuation all send right.
HyperSend(ch, *) {
    Send("{LWin Down}{LAlt Down}{" ch "}{LAlt Up}{LWin Up}")
}
