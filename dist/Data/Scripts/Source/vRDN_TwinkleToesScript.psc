Scriptname vRDN_TwinkleToesScript extends ActiveMagicEffect  
{Pretty lights!}

;--=== Imports ===--

Import Utility
Import Game

;--=== Properties ===--

Actor Property PlayerRef Auto

Activator Property FXEmptyActivator Auto
Activator Property vRDN_TwinkleToesActi Auto

Explosion Property FXdartDustExplosion Auto

ImpactDataSet Property vRDN_NPCRudolphFootWalkBackImpactSet Auto
ImpactDataSet Property vRDN_NPCRudolphFootWalkFrontImpactSet Auto

;--=== Variables ===--

Int _iFootStepF
Int _iFootStepB

String _sLastEventName
String _sEventName

Bool _bOnRight

Actor _SelfRef

;ObjectReference _SpawnPoint

;--=== Events ===--

Event OnInit()

EndEvent

Event onEffectStart(Actor akTarget, Actor akCaster)
	_SelfRef = akTarget

	RegisterForAnimationEvent(_SelfRef,"FootFront")
	RegisterForAnimationEvent(_SelfRef,"FootBack")
	;RegisterForAnimationEvent(_SelfRef,"syncRight")
	;RegisterForAnimationEvent(_SelfRef,"syncLeft")
	RegisterForAnimationEvent(_SelfRef,"walkStart")
	;RegisterForAnimationEvent(_SelfRef,"runStart")
EndEvent

Event onUpdate()
EndEvent

Event OnAnimationEvent(ObjectReference akSource, String asEventName)
	
	If asEventName == "walkStart"
		_iFootStepF = 0
		_iFootStepB = 0
	ElseIf asEventName == "FootFront"
		If _iFootStepF % 2
			_SelfRef.PlayImpactEffect(vRDN_NPCRudolphFootWalkFrontImpactSet, "ElkLPhalangesManus", 0, 0, -0.5, 64)
		Else
			_SelfRef.PlayImpactEffect(vRDN_NPCRudolphFootWalkFrontImpactSet, "ElkRPhalangesManus", 0, 0, -0.5, 64)
		EndIf
		_iFootStepF += 1
	ElseIf asEventName == "FootBack"
		If _iFootStepB % 2
			_SelfRef.PlayImpactEffect(vRDN_NPCRudolphFootWalkBackImpactSet, "ElkLPhalanxPrima", 0, 0, -0.5, 64)
		Else
			_SelfRef.PlayImpactEffect(vRDN_NPCRudolphFootWalkBackImpactSet, "ElkRPhalanxPrima", 0, 0, -0.5, 64)
		EndIf
		_iFootStepB += 1
	EndIf
	
EndEvent

Event onEffectFinish(Actor akTarget, Actor akCaster)
;	If _SpawnPoint
;		_SpawnPoint.Delete()
;	EndIf
EndEvent

;--=== Functions ===--
