Scriptname vRDN_MCMScript extends SKI_ConfigBase

GlobalVariable Property vRDN_cfgChanged Auto

GlobalVariable Property vRDN_cfgFlightMasterEnable Auto
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
GlobalVariable Property vRDN_cfgNoseGlowEnable Auto
GlobalVariable Property vRDN_cfgTwinkleToesEnable Auto
GlobalVariable Property vRDN_cfgVanishTime Auto

GlobalVariable Property vRDN_cfgSpeedMult Auto

GlobalVariable Property vRDN_cfgOrphanedObjectScanEnable Auto

Bool _Changed 

Bool _FlightMasterEnable 
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
Bool _NoseGlowEnable 
Bool _TwinkleToesEnable 
Int  _SpeedMult
Bool _OrphanedObjectScanEnable
Float _VanishTime

Quest Property vRDN_MetaQuest Auto

Event OnConfigInit()
	ModName = "$vRDNModName"
EndEvent

event OnGameReload()
    parent.OnGameReload()
	ApplySettings()
endEvent

event OnPageReset(string a_page)
	UpdateSettings()
	Int FlightOptionFlags = 0
	SetCursorFillMode(TOP_TO_BOTTOM)
	AddHeaderOption("$vRDNMCMSEHeader")
	AddToggleOptionST("NOSEGLOW_TOGGLE","$vRDNMCMSENoseGlow",_NoseGlowEnable)
	AddToggleOptionST("TWINKLETOES_TOGGLE","$vRDNMCMSEHoofprints",_TwinkleToesEnable)
	AddSliderOptionST("VANISHTIME_SLIDER","$vRDNMCMVanishAfter",_VanishTime,"$vRDNMCMUnitHours")
	AddEmptyOption()
	AddHeaderOption("$vRDNMCMPHeader")
	AddSliderOptionST("SPEEDMULT_SLIDER","$vRDNMCMPSpeed",_SpeedMult,"{0}%")
	AddEmptyOption()
	AddHeaderOption("$vRDNMCMAHeader")
	AddToggleOptionST("ORPHANEDOBJECTSCANENABLE_TOGGLE","$vRDNMCMAScan",_OrphanedObjectScanEnable)
	SetCursorPosition(1)
	AddHeaderOption("$vRDNMCMFOHeader")
	AddToggleOptionST("FLIGHTMASTER_TOGGLE","$vRDNMCMFOEnableFlight",_FlightMasterEnable)
	If !_FlightMasterEnable
		FlightOptionFlags = OPTION_FLAG_DISABLED
	EndIf
	AddEmptyOption()
	AddToggleOptionST("FLIGHTEMERGENCYLANDING_TOGGLE","$vRDNMCMFOEnableEL",_FlightEmergencyLandingEnable,FlightOptionFlags)
	AddSliderOptionST("FLIGHTEMERGENCYLANDINGDELAY_SLIDER","$vRDNMCMFOELD",_FlightEmergencyLandingDelay,"$vRDNMCMUnitSec",(Math.LogicalOR(FlightOptionFlags,(!_FlightEmergencyLandingEnable) as Int * OPTION_FLAG_DISABLED)))
	AddEmptyOption()
	AddToggleOptionST("FLIGHTHOLDJUMPTOCLIMBENABLE_TOGGLE","$vRDNMCMFOJumpToAscend",_FlightHoldJumpToClimbEnable,FlightOptionFlags)
	;AddToggleOptionST("FLIGHTHOLDJUMPTOFLYENABLE_TOGGLE","$vRDNMCMFOJumpToFly",_FlightHoldJumpToFlyEnable,"",FlightOptionFlags)
	AddSliderOptionST("FLIGHTSMOOTHING_SLIDER","$vRDNMCMFOSmoothing",_FlightSmoothing,"{0}",FlightOptionFlags)	
	AddSliderOptionST("FLIGHTMAXANGLEASCENT_SLIDER","$vRDNMCMFOMaxAscsent",_FlightMaxAngleAscent,"$vRDNMCMUnitDeg",FlightOptionFlags)	
	AddSliderOptionST("FLIGHTMAXANGLEDESCENT_SLIDER","$vRDNMCMFOMaxDescent",_FlightMaxAngleDescent,"$vRDNMCMUnitDeg",FlightOptionFlags)	
	AddToggleOptionST("FLIGHTSTATICCOLLISIONSTAKEOFFENABLE_TOGGLE","$vRDNMCMFOUseStaticTO",_FlightStaticCollisionsTakeOffEnable,FlightOptionFlags)
	;AddToggleOptionST("FLIGHTSTATICCOLLISIONSALWAYSENABLE_TOGGLE","$vRDNMCMFOUseStaticAlways",_FlightStaticCollisionsAlwaysEnable,(Math.LogicalOR(FlightOptionFlags,(!_FlightStaticCollisionsTakeOffEnable) as Int * OPTION_FLAG_DISABLED)))
