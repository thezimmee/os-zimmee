#Requires AutoHotkey v2.0

; ============================================================================
;  Plain global hotkeys — not mouse remaps, not macOS emulation, not per-app.
; ============================================================================

; Ctrl+Q closes the active window (like Alt+F4), overriding any app's own
; Ctrl+Q binding.
^q::Send "!{F4}"

; ============================================================================
;  Copilot key -> Right Ctrl.  (Laptop has no physical RCtrl.)
;
;  The Copilot key firmware emits LWin + LShift + F23 together and auto-repeats
;  the whole chord while held.  A plain remap holds RControl but lets the Win +
;  Shift leak through, so the OS sees Win+Shift+Ctrl (breaking Ctrl+key combos).
;
;  F23 is unique to this key, so: hold a clean RControl on F23, clear any Win +
;  Shift the chord leaked, and suppress the repeating Win + Shift while held.
; ============================================================================

;  {Blind} is essential: without it, Send re-presses (restores) the Win + Shift
;  it thinks are physically held, re-leaking them right after we release them.
*F23::Send "{Blind}{LWin up}{LShift up}{RControl down}"
*F23 up::Send "{Blind}{RControl up}"

#HotIf GetKeyState("F23", "P")   ; only while the Copilot key is physically held
*LWin::Return
*LShift::Return
#HotIf
