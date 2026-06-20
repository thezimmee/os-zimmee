#Requires AutoHotkey v2.0

#SingleInstance force

; ---
; BASIC SHORTCUTS
; ---------------
; Cut, copy, & paste.
!x::^x
!c::^c
!v::^v

; Undo, redo.
!z::^z
!y::^y

; New, open, save, find.
!n::^n
!o::^o
!s::^s
!+s::^+s
!f::^f

; New tab, close tab, close window.
!t::^t
!w::^w
!q::Send "!{F4}"

; Print.
!p::^p

; Select all.
!a::^a

; Cursor movement.
!up::^Home
!down::^End
!left::Home
!right::End
#left::!left
#right::!right

; Delete
#backspace::^backspace
!backspace::
{
    Send "{Shift down}"
    Send "{Home}"
    Send "{BS}"
    Send "{Shift up}"
}
