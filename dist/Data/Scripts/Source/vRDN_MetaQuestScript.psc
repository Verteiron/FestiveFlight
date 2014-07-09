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

FormList Property vRDN_PossibleOrphans Auto

GlobalVariable Property vRDN_cfgChanged Auto
GlobalVariable Property vRDN_cfgOrphanedObjectScanEnable Auto

Message Property vRDN_ModLoadedMSG Auto
Message Property vRDN_ModUpdatedMSG Auto
Message Property vRDN_OrphanedObjectMSGB Auto

Quest Property vRDN_CleanupOrphansQuest Auto

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
	_CurrentVersion = 1.07
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
	If ModVersion < 1.04
		Debug.Trace("vRDN: Upgrading to 1.04...")
		Debug.Trace("vRDN:  Resetting version to 1.0 to make sure previous upgrades were applied...")
		ModVersion = 1.0
		Debug.Trace("vRDN:  Rerunning 1.00 -> 1.04 upgrades...")
		ModVersion = 1.0
	EndIf
	If ModVersion < 1.02
		Debug.Trace("vRDN: Upgrading to 1.02...")
		Spell vRDN_TwinkleToesSpell = GetFormFromFile(0x00001831,"vRDN_Rudolph.esp") as Spell
		If (alias_Rudolph.GetReference() as Actor).HasSpell(vRDN_TwinkleToesSpell)
			Debug.Trace("vRDN:   Restarting vRDN_TwinkleToes Spell...")
			(alias_Rudolph.GetReference() as Actor).RemoveSpell(vRDN_TwinkleToesSpell)
			Wait(0.1)
			(alias_Rudolph.GetReference() as Actor).AddSpell(vRDN_TwinkleToesSpell)
		EndIf
		Debug.Trace("vRDN: Upgrade to 1.02 complete!")
	EndIf
	If ModVersion < 1.03
		Debug.Trace("vRDN: Upgrading to 1.03...")
		Debug.Trace("vRDN:  Attempting to calm down Rudolph...")
		(alias_Rudolph.GetReference() as Actor).StopCombat()
		(alias_Rudolph.GetReference() as Actor).StopCombatAlarm()
		(alias_Rudolph.GetReference() as Actor).SetAV("Aggression",0)
		(alias_Rudolph.GetReference() as Actor).SetAV("Assistance",0)
		(alias_Rudolph.GetReference() as Actor).EvaluatePackage()
		Debug.Trace("vRDN: Upgrade to 1.03 complete!")
	EndIf
	If ModVersion < 1.04
		;Debug.Trace("vRDN: Upgrading to 1.04...")
		ModVersion = 1.03
		Debug.Trace("vRDN:  Upgrade script bug should be fixed now!")
		Debug.Trace("vRDN: Upgrade to 1.04 complete!")
	EndIf
	If ModVersion < 1.05
		Debug.Trace("vRDN: Upgrading to 1.05...")
		vRDN_OrphanedObjectMSGB.Show()
		CheckForOrphans()
		vRDN_cfgOrphanedObjectScanEnable.SetValue(1)
		Debug.Trace("vRDN: Upgrade to 1.05 complete!")
	EndIf
	If ModVersion < 1.06
		Debug.Trace("vRDN: Upgrading to 1.06...")
		
		Debug.Trace("vRDN: Upgrade to 1.06 complete!")
	EndIf
	If ModVersion < 1.07
		Debug.Trace("vRDN: Upgrading to 1.07...")
		
		Debug.Trace("vRDN: Upgrade to 1.07 complete!")
	EndIf
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

Function CheckForOrphans(Bool Verbose = False)
	Int OrphanCount
	Debug.Trace("vRDN:  Checking for orphaned objects...")
	If Verbose
		Debug.Notification("Scanning for orphaned objects...")
	EndIf
	vRDN_CleanupOrphansQuest.Start()
	Wait(1)
	While (vRDN_CleanUpOrphansQuest as vRDN_CleanUpOrphansQuestScript).alias_Orphan.GetReference()
		ObjectReference Orphan = (vRDN_CleanUpOrphansQuest as vRDN_CleanUpOrphansQuestScript).alias_Orphan.GetReference()
		Debug.Trace("vRDN:   Found possible orphaned object " + Orphan + "!")
		Debug.Trace("vRDN:    Base object: " + Orphan.GetBaseObject())	
		Debug.Trace("vRDN:    World space: " + Orphan.GetWorldSpace())
		Debug.Trace("vRDN:    Parent Cell: " + Orphan.GetParentCell())
		Debug.Trace("vRDN:    In Interior: " + Orphan.IsInInterior())
		Debug.Trace("vRDN:    Coordinates: " + Orphan.GetPositionX() + ", " + Orphan.GetPositionY() + ", " + Orphan.GetPositionZ())
		Bool IsTemp
		If Orphan.GetFormID() > 0xff000000
			IsTemp = True 
		EndIf
		Debug.Trace("vRDN:    IsTemporary: " + IsTemp)
		Debug.Trace("vRDN:   Likely orphan, deleting it!")
		Orphan.Delete()
		OrphanCount += 1
		Debug.Trace("vRDN:   --")
		Orphan = None
		vRDN_CleanupOrphansQuest.Stop()
		vRDN_CleanupOrphansQuest.Start()
		Wait(1.0)
	EndWhile
	vRDN_CleanupOrphansQuest.Stop()
	Debug.Trace("vRDN: Orphan checking completed! Removed " + OrphanCount + " objects.")
	If Verbose
		Debug.Notification("Removed " + OrphanCount + " orphaned objects. Scan stopped.")
	EndIf
EndFunction

Function CheckForExtras()
EndFunction