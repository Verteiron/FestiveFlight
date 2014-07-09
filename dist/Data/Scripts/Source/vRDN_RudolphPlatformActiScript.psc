Scriptname vRDN_RudolphPlatformActiScript extends ObjectReference  
{Handle the Rudolph flying platforms}

;--=== Imports ===--

Import Utility
Import Game

;--=== Properties ===--

Actor Property PlayerRef Auto
Actor Property Rudolph Auto
;	Function Set(Actor akRudolphActor)
;		Rudolph = akRudolphActor
;		;Debug.Trace(self + ": Rudolph set to " + Rudolph)
;		AdjustPlatform()
;	EndFunction
;	Actor Function Get()
;		Return Rudolph
;	EndFunction
;EndProperty

Float Property fDeleteAfter Auto

;--=== Variables ===--

;--=== Events ===--

Event onLoad()
	GoToState("Loaded")
	;Float StartTime = GetCurrentRealTime()
	;SetScale(2)
	;AdjustPlatform()
	;Float EndTime = GetCurrentRealTime()
	;;Debug.Trace(self + ": Adjustment took " + (EndTime - StartTime) + "s")
	If fDeleteAfter
		RegisterForSingleUpdate(fDeleteAfter)
	EndIf
EndEvent

Event OnCellDetach()
	Delete()
EndEvent

Event onUpdate()
	;Debug.Trace(self + ": Deleting!")
	Delete()
EndEvent

State Loaded

	Event onLoad()
		;Do nothing
	EndEvent

EndState

;--=== Functions ===--

Function AdjustPlatform()
	;SetScale(2)
	Float PaX = PlayerREF.GetAngleX()
	Float Heading = PlayerREF.GetAngleZ()
	Float MultX = math.cos(Heading)
	Float MultY = -math.sin(Heading)
	
	Float angleOffset = PaX - 5

	If angleOffset < -20
		angleOffset = -20
	ElseIf angleOffset > 20
		angleOffset = 20
	EndIf
	
	;TranslateTo(Self.GetPositionX(),Self.GetPositionY(),Self.GetPositionZ(),MultX * angleOffset, MultY * angleOffset,0,100,360)
	SetAngle(MultX * angleOffset, MultY * angleOffset,PlayerREF.GetAngleZ() + 90)
	SetPosition(PlayerREF.X,PlayerREF.Y,PlayerREF.Z - 125)
	;Debug.Trace(self + ": Placed platform at " + angleOffset + " degree tilt.")
EndFunction