Scriptname vRDN_FlightMEScript extends activemagiceffect  
{Whoa.}

;--=== Imports ===--

Import Utility
Import Game

;--=== Properties ===--

Actor Property PlayerRef Auto

Activator Property FXEmptyActivator Auto
Activator Property vRDN_RudolphFlightPathActi Auto
Activator Property vRDN_RudolphPlatformActi Auto
Activator Property vRDN_RudolphTakeOffActi Auto

GlobalVariable Property vRDN_cfgChanged Auto
GlobalVariable Property vRDN_FlyingGlobal Auto
GlobalVariable Property vRDN_cfgFlightEmergencyLandingDelay Auto
GlobalVariable Property vRDN_cfgFlightEmergencyLandingEnable Auto
GlobalVariable Property vRDN_cfgFlightHoldJumpToClimbEnable Auto
GlobalVariable Property vRDN_cfgFlightHoldJumpToFlyEnable Auto

GlobalVariable Property vRDN_cfgFlightMaxAngleAscent Auto
GlobalVariable Property vRDN_cfgFlightMaxAngleDescent Auto
GlobalVariable Property vRDN_cfgFlightSmoothing Auto
GlobalVariable Property vRDN_cfgFlightStaticCollisionsAlwaysEnable Auto
GlobalVariable Property vRDN_cfgFlightStaticCollisionsTakeOffEnable Auto
GlobalVariable Property vRDN_cfgFlightTrackingEnable Auto
GlobalVariable Property vRDN_cfgFlightTrackingType Auto

Message Property vRDN_HelpEmergencyLandingMSG Auto

ImpactDataSet Property FXDragonTailstompImpactSet Auto

Spell Property vRDN_FlightTestSpell Auto
Spell Property vRDN_ELandingPlacerSpell Auto

Float Property DeadZoneRange = 10.0 Auto

;--=== Variables ===--

Int  _FlightEmergencyLandingDelay 
Bool _FlightEmergencyLandingEnable 
Bool _FlightHoldJumpToClimbEnable 
Bool _FlightHoldJumpToFlyEnable 

Int  _FlightMaxAngleAscent 
Int  _FlightMaxAngleDescent 
Int  _FlightSmoothing 
Bool _FlightStaticCollisionsAlwaysEnable 
Bool _FlightStaticCollisionsTakeOffEnable 
Bool _FlightTrackingEnable 
Int  _FlightTrackingType 

;ObjectReference _SpawnPoint
;ObjectReference _PlatformSpawnPoint
ObjectReference[] _FlyingPlatform
ObjectReference _StablePlatform

Int _CurrentPlatformIndex
Int _PlatformIndex

Int _FlightCount

Bool _Rising
Bool _Falling
Bool _Level
Bool _Stopped
Bool _FlyingPrev
Bool _Flying
Bool _Landing

Float _LastTime
Float _ThisTime

Float _FlightAngleAverage

Float _PaX
Float _PaXPrev
Float _RaX
Float _RaXPrev

Float _JumpKey

Actor _SelfRef

;--=== Events ===--

Event OnInit()

EndEvent

Event onEffectStart(Actor akTarget, Actor akCaster)
	Debug.Trace("vRDN_FlightMEScript: Flight spell starting up...")
	_SelfRef = akTarget
	;_SpawnPoint = akTarget.PlaceAtMe(FXEmptyActivator)
	;While !_SpawnPoint.Is3DLoaded()
		;Wait(0.01)
	;EndWhile
	;_SpawnPoint.TranslateTo(_SelfRef.GetPositionX(),_SelfRef.GetPositionY(),_SelfRef.GetPositionZ() - 30000,0,0,0,999999)
	_FlyingPlatform = New ObjectReference[3]
	SpawnPlatforms()
	UpdateConfig()
	RegisterForAnimationEvent(_SelfRef,"syncRight")
	RegisterForAnimationEvent(_SelfRef,"syncLeft")
	;RegisterForAnimationEvent(_SelfRef,"FootFront")
;	RegisterForAnimationEvent(_SelfRef,"FootBack")
	RegisterForSingleUpdate(1)
	;_JumpKey = Input.GetMappedKey("Jump")
	;RegisterForControl("Jump")
	
	If _FlightSmoothing < 1
		_FlightSmoothing = 1
	EndIf
	Debug.Trace("vRDN_FlightMEScript: Ready!")
EndEvent

Event OnControlDown(String control)
	If _FlightHoldJumpToClimbEnable
		_Rising = True
	EndIf
EndEvent

Event OnControlUp(String control, Float HoldTime)
	_Rising = False
EndEvent

Event OnAnimationEvent(ObjectReference akSource, String asEventName)
	If asEventName == "syncRight" 
		CheckFlight()
	ElseIf asEventNAme == "syncLeft"
		UpdatePlatforms()
		If _Landing
			_Landing = False
			_SelfRef.PlayImpactEffect(FXDragonTailstompImpactSet,"ElkLFrontHoof",0,0,-0.5,512) ;Elk_COM
		EndIf
	;ElseIf asEventName == "footFront"
		
	EndIf
EndEvent

Event OnTranslationAlmostComplete()
	_SelfRef.PlayImpactEffect(FXDragonTailstompImpactSet,"Elk_COM",0,0,-0.5,512)
	_SelfRef.PlayImpactEffect(FXDragonTailstompImpactSet,"Elk_COM",0,0,-1,512)
	_FlightCount = 0
EndEvent

Event onUpdate()
	CheckEmergencyLanding()
	If vRDN_cfgChanged.GetValue()
		vRDN_cfgChanged.SetValue(0)
		UpdateConfig()
	EndIf
	;If !_SelfRef.IsBeingRidden() && !_Stopped
	;	DoEmergencyLanding()
	;EndIf
	RegisterForSingleUpdate(1)
EndEvent

Event onEffectFinish(Actor akTarget, Actor akCaster)
	Debug.Trace("vRDN_FlightMEScript: Flight spell shutting down...")
	;_SpawnPoint.Delete()
;	_PlatformSpawnPoint.Delete()
	CleanupPlatforms()
EndEvent

;--=== Functions ===--

Function UpdatePlatforms()
	_PaXPrev = _PaX
	_PaX = PlayerREF.GetAngleX()
	_RaXPrev = _RaX
	_RaX = _SelfRef.GetAngleX()
	;Debug.Trace("PaX is " + _PaX + ", was " + _PaXPrev)
	;Debug.Trace("RaX is " + _RaX + ", was " + _RaXPrev)
	Float Heading = PlayerREF.GetAngleZ()
	Float MultX = math.cos(Heading)
	Float MultY = -math.sin(Heading)

	Float zOffset = 0
	
	;_PaX -= 10
	If _Rising
		_PaX = _FlightMaxAngleAscent
	EndIf
	;If Math.ABS(_PaX - 15) - DeadZoneRange > 0
		;;Debug.Trace("Camera is " + (Math.ABS(_PaX - 10) - DeadZoneRange) + " degrees outside the dead zone!")
		_FlightAngleAverage = ((_FlightAngleAverage * (_FlightSmoothing - 1)) + (_PaX)) / _FlightSmoothing
	;EndIf
	Float angleOffset = _FlightAngleAverage

	If angleOffset < _FlightMaxAngleAscent
		angleOffset = _FlightMaxAngleAscent
	ElseIf angleOffset > _FlightMaxAngleDescent
		angleOffset = _FlightMaxAngleDescent
	EndIf
	
	zOffset = -20

	zOffset -= 20 * Math.Sin(Math.ABS(angleOffset))

	_FlyingPlatform[_PlatformIndex].DisableNoWait(False)
	_FlyingPlatform[_PlatformIndex].MoveTo(_SelfRef,0,0,zOffset)

	_FlyingPlatform[_PlatformIndex].SetAngle(MultX * angleOffset, MultY * angleOffset,Heading + 80)
	_FlyingPlatform[_PlatformIndex].EnableNoWait(False)
	
	If angleOffset < 0 && _FlightCount < 3 && _FlightStaticCollisionsTakeOffEnable
		_FlyingPlatform[_PlatformIndex].PlaceAtMe(vRDN_RudolphTakeOffActi).SetAngle(MultX * angleOffset, MultY * angleOffset,Heading + 80)
	EndIf
	_LastTime = _ThisTime
	_ThisTime = GetCurrentRealTime()
	;;Debug.Trace("_FlightAngleAverage: " + _FlightAngleAverage)
	;;Debug.Trace("Time since last platform: " + (_ThisTime - _LastTime) + "s")
	_CurrentPlatformIndex = _PlatformIndex
	_PlatformIndex += 1
	If _PlatformIndex == _FlyingPlatform.Length
		_PlatformIndex = 0
	EndIf
	_Stopped = False
	If _StablePlatform
		_Stopped = False
		_StablePlatform.StopTranslation()
		_StablePlatform.Delete()
		_StablePlatform = None
	EndIf

