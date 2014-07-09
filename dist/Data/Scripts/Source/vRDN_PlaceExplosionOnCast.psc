Scriptname vRDN_PlaceExplosionOnCast extends activemagiceffect  
{Does what it says}

;--=== Imports ===--

Import Utility
Import Game

;--=== Properties ===--

Actor Property PlayerRef Auto
Activator Property FXEmptyActivator Auto
Explosion Property ExplosionToPlace Auto

;--=== Variables ===--

;--=== Events ===--

Event onEffectStart(Actor akTarget, Actor akCaster)
	ObjectReference SpawnPoint = akCaster.PlaceAtMe(FXEmptyActivator)
	SpawnPoint.MoveToNode(akCaster,"NPC Head MagicNode [Hmag]")
	SpawnPoint.PlaceAtMe(ExplosionToPlace)
	Wait(1.0)
	SpawnPoint.Delete()
EndEvent

Event onEffectFinish(Actor akTarget, Actor akCaster)

EndEvent

;--=== Functions ===--
