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

Event OnUpdate()
	;Do nothing
EndEvent