EndFunction

Function SpawnPlatforms()
	Int i = 0
	While i < _FlyingPlatform.Length
		_FlyingPlatform[i] = _SelfRef.PlaceAtMe(vRDN_RudolphFlightPathActi,abInitiallyDisabled = True)
		i += 1
	EndWhile
EndFunction

Function DisablePlatforms()
	;Debug.Trace("cleaning up platforms...")
	Int i = 0
	While i < _FlyingPlatform.Length
		_FlyingPlatform[i].DisableNoWait()
		i += 1
	EndWhile
	_FlightAngleAverage = 0
EndFunction

Function CleanupPlatforms()
	;Debug.Trace("cleaning up platforms...")
	Int i = 0
	While i < _FlyingPlatform.Length
		_FlyingPlatform[i].Delete()
		_FlyingPlatform[i] = None
		i += 1
	EndWhile
	_FlightAngleAverage = 0
EndFunction

Function CheckFlight()
	vRDN_FlightTestSpell.Cast(PlayerREF,_SelfRef)
	_FlyingPrev = _Flying
	_Flying = (vRDN_FlyingGlobal.GetValue() as Int) as Bool
	If _FlightCount > 3 && !_Flying ;&& _RaX > 40
		_Landing = True
	EndIf
	If _Flying
		_FlightCount += 1
	Else
		_FlightCount = 0
	EndIf
	;Debug.Trace("Flightcount is " + _FlightCount)
EndFunction

Function CheckEmergencyLanding()
	If GetCurrentRealTime() - _LastTime > _FlightEmergencyLandingDelay && !_Stopped && _FlightEmergencyLandingEnable && _FlightCount > 3
		If _SelfRef.GetAngleX() > 80
			DoEmergencyLanding()
		ElseIf _FlightCount > 3
			vRDN_HelpEmergencyLandingMSG.ShowAsHelpMessage("vRDN_EmergencyLanding",8,30,1)
		EndIf
	EndIf
EndFunction

Function DoEmergencyLanding()
	ObjectReference SpawnPoint = PlayerREF.PlaceAtMe(FXEmptyActivator)
	ObjectReference TargetPoint = PlayerREF.PlaceAtMe(FXEmptyActivator)
	SpawnPoint.MoveTo(_SelfRef,0,0,-10)
	TargetPoint.MoveTo(SpawnPoint,0,0,-10)
	vRDN_ELandingPlacerSpell.Cast(SpawnPoint,TargetPoint)
	Wait(0.1)
	SpawnPoint.Delete()
	TargetPoint.Delete()
	_Stopped = True
EndFunction

Function UpdateConfig()
	Debug.Trace("vRDN_FlightMEScript: UpdateConfig called on Flight script...")
	_FlightEmergencyLandingDelay         = (vRDN_cfgFlightEmergencyLandingDelay.GetValue() as Int)
	_FlightEmergencyLandingEnable        = (vRDN_cfgFlightEmergencyLandingEnable.GetValue() as Int) as Bool
	_FlightHoldJumpToClimbEnable         = (vRDN_cfgFlightHoldJumpToClimbEnable.GetValue() as Int) as Bool
	_FlightHoldJumpToFlyEnable           = (vRDN_cfgFlightHoldJumpToFlyEnable.GetValue() as Int) as Bool
	_FlightMaxAngleAscent                = (vRDN_cfgFlightMaxAngleAscent.GetValue() as Int)
	_FlightMaxAngleDescent               = (vRDN_cfgFlightMaxAngleDescent.GetValue() as Int)
	_FlightSmoothing                     = (vRDN_cfgFlightSmoothing.GetValue() as Int)
	_FlightStaticCollisionsAlwaysEnable  = (vRDN_cfgFlightStaticCollisionsAlwaysEnable.GetValue() as Int) as Bool
	_FlightStaticCollisionsTakeOffEnable = (vRDN_cfgFlightStaticCollisionsTakeOffEnable.GetValue() as Int) as Bool
	_FlightTrackingEnable                = (vRDN_cfgFlightTrackingEnable.GetValue() as Int) as Bool
	_FlightTrackingType                  = (vRDN_cfgFlightTrackingType.GetValue() as Int)
	
	;UnregisterForAllControls()
	If !_FlightHoldJumpToClimbEnable
		_Rising = False
	Else
	;	RegisterForControl("Jump")
	EndIf
	Debug.Trace("vRDN_FlightMEScript: UpdateConfig completed on Flight script!")
EndFunction