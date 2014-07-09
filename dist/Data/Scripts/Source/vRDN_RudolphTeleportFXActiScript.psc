Scriptname vRDN_RudolphTeleportFXActiScript extends ObjectReference  
{Teleport FX}

;--=== Imports ===--

Import Utility
Import Game

;--=== Properties ===--

Actor Property PlayerRef Auto
Actor Property vRDN_Rudolph Auto

ShaderParticleGeometry Property MAGBlizzardParticles Auto

Sound Property vRDN_RudolphTeleportFXSM Auto

Light Property vRDN_ShinyNoseLight Auto
Light Property vRDN_ShinyNoseLightMesh Auto

Bool Property UnSpawn = False Auto

;--=== Variables ===--

ObjectReference _NoseLight

;--=== Events ===--

Event onLoad()
	GoToState("Loaded")
	SetScale(2.4)
	While !Is3DLoaded()
		Wait(0.01)
	EndWhile
	If !UnSpawn
		SpawnRudolph()
	Else
		UnSpawnRudolph()
	EndIf
	RegisterForSingleUpdate(5)
EndEvent

Event onUpdate()
	Debug.Trace(self + ": Deleting!")
	_NoseLight.Delete()
	Delete()
EndEvent

State Loaded

	Event onLoad()
		;Do nothing
	EndEvent

EndState

;--=== Functions ===--

Function SpawnRudolph()
	vRDN_Rudolph.DisableNoWait(False)
	TranslateTo(GetPositionX(),GetPositionY(),GetPositionZ() + 50,0,0,GetAngleZ(),50,360)
	MAGBlizzardParticles.Apply(1.0)
	vRDN_RudolphTeleportFXSM.Play(Self)
	;Wait(1)
	_NoseLight = PlaceAtMe(vRDN_ShinyNoseLightMesh,abInitiallyDisabled = True)
	_NoseLight.MoveTo(Self,0,0,50)
	Wait(0.5)
	;_NoseLight.MoveToNode(vRDN_Rudolph,"ElkScull")
	Float fScale = 10
	_NoseLight.SetScale(fScale)
	_NoseLight.EnableNoWait(True)
	;While fScale < 9
;		_NoseLight.SetScale(fScale)
		;fScale += 0.1
	;EndWhile
	Wait(1)
	vRDN_Rudolph.MoveTo(Self)
	vRDN_Rudolph.SetAngle(0,0,vRDN_Rudolph.GetAngleZ() + vRDN_Rudolph.GetHeadingAngle(PlayerREF))
	;vRDN_Rudolph.SetHeadTracking(PlayerREF)
	;vRDN_Rudolph.SetAlpha(1,False)
	vRDN_Rudolph.EnableNoWait(True)
	MAGBlizzardParticles.Remove(3.0)
	Wait(1)
	_NoseLight.DisableNoWait(True)
EndFunction

Function UnSpawnRudolph()
	ObjectReference NorthPoleMarker = GetFormFromFile(0x00005393,"vRDN_Rudolph.esp") as ObjectReference
	TranslateTo(GetPositionX(),GetPositionY(),GetPositionZ() + 50,0,0,GetAngleZ(),50,360)
	;Wait(1)
	_NoseLight = PlaceAtMe(vRDN_ShinyNoseLightMesh,abInitiallyDisabled = True)
	_NoseLight.MoveTo(Self,0,0,50)
	_NoseLight.SetScale(10)
	_NoseLight.EnableNoWait(True)
	MAGBlizzardParticles.Apply(1.0)
	vRDN_RudolphTeleportFXSM.Play(Self)
	Wait(0.5)
	vRDN_Rudolph.DisableNoWait(True)
	MAGBlizzardParticles.Remove(3.0)
	Wait(1)
	vRDN_Rudolph.MoveTo(NorthPoleMarker)
	_NoseLight.DisableNoWait(True)
EndFunction