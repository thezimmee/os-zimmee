#Requires AutoHotkey v2.0

; ============================================================================
;  Per-application overrides. Every #HotIf block MUST end with a bare #HotIf.
; ============================================================================

; ---- Brave: focus the address bar ("insert cursor" in the omnibox) ----------
; Ctrl+L is swallowed in this Brave (extension/profile), but Alt+D focuses the
; omnibox here. So route Ctrl+L and Ctrl+O to Alt+D. The Command remap holds
; Ctrl down, so lift it first — otherwise the OS sees Ctrl+Alt+D.
#HotIf WinActive("ahk_exe brave.exe")
^l::Send "{Blind}{LCtrl up}!d"      ; Ctrl+L -> Alt+D (focus address bar)
^o::Send "{Blind}{LCtrl up}!d"      ; Ctrl+O -> Alt+D (focus address bar)
#HotIf
