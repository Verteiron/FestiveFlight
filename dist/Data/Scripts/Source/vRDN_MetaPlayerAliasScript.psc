Scriptname vRDN_MetaPlayerAliasScript extends ReferenceAlias  

;--=== Imports ===--

Import Utility
Import Game

;--=== Properties ===--

Quest Property vRDN_MetaQuest Auto

;--=== Variables ===--

;--=== Events ===--

Event OnPlayerLoadGame()
	;Debug.Trace("CHPH: OnPlayerLoadGame!")
	(vRDN_MetaQuest as vRDN_MetaQuestScript).DoUpkeep()
EndEvent

Event OnLocationChange(Location akOldLoc, Location akNewLoc)
	If (vRDN_MetaQuest as vRDN_MetaQuestScript).vRDN_cfgOrphanedObjectScanEnable.GetValue()
		GotoState("Scanning")
	EndIf
EndEvent

Event OnUpdate()
	;Do nothing
EndEvent

State Scanning

	Event OnBeginState()
		RegisterForSingleUpdate(5.0)
	EndEvent

	Event OnLocationChange(Location akOldLoc, Location akNewLoc)
		If !(vRDN_MetaQuest as vRDN_MetaQuestScript).vRDN_cfgOrphanedObjectScanEnable.GetValue()
			GotoState("")
		EndIf
	EndEvent

	Event OnUpdate()
		If !(vRDN_MetaQuest as vRDN_MetaQuestScript).vRDN_cfgOrphanedObjectScanEnable.GetValue()
			GotoState("")
			Return
		EndIf
		(vRDN_MetaQuest as vRDN_MetaQuestScript).CheckForOrphans(False)
		RegisterForSingleUpdate(30.0)
	EndEvent
EndState
;--=== Functions ===--
