#Requires AutoHotkey v2.0

; ---
; TOGGLE APPS
; -----------
^+j::ToggleApp("sublime_text.exe", "C:\Program Files\Sublime Text\sublime_text.exe")
^+k::ToggleApp("brave.exe", "C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe")
;^+;::ToggleApp("git-bash.exe", "C:\Program Files\Git\git-bash.exe")
^+;::ToggleApp("WindowsTerminal.exe", "C:\Users\thezi\AppData\Local\Microsoft\WindowsApps\wt.exe")
;^+m::ToggleApp("olk.exe")
^+n::ToggleApp("Notion.exe", "C:\Users\thezi\AppData\Local\Programs\Notion")

ToggleApp(exe, path)
{
	if WinActive("ahk_exe " exe) {
		WinMoveBottom
		Send "!{Tab}"
	} else if WinExist("ahk_exe " exe) {
    	WinActivate
	} else {
    	Run path
	}
}

; ---
; BRAVE BROWSER
; -------------
#HotIf WinActive("ahk_exe brave.exe")
; !l::!d
!r::^r
; !left::!left
; !right::!right
; ![::!left
; !]::!right

; ---
; WINDOWS TERMINAL
; ----------------
#HotIf WinActive("ahk_exe WindowsTerminal.exe")
!backspace::^backspace
#backspace::^u

; ---
; EXPLORER
; --------
#HotIf WinActive("ahk_exe explorer.exe")
#Up::!Up

; ---
; NOTION
; ------
#HotIf WinActive("ahk_exe Notion.exe")
#left::^left
#right::^right
!b::^b
!i::^i
!u::^u

; ---
; REVIT
; -----
#HotIf WinActive("ahk_exe Revit.exe")
!w::^F4
`::MButton