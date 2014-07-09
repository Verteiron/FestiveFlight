Scriptname vRDN_EmergencyLandingActiScript extends ObjectReference  
{Summon the reindeer to this point very quickly}

;--=== Imports ===--

Import Utility
Import Game

;--=== Properties ===--

Actor Property PlayerRef Auto
ActorBase Property vRDN_Rudolph Auto

Activator Property vRDN_DescentFX Auto

GlobalVariable Property vRDN_FlyingGlobal Auto

Sound Property VOCShoutProjectilePush03 Auto

VisualEffect Property vRDN_DescentBallVFX Auto

;--=== Variables ===--

;--=== Events ===--

Event onLoad()
	Debug.Trace(self + ": Loaded!")
	Wait(2)
	Actor Rudolph = FindClosestReferenceOfTypeFromRef(vRDN_Rudolph,Self,100000) as Actor
	If !Rudolph
		Debug.Trace(self + ": Not found :(")
		Delete()
		Return
	EndIf
	Float Distance = GetDistance(Rudolph)
	Debug.Trace(self + ": Distance is " + Distance)
	Debug.Trace(self + ": ZDiff is " + (Rudolph.Z - Self.Z))
	Debug.Trace(self + ": TranslatingTo " + Self.X + ", " + Self.Y + ", " + (Self.Z + 20) + ", Angle: " + PlayerREF.GetAngleX() + ", 0, " + Rudolph.GetAngleZ())
	Float Velocity = 100 + (Distance / 2)
	If Velocity > 5000
		Velocity = 5000
	EndIf
	;If !Rudolph.IsBeingRidden()
	;	PlayerREF.MoveTo(Self,0,0,20)
	;EndIf
	Rudolph.TranslateTo(Self.X,Self.Y,Self.Z + 20,0,0,Rudolph.GetAngleZ(),Velocity,7200) ;SplineTranslateToRef(Self,Distance / 10,350,0)
	If Velocity > 500
		Rudolph.SetAlpha(0.5,True)
		VOCShoutProjectilePush03.Play(Rudolph)
		;ObjectReference DescentFX = Rudolph.PlaceAtMe(vRDN_DescentFX)
		;DescentFX.TranslateTo(Self.X,Self.Y,Self.Z + 20,0,0,Rudolph.GetAngleZ(),Velocity) ;SplineTranslateToRef(Self,Distance / 10,350,0)
		vRDN_DescentBallVFX.Play(Rudolph,Distance / Velocity)
	EndIf
	Wait(1)
	Delete()
EndEvent

Event onUpdate()
EndEvent

;--=== Functions ===--