EndEvent

event OnConfigClose()
	(vRDN_MetaQuest as vRDN_MetaQuestScript).UpdateConfig()
endEvent

Function UpdateSettings()

	_FlightMasterEnable                  = (vRDN_cfgFlightMasterEnable.GetValue() as Int) as Bool
	_FlightEmergencyLandingDelay         = (vRDN_cfgFlightEmergencyLandingDelay.GetValue() as Int)
	_FlightEmergencyLandingEnable        = (vRDN_cfgFlightEmergencyLandingEnable.GetValue() as Int) as Bool
	_FlightHoldJumpToClimbEnable         = (vRDN_cfgFlightHoldJumpToClimbEnable.GetValue() as Int) as Bool
	_FlightHoldJumpToFlyEnable           = (vRDN_cfgFlightHoldJumpToFlyEnable.GetValue() as Int) as Bool

	_FlightMaxAngleAscent                = -(vRDN_cfgFlightMaxAngleAscent.GetValue() as Int) ; Flip the sign to make this more intuitive for the user
	_FlightMaxAngleDescent               = (vRDN_cfgFlightMaxAngleDescent.GetValue() as Int)
	_FlightSmoothing                     = (vRDN_cfgFlightSmoothing.GetValue() as Int)
	_FlightStaticCollisionsAlwaysEnable  = (vRDN_cfgFlightStaticCollisionsAlwaysEnable.GetValue() as Int) as Bool
	_FlightStaticCollisionsTakeOffEnable = (vRDN_cfgFlightStaticCollisionsTakeOffEnable.GetValue() as Int) as Bool
	_FlightTrackingEnable                = (vRDN_cfgFlightTrackingEnable.GetValue() as Int) as Bool
	_FlightTrackingType                  = (vRDN_cfgFlightTrackingType.GetValue() as Int)

	_NoseGlowEnable                      = (vRDN_cfgNoseGlowEnable.GetValue() as Int) as Bool
	_TwinkleToesEnable                   = (vRDN_cfgTwinkleToesEnable.GetValue() as Int) as Bool
	_VanishTime							 = vRDN_cfgVanishTime.GetValue()
	_SpeedMult                           = (vRDN_cfgSpeedMult.GetValue() as Int)
	_OrphanedObjectScanEnable			 = (vRDN_cfgOrphanedObjectScanEnable.GetValue() as Int) as Bool
EndFunction

function ApplySettings()

EndFunction

state ORPHANEDOBJECTSCANENABLE_TOGGLE

	event OnSelectST()
		_OrphanedObjectScanEnable = !_OrphanedObjectScanEnable
		vRDN_cfgOrphanedObjectScanEnable.SetValue(_OrphanedObjectScanEnable as Int)
		SetToggleOptionValueST(_OrphanedObjectScanEnable)
	endEvent

	event OnDefaultST()
		_OrphanedObjectScanEnable = True
		vRDN_cfgOrphanedObjectScanEnable.SetValue(_OrphanedObjectScanEnable as Int)
		SetToggleOptionValueST(_OrphanedObjectScanEnable)
	endEvent

	event OnHighlightST()
		SetInfoText("$vRDNMCMHelpScan")
	endEvent

endState


state NOSEGLOW_TOGGLE

	event OnSelectST()
		_NoseGlowEnable = !_NoseGlowEnable
		vRDN_cfgNoseGlowEnable.SetValue(_NoseGlowEnable as Int)
		SetToggleOptionValueST(_NoseGlowEnable)
	endEvent

	event OnDefaultST()
		_NoseGlowEnable	= True
		vRDN_cfgNoseGlowEnable.SetValue(_NoseGlowEnable as Int)
		SetToggleOptionValueST(_NoseGlowEnable)
	endEvent

	event OnHighlightST()
		SetInfoText("$vRDNMCMHelpRedNose")
	endEvent

endState

state TWINKLETOES_TOGGLE

	event OnSelectST()
		_TwinkleToesEnable = !_TwinkleToesEnable
		vRDN_cfgTwinkleToesEnable.SetValue(_TwinkleToesEnable as Int)
		SetToggleOptionValueST(_TwinkleToesEnable)
	endEvent

	event OnDefaultST()
		_TwinkleToesEnable	= True
		vRDN_cfgTwinkleToesEnable.SetValue(_TwinkleToesEnable as Int)
		SetToggleOptionValueST(_TwinkleToesEnable)
	endEvent

	event OnHighlightST()
		SetInfoText("$vRDNMCMHelpHoofprints")
	endEvent

endState

state VANISHTIME_SLIDER

	event OnSliderOpenST()
		SetSliderDialogStartValue(_VanishTime)
		SetSliderDialogDefaultValue(1.0)
		SetSliderDialogRange(0.0, 24.0)
		SetSliderDialogInterval(0.5)
	endEvent

	event OnSliderAcceptST(float a_value)
		_VanishTime = a_value
		SetSliderOptionValueST(_VanishTime,"$vRDNMCMUnitHours")
		vRDN_cfgVanishTime.SetValue(_VanishTime)
	endEvent

	event OnDefaultST()
		_VanishTime = 1.0
		SetSliderOptionValueST(_VanishTime,"$vRDNMCMUnitHours")
		vRDN_cfgVanishTime.SetValue(_VanishTime)
	endEvent

	event OnHighlightST()
		SetInfoText("$vRDNMCMHelpVanishAfter")
	endEvent

endState

state SPEEDMULT_SLIDER

	event OnSliderOpenST()
		SetSliderDialogStartValue(_SpeedMult)
		SetSliderDialogDefaultValue(100)
		SetSliderDialogRange(60, 120)
		SetSliderDialogInterval(5)
	endEvent

	event OnSliderAcceptST(float a_value)
		_SpeedMult = a_value as Int
		SetSliderOptionValueST(_SpeedMult,"{0}%")
		vRDN_cfgSpeedMult.SetValue(_SpeedMult)
	endEvent

	event OnDefaultST()
		_FlightSmoothing = 100
		SetSliderOptionValueST(_SpeedMult,"{0}%")
		vRDN_cfgSpeedMult.SetValue(_SpeedMult)
	endEvent

	event OnHighlightST()
		SetInfoText("$vRDNMCMHelpSpeed")
	endEvent

endState


state FLIGHTMASTER_TOGGLE

	event OnSelectST()
		_FlightMasterEnable = !_FlightMasterEnable
		vRDN_cfgFlightMasterEnable.SetValue(_FlightMasterEnable as Int)
		;SetToggleOptionValueST(_FlightMasterEnable)
		ForcePageReset()
	endEvent

	event OnDefaultST()
		_FlightMasterEnable	= True
		vRDN_cfgFlightMasterEnable.SetValue(_FlightMasterEnable as Int)
		SetToggleOptionValueST(_FlightMasterEnable)
	endEvent

	event OnHighlightST()
		SetInfoText("$vRDNMCMHelpFlightEnable")
	endEvent

endState

state FLIGHTEMERGENCYLANDING_TOGGLE

	event OnSelectST()
		_FlightEmergencyLandingEnable = !_FlightEmergencyLandingEnable
		vRDN_cfgFlightMasterEnable.SetValue(_FlightEmergencyLandingEnable as Int)
		SetOptionFlagsST((!_FlightEmergencyLandingEnable) as Int * OPTION_FLAG_DISABLED, True, "FLIGHTEMERGENCYLANDINGDELAY_SLIDER")
		SetToggleOptionValueST(_FlightEmergencyLandingEnable)
	endEvent

	event OnDefaultST()
		_FlightEmergencyLandingEnable	= True
		vRDN_cfgFlightMasterEnable.SetValue(_FlightEmergencyLandingEnable as Int)
		SetOptionFlagsST((!_FlightEmergencyLandingEnable) as Int * OPTION_FLAG_DISABLED, True, "FLIGHTEMERGENCYLANDINGDELAY_SLIDER")
		SetToggleOptionValueST(_FlightEmergencyLandingEnable)
	endEvent

	event OnHighlightST()
		SetInfoText("$vRDNMCMHelpELEnable")
	endEvent

endState

state FLIGHTHOLDJUMPTOCLIMBENABLE_TOGGLE

	event OnSelectST()
		_FlightHoldJumpToClimbEnable = !_FlightHoldJumpToClimbEnable
		vRDN_cfgFlightHoldJumpToClimbEnable.SetValue(_FlightHoldJumpToClimbEnable as Int)
		SetToggleOptionValueST(_FlightHoldJumpToClimbEnable)
	endEvent

	event OnDefaultST()
		_FlightHoldJumpToClimbEnable = True
		vRDN_cfgFlightHoldJumpToClimbEnable.SetValue(_FlightHoldJumpToClimbEnable as Int)
		SetToggleOptionValueST(_FlightHoldJumpToClimbEnable)
	endEvent

	event OnHighlightST()
		SetInfoText("$vRDNMCMHelpJumpEnable")
	endEvent

endState

state FLIGHTSTATICCOLLISIONSTAKEOFFENABLE_TOGGLE

	event OnSelectST()
		_FlightStaticCollisionsTakeOffEnable = !_FlightStaticCollisionsTakeOffEnable
		vRDN_cfgFlightStaticCollisionsTakeOffEnable.SetValue(_FlightStaticCollisionsTakeOffEnable as Int)
		SetToggleOptionValueST(_FlightStaticCollisionsTakeOffEnable)
	endEvent

	event OnDefaultST()
		_FlightStaticCollisionsTakeOffEnable = True
		vRDN_cfgFlightStaticCollisionsTakeOffEnable.SetValue(_FlightStaticCollisionsTakeOffEnable as Int)
		SetToggleOptionValueST(_FlightStaticCollisionsTakeOffEnable)
	endEvent

	event OnHighlightST()
		SetInfoText("$vRDNMCMHelpStaticTakeoffEnable")
	endEvent

endState

state FLIGHTSTATICCOLLISIONSALWAYSENABLE_TOGGLE

	event OnSelectST()
		_FlightStaticCollisionsAlwaysEnable = !_FlightStaticCollisionsAlwaysEnable
		vRDN_cfgFlightStaticCollisionsAlwaysEnable.SetValue(_FlightStaticCollisionsAlwaysEnable as Int)
		SetToggleOptionValueST(_FlightStaticCollisionsAlwaysEnable)
	endEvent

	event OnDefaultST()
		_FlightStaticCollisionsAlwaysEnable = False
		vRDN_cfgFlightStaticCollisionsAlwaysEnable.SetValue(_FlightStaticCollisionsAlwaysEnable as Int)
		SetToggleOptionValueST(_FlightStaticCollisionsAlwaysEnable)
	endEvent

	event OnHighlightST()
		SetInfoText("$vRDNMCMHelpStaticAlwaysEnable")
	endEvent

endState

state FLIGHTMAXANGLEASCENT_SLIDER

	event OnSliderOpenST()
		SetSliderDialogStartValue(_FlightMaxAngleAscent)
		SetSliderDialogDefaultValue(2)
		SetSliderDialogRange(10, 35)
		SetSliderDialogInterval(1)
	endEvent

	event OnSliderAcceptST(float a_value)
		_FlightMaxAngleAscent = a_value as Int
		SetSliderOptionValueST(_FlightMaxAngleAscent,"$vRDNMCMUnitDeg")
		vRDN_cfgFlightMaxAngleAscent.SetValue(-_FlightMaxAngleAscent) ; remember to flip the sign
	endEvent

	event OnDefaultST()
		_FlightMaxAngleAscent = 35
		SetSliderOptionValueST(_FlightMaxAngleAscent,"$vRDNMCMUnitDeg")
		vRDN_cfgFlightMaxAngleAscent.SetValue(-_FlightMaxAngleAscent)
	endEvent

	event OnHighlightST()
		SetInfoText("$vRDNMCMHelpMaxAscent")
	endEvent

endState

state FLIGHTMAXANGLEDESCENT_SLIDER

	event OnSliderOpenST()
		SetSliderDialogStartValue(_FlightMaxAngleDescent)
		SetSliderDialogDefaultValue(40)
		SetSliderDialogRange(10, 40)
		SetSliderDialogInterval(1)
	endEvent

	event OnSliderAcceptST(float a_value)
		_FlightMaxAngleDescent = a_value as Int
		SetSliderOptionValueST(_FlightMaxAngleDescent,"$vRDNMCMUnitDeg")
		vRDN_cfgFlightMaxAngleDescent.SetValue(_FlightMaxAngleDescent)
	endEvent

	event OnDefaultST()
		_FlightSmoothing = 40
		SetSliderOptionValueST(_FlightMaxAngleDescent,"$vRDNMCMUnitDeg")
		vRDN_cfgFlightMaxAngleDescent.SetValue(_FlightMaxAngleDescent)
	endEvent

	event OnHighlightST()
		SetInfoText("$vRDNMCMHelpMaxDescent")
	endEvent

endState

state FLIGHTSMOOTHING_SLIDER

	event OnSliderOpenST()
		SetSliderDialogStartValue(_FlightSmoothing)
		SetSliderDialogDefaultValue(2)
		SetSliderDialogRange(1, 8)
		SetSliderDialogInterval(1)
	endEvent

	event OnSliderAcceptST(float a_value)
		_FlightSmoothing = a_value as Int
		SetSliderOptionValueST(_FlightSmoothing)
		vRDN_cfgFlightSmoothing.SetValue(_FlightSmoothing)
	endEvent

	event OnDefaultST()
		_FlightSmoothing = 2
		SetSliderOptionValueST(_FlightSmoothing)
		vRDN_cfgFlightSmoothing.SetValue(_FlightSmoothing)
	endEvent

	event OnHighlightST()
		SetInfoText("$vRDNMCMHelpFlightSmoothing")
	endEvent

endState

state FLIGHTEMERGENCYLANDINGDELAY_SLIDER

	event OnSliderOpenST()
		SetSliderDialogStartValue(_FlightEmergencyLandingDelay)
		SetSliderDialogDefaultValue(5)
		SetSliderDialogRange(1, 10)
		SetSliderDialogInterval(1)
	endEvent

	event OnSliderAcceptST(float a_value)
		_FlightEmergencyLandingDelay = a_value as Int
		SetSliderOptionValueST(_FlightEmergencyLandingDelay,"{0} $vRDNMCMUnitSec")
		vRDN_cfgFlightEmergencyLandingDelay.SetValue(_FlightEmergencyLandingDelay)
	endEvent

	event OnDefaultST()
		_FlightEmergencyLandingDelay = 2
		SetSliderOptionValueST(_FlightEmergencyLandingDelay,"{0} $vRDNMCMUnitSec")
		vRDN_cfgFlightEmergencyLandingDelay.SetValue(_FlightEmergencyLandingDelay)
	endEvent

	event OnHighlightST()
		SetInfoText("vRDNMCMHelpELWait")
	endEvent

endState
