#Requires AutoHotkey v2.0

SetCapsLockState "AlwaysOff"


;*CapsLock down::Send "{LButton down}"
;!CapsLock::RButton

CapsLock::Ctrl
#`::`

;^j::#Left
;^l::#Right
;^i::#Up
;^k::#Down

#u::#Left
#o::#Right
#i::#Up
#k::#Down