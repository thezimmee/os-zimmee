#Requires AutoHotkey v2.0

; ============================================================================
;  macOS-style keys on Windows  —  "Option 1": Left-Alt-as-Command
; ----------------------------------------------------------------------------
;  * LAlt (the key under your left thumb) becomes Command, i.e. Control. ONE
;    remap covers every Ctrl shortcut at once — Cmd+C/V/X/Z/S/N/T/W/F/A/P,
;    Cmd+Shift+Z, Cmd+Shift+T, etc. Windows never sees a bare Alt, so there are
;    no stray-Alt menu flashes.
;  * Corner LCtrl stays a real Ctrl -> Mac "Control" + native word-nav
;    (Ctrl+Left/Right, Ctrl+Backspace).
;  * RAlt is left untouched         -> your real Alt (Alt+F4, menus, AltGr).
;  * "Carve-outs" (LAlt & <key>) handle the shortcuts that AREN'T just
;    "Cmd = Ctrl": the app switcher and line/document navigation. A custom
;    combination intercepts the physical thumb+key BEFORE the remap turns the
;    thumb into Ctrl — the only way to tell thumb+key from corner-Ctrl+key.
;
;  Because the remap holds LCtrl down (DownR), each carve-out explicitly lifts
;  it ({LCtrl up}) when it needs non-Ctrl output (Home/End/Alt+Tab), and leaves
;  it held when it WANTS Ctrl (Cmd+Up = Ctrl+Home). {Blind} preserves the
;  physically-held Shift so the same line handles selection.
; ============================================================================

; ---- Command key -----------------------------------------------------------
LAlt::LControl

; ---- App switcher (Cmd+Tab) ------------------------------------------------
; Hold thumb -> Windows switcher opens; tap Tab -> advance (Shift = reverse);
; release thumb -> commit. Self-managed (drops the remap's Ctrl, holds a real
; Alt) so it doesn't depend on the AltTab built-in coexisting with the remap.
LAlt & Tab::
{
    Send "{Blind}{LCtrl up}{Alt down}{Tab}"      ; open switcher, advance once
    KeyWait "Tab"
    while GetKeyState("LAlt", "P") {             ; while thumb still held
        if GetKeyState("Tab", "P") {
            Send GetKeyState("Shift", "P") ? "{Blind}+{Tab}" : "{Blind}{Tab}"
            KeyWait "Tab"
        }
        Sleep 15
    }
    Send "{Alt up}"                              ; thumb released -> commit
}

; ---- Text navigation -------------------------------------------------------
; Cmd+Left/Right = line start/end (Home/End) — lift the remap's Ctrl.
LAlt & Left:: Send "{Blind}{LCtrl up}{Home}"
LAlt & Right::Send "{Blind}{LCtrl up}{End}"

; Cmd+Up/Down = document start/end (Ctrl+Home / Ctrl+End) — KEEP the held Ctrl.
LAlt & Up::  Send "{Blind}{Home}"
LAlt & Down::Send "{Blind}{End}"

; Cmd+Backspace = delete to beginning of line.
LAlt & Backspace::Send "{Blind}{LCtrl up}+{Home}{Delete}"

; (Mac Option+Arrow word-nav and Option+Backspace word-delete are the native
;  Ctrl+Arrow / Ctrl+Backspace on the corner Ctrl key — no mapping needed.)

; ---- Quit (Cmd+Q) ----------------------------------------------------------
; macOS-style quit. Aggressive (closes the active window); comment out if it
; bites. Lifts the remap's Ctrl so the OS sees a clean Alt+F4.
LAlt & q::Send "{Blind}{LCtrl up}!{F4}"
