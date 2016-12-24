Scriptname vRDN_MetaQuestScript extends Quest  
{Do initialization and track variables for scripts}

;--=== Imports ===--

Import Utility
Import Game

;--=== Properties ===--

Actor Property PlayerRef Auto
Actor Property Rudolph Auto

ReferenceAlias Property alias_Rudolph Auto

Float Property ModVersion Auto

;FormList Property vRDN_PossibleOrphans Auto

GlobalVariable Property vRDN_cfgChanged Auto
;GlobalVariable Property vRDN_cfgOrphanedObjectScanEnable Auto

Message Property vRDN_ModLoadedMSG Auto
Message Property vRDN_ModUpdatedMSG Auto
;Message Property vRDN_OrphanedObjectMSGB Auto

;Quest Property vRDN_CleanupOrphansQuest Auto

;--=== Variables ===--

Float _CurrentVersion
String _sCurrentVersion

Bool _Running
Bool _DawnguardInstalled
Bool _ChaurusLightsInstalled

Float _ScriptLatency
Float _StartTime
Float _EndTime

;--=== Events ===--

Event OnInit()
	If ModVersion == 0
		DoUpkeep(True)
	EndIf
EndEvent

Event OnReset()
	Debug.Trace("vRDN: Main quest event: OnReset")
EndEvent

;--=== Functions ===--

Function DoUpkeep(Bool DelayedStart = True)
	;FIXME: CHANGE THIS WHEN UPDATING!
	_CurrentVersion = 1.10
	Int Major = Math.Floor(_CurrentVersion) as Int
	Int Minor = ((_CurrentVersion - Major) * 100) as Int
	If Minor < 10
		_sCurrentVersion = Major + ".0" + Minor
	Else
		_sCurrentVersion = Major + "." + Minor
	EndIf
	If DelayedStart
		Wait(RandomFloat(2,4))
	EndIf
	Debug.Trace("vRDN: Performing upkeep...")
	Debug.Trace("vRDN: Loaded version is " + ModVersion + ", Current version is " + _CurrentVersion + " (v" + _sCurrentVersion + ")")
	If ModVersion == 0
		Debug.Trace("vRDN: First load, do initialization!")
		ModVersion = _CurrentVersion
		DoInit()
	ElseIf ModVersion < _CurrentVersion
		DoUpgrade()
		ModVersion = _CurrentVersion
		Debug.Trace("vRDN: Upgraded to " + _CurrentVersion)
		vRDN_ModUpdatedMSG.Show(_CurrentVersion)
	Else
		Debug.Trace("vRDN: Loaded, no updates.")
		;CheckForOrphans()
	EndIf
	CheckForExtras()
	UpdateConfig()
	Debug.Trace("vRDN: Upkeep complete!")
EndFunction

Function DoInit()
	Debug.Trace("vRDN: Initializing...")
	_Running = True
	vRDN_ModLoadedMSG.Show(_CurrentVersion)
EndFunction

Function DoUpgrade()
	_Running = False
	alias_Rudolph.ForceRefIfEmpty(Rudolph)
	
	_Running = True
	Debug.Trace("vRDN: Upgrade complete!")
EndFunction

Function UpdateConfig()
	Debug.Trace("vRDN: Updating configuration...")
	alias_Rudolph.ForceRefIfEmpty(Rudolph)
	(alias_Rudolph.GetReference() as vRDN_RudolphActorScript).UpdateConfig()
	vRDN_cfgChanged.SetValue(1)
	;Debug.Trace("vRDN: Waiting for all scripts to receive new settings...")
	;Int i = 0
	;While vRDN_cfgChanged.GetValue() > 0 && i < 5
	;	Wait(1)
	;	i += 1
	;EndWhile
	Debug.Trace("vRDN: Updated configuration values, some scripts may update in the background!")
	;If vRDN_cfgOrphanedObjectScanEnable.GetValue()
		;CheckForOrphans(True)
		;vRDN_cfgOrphanedObjectScanEnable.SetValue(0)
	;EndIf
EndFunction


Function CheckForExtras()
EndFunction