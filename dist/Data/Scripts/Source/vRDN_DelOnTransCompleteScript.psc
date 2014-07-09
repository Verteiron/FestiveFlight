Scriptname vRDN_DelOnTransCompleteScript extends ObjectReference  
{Does what it says}

;--=== Imports ===--

Import Utility
Import Game

;--=== Properties ===--

;--=== Variables ===--

;--=== Events ===--

Event OnTranslationComplete()
	Disable(True)
	Wait(2)
	Delete()
EndEvent

;--=== Functions ===--
