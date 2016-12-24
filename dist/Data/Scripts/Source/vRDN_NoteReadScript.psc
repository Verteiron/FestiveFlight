Scriptname vRDN_NoteReadScript extends ObjectReference  
{Play sound, cast Happy Thoughts, add the spell if the player doesn't have it}

;--=== Imports ===--

Import Utility
Import Game

;--=== Properties ===--

Actor Property PlayerRef Auto

Spell Property vRDN_HappyThoughtsSpell Auto

;--=== Variables ===--

;--=== Events ===--

Event OnRead()
	WaitMenuMode(1)
	PlayerREF.AddSpell(vRDN_HappyThoughtsSpell)
EndEvent
