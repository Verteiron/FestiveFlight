Scriptname vRDN_FlightTestActiScript extends ObjectReference  
{Test whether we're flying or grounded}

;--=== Imports ===--

Import Utility
Import Game

;--=== Properties ===--

Actor Property PlayerRef Auto

Formlist Property vRDN_FlightTestHazards Auto

GlobalVariable Property vRDN_FlyingGlobal Auto

Hazard Property vRDN_FlightTestHazard Auto
Hazard Property vRDN_GroundTestHazard Auto

;--=== Variables ===--

;--=== Events ===--

Event onLoad()
	;Debug.Trace(self + ": Loaded!")
	ObjectReference FoundObject = FindClosestReferenceOfAnyTypeInListFromRef(vRDN_FlightTestHazards,Self,100)
	If !FoundObject
		Delete()
		Return
	EndIf
	Hazard FoundHazard = FoundObject.GetBaseObject() as Hazard
	Float PlayerDistance = GetDistance(PlayerREF)
	If vRDN_FlightTestHazard == FoundHazard && !vRDN_FlyingGlobal.GetValue()
		vRDN_FlyingGlobal.SetValue(1)
		;Debug.Trace("Flying! " + PlayerDistance)
	ElseIf vRDN_GroundTestHazard == FoundHazard && vRDN_FlyingGlobal.GetValue()
		vRDN_FlyingGlobal.SetValue(0)
		;Debug.Trace("Grounded! " + PlayerDistance)
	EndIf
	Delete()
EndEvent

Event onUpdate()
EndEvent

;--=== Functions ===--
