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

; Keep Win+R/I/X on the PHYSICAL Win key (which is Option/Alt now): while it is
; held, r/i/x send the native Win shortcut instead of Alt+<key>. Wildcard (*)
; fires through the remap's held Alt, which we drop before the synthetic #-send.
#HotIf GetKeyState("LWin", "P")
*r::Send "{Blind}{LAlt up}#r"   ; Win+R  (Run)
*i::Send "{Blind}{LAlt up}#i"   ; Win+I  (Settings)
*x::Send "{Blind}{LAlt up}#x"   ; Win+X  (power-user menu)
#HotIf

; Brace-wrap the key so named keys ({Space}/{Enter}) and punctuation all send right.
HyperSend(ch, *) {
    Send("{LWin Down}{LAlt Down}{" ch "}{LAlt Up}{LWin Up}")
}
