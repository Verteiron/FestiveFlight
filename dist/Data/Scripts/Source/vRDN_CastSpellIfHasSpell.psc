Scriptname vRDN_CastSpellIfHasSpell extends activemagiceffect  
{Does what it says}

;--=== Imports ===--

Import Utility
Import Game

;--=== Properties ===--

Actor Property PlayerRef Auto

Spell Property SpellToCast Auto
{Spell to cast if cast has SpellToCheck}
Spell Property SpellToCheck Auto
{Spell to check. If empty, same as SpellToCast}
;--=== Variables ===--

;--=== Events ===--


Event onEffectStart(Actor akTarget, Actor akCaster)
	If !SpellToCheck
		SpellToCheck = SpellToCast
	EndIf
	If akCaster.HasSpell(SpellToCheck)
		SpellToCast.Cast(akCaster)
	EndIf
EndEvent

Event onEffectFinish(Actor akTarget, Actor akCaster)
EndEvent

;--=== Functions ===--
