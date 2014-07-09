Scriptname vRDN_RudolphActorScript extends Actor  
{Make sure nose is lit!}

;--=== Imports ===--

Import Utility
Import Game

;--=== Properties ===--

Activator Property vRDN_RudolphVanishFXActi Auto

GlobalVariable Property vRDN_cfgFlightMasterEnable Auto
GlobalVariable Property vRDN_cfgNoseGlowEnable Auto
GlobalVariable Property vRDN_cfgTwinkleToesEnable Auto
GlobalVariable Property vRDN_cfgSpeedMult Auto
GlobalVariable Property vRDN_cfgVanishTime Auto

Idle Property DeerIdleStop Auto
Idle Property DeerIdleRoot Auto

Spell Property vRDN_abShinyNoseSpell Auto
Spell Property vRDN_abShinyToesSpell Auto
Spell Property vRDN_abFlightSpell Auto

;--=== Variables ===--

;--=== Events ===--

Event OnLoad()
	If HasSpell(vRDN_abShinyNoseSpell)
		RemoveSpell(vRDN_abShinyNoseSpell)
	EndIf
	Wait(1.0)
	UpdateConfig()
	CalmDown()
EndEvent

Event OnActivate(ObjectReference akActivator)
	;Debug.SendAnimationEvent(Self,"IdleStop")
	PlayIdle(DeerIdleStop)
	If IsBeingRidden()
		UnregisterForUpdateGameTime()
	EndIf
	Wait(5)
	If !IsBeingRidden() 
		Debug.Trace("vRDN_RudolphActorScript: Player dismounted!")
		ClearLookAt()
		SetHeadTracking(False)
		PlayIdle(DeerIdleRoot)
		SetHeadTracking(True)
		SetLookAt(Game.GetPlayer())
		If vRDN_cfgVanishTime.GetValue()
			RegisterForSingleUpdateGameTime(vRDN_cfgVanishTime.GetValue())
		EndIf
	EndIf
	;akActivator.SetAngle(0,0,Self.GetAngleZ())
EndEvent

Event OnUpdateGameTime()
	If !IsBeingRidden() && vRDN_cfgVanishTime.GetValue()
		PlaceAtMe(vRDN_RudolphVanishFXActi)
	EndIf
EndEvent

Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
	GotoState("ProcessingHit") ; avoid spamming script VM with rapid hits from conc spells or hazards
	Debug.Trace("vRDN_RudolphActorScript: Got hit! Calming down...")
	If (akAggressor as Actor)
		CalmDown()
		If (akAggressor as Actor).GetCombatTarget() == Self
			(akAggressor as Actor).StopCombat()
			(akAggressor as Actor).SetRelationshipRank(Self,3)
		EndIf
	EndIf
	Wait(1)
	GotoState("")
EndEvent

State ProcessingHit
	Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
		;Do nothing
	EndEvent
EndState

Event OnCombatStateChanged(Actor akTarget, int aeCombatState)
	If aeCombatState > 1
		Debug.Trace("vRDN_RudolphActorScript: Entered combat, calming down...")
		CalmDown()
	EndIf
EndEvent

Event OnTranslationComplete()
	;EnableAI(True)
	SetAlpha(1.0,True)
EndEvent

Function UpdateConfig()
	Debug.Trace("vRDN_RudolphActorScript: UpdateConfig called on Rudolph actor...")
	Debug.Trace("vRDN_RudolphActorScript:  vRDN_cfgFlightMasterEnable is " + vRDN_cfgFlightMasterEnable.GetValue())
	If !vRDN_cfgFlightMasterEnable.GetValue() ;&& HasSpell(vRDN_abFlightSpell)
		RemoveSpell(vRDN_abFlightSpell)
		Debug.Trace("vRDN_RudolphActorScript:  Removed Flight Spell from Rudolph")
	ElseIf vRDN_cfgFlightMasterEnable.GetValue() ;&& !HasSpell(vRDN_abFlightSpell)
		AddSpell(vRDN_abFlightSpell)
		Debug.Trace("vRDN_RudolphActorScript:  Added Flight Spell to Rudolph")
	EndIf
	If !vRDN_cfgNoseGlowEnable.GetValue() ;&& HasSpell(vRDN_abShinyNoseSpell)
		RemoveSpell(vRDN_abShinyNoseSpell)
		Debug.Trace("vRDN_RudolphActorScript:  Removed Shiny Nose Spell from Rudolph")
	ElseIf vRDN_cfgNoseGlowEnable.GetValue() ;&& !HasSpell(vRDN_abShinyNoseSpell)
		AddSpell(vRDN_abShinyNoseSpell)
		Debug.Trace("vRDN_RudolphActorScript:  Added Shiny Nose Spell to Rudolph")
	EndIf
	If !vRDN_cfgTwinkleToesEnable.GetValue() ;&& HasSpell(vRDN_abShinyToesSpell)
		RemoveSpell(vRDN_abShinyToesSpell)
		Debug.Trace("vRDN_RudolphActorScript:  Removed TwinkleToes Spell from Rudolph")
	ElseIf vRDN_cfgTwinkleToesEnable.GetValue() ;&& !HasSpell(vRDN_abShinyToesSpell)
		AddSpell(vRDN_abShinyToesSpell)
		Debug.Trace("vRDN_RudolphActorScript:  Added TwinkleToes Spell to Rudolph")
	EndIf
	If vRDN_cfgVanishTime.GetValue()
		Debug.Trace("vRDN_RudolphActorScript:  Rudolph vanishes after " + vRDN_cfgVanishTime.GetValue() + " hours of game time")
	Else
		Debug.Trace("vRDN_RudolphActorScript:  Rudolph never vanishes")
	EndIf
	SetActorValue("SpeedMult",vRDN_cfgSpeedMult.GetValue())
	ModAV("CarryWeight",0.1)
	ModAV("CarryWeight",-0.1)
	If !IsBeingRidden() && vRDN_cfgVanishTime.GetValue()
		RegisterForSingleUpdate(vRDN_cfgVanishTime.GetValue() * 60)
	EndIf
	Debug.Trace("vRDN_RudolphActorScript: UpdateConfig completed on Rudolph actor!")
EndFunction

Function CalmDown()
	SetAV("Aggression",0)
	SetAV("Assistance",0)
	StopCombat()
	StopCombatAlarm()
EndFunction