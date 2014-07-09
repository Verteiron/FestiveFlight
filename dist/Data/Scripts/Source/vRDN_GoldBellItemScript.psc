Scriptname vRDN_GoldBellItemScript extends ObjectReference  
{Play sound, cast Happy Thoughts, add the spell if the player doesn't have it}

;--=== Imports ===--

Import Utility
Import Game

;--=== Properties ===--

Actor Property PlayerRef Auto

ActorBase Property vRDN_Camera Auto

Activator Property FXEmptyActivator Auto

Light Property FaceLight Auto

Spell Property vRDN_HappyThoughtsSpell Auto
Spell Property vRDN_RudolphSummonSpell Auto

Idle Property IdleStop_loose Auto
Idle Property IdleLaugh Auto
Idle Property IdleNoteRead Auto
Idle Property IdleStudy Auto
Idle Property IdleStudy_Exit Auto

Message Property vRDN_PutAwayWeaponsMSG Auto
Message Property vRDN_EndCombatMSG Auto

Sound Property vRDN_GoldBellSM Auto

;--=== Variables ===--

;--=== Events ===--

Event OnEquipped(Actor akActor)
	vRDN_GoldBellSM.Play(PlayerREF)
	If akActor == PlayerREF
		If !PlayerREF.HasSpell(vRDN_HappyThoughtsSpell)
			If PlayerREF.IsWeaponDrawn()
				;Debug.Notification("Put your weapons away. Happy thoughts don't include violence.")
				vRDN_PutAwayWeaponsMSG.Show()
				Return
			EndIf
			If PlayerREF.IsInCombat()
				;Debug.Notification("Now might not be the best time... finish fighting first!")
				vRDN_EndCombatMSG.Show()
				Return
			EndIf
			Armor Helmet = PlayerREF.GetWornForm(0x00000001) as Armor
			PlayerREF.UnEquipItemSlot(30)
			;PlayerREF.UnEquipItemSlot(31)
			;PlayerREF.UnEquipItemSlot(30)
			ObjectReference CamPoint1 = PlayerREF.PlaceAtMe(FXEmptyActivator)
			ObjectReference CamPoint2 = PlayerREF.PlaceAtMe(FXEmptyActivator)
			ObjectReference CamPoint3 = PlayerREF.PlaceAtMe(FXEmptyActivator)
			ForceFirstPerson()
			;WaitMenuMode(0.25) ; Reduce camera distance 
			ForceThirdPerson() ; force 3rd-person player geometry to load		
			Float Heading = PlayerREF.GetAngleZ() - 90
		
			Float MultX = math.cos(Heading + 30)
			Float MultY = -math.sin(Heading + 30)
			CamPoint1.MoveTo(PlayerREF,MultX * 45,MultY * 45,PlayerREF.GetHeight() - 20)
			CamPoint1.SetAngle(15,0,CamPoint1.GetAngleZ() + CamPoint1.GetHeadingAngle(PlayerREF))

			MultX = math.cos(Heading + 330)
			MultY = -math.sin(Heading + 330)
			CamPoint2.MoveTo(PlayerREF,MultX * 60,MultY * 60,PlayerREF.GetHeight())
			CamPoint2.SetAngle(-1,0,CamPoint2.GetAngleZ() + CamPoint2.GetHeadingAngle(PlayerREF))
			
			ObjectReference FaceLightObj = CamPoint2.PlaceAtMe(FaceLight,abInitiallyDisabled = True)
			FaceLightObj.MoveTo(PlayerREF,MultX * 250,MultY * 250,PlayerREF.GetHeight())
			
			MultX = math.cos(Heading + 150)
			MultY = -math.sin(Heading + 150)
			CamPoint3.MoveTo(PlayerREF,MultX * 120,MultY * 120,PlayerREF.GetHeight() + 20)
			CamPoint3.SetAngle(0,0,CamPoint3.GetAngleZ() + CamPoint3.GetHeadingAngle(PlayerREF))
			;WaitMenuMode(0.2)

			Actor Camera = CamPoint2.PlaceActorAtMe(vRDN_Camera)
			Camera.SetAlpha(0)
			Camera.EnableAI(False)
			Camera.SetScale(0.01)
			Camera.EnableNoWait()
			Camera.MoveTo(CamPoint2)
			ForceFirstPerson()
			
			;DisablePlayerControls(abMovement = true, abFighting = true, abCamSwitch = true, abLooking = true, abSneaking = true, abMenu = true, abActivate = true, abJournalTabs = false)
			ForceThirdPerson() ; force 3rd-person player geometry to load
			;SetHUDCartMode()
			SetInChargen(True, True, False)
			SetCameraTarget(Camera)
			;Wait(0.01)
			ForceFirstPerson()
			DisablePlayerControls(abMovement = false, abFighting = true, abCamSwitch = true, abLooking = true, abSneaking = true, abMenu = true, abActivate = true, abJournalTabs = false)
			SetHUDCartMode()
			;Wait(0.01)
			FaceLightObj.EnableNoWait()
			Camera.MoveTo(CamPoint2)
			
			While !Camera.Is3DLoaded() || !FaceLightObj.Is3DLoaded()
				Wait(0.01)
			EndWhile
			Camera.TranslateToRef(CamPoint1,10,15)
			FaceLightObj.TranslateToRef(CamPoint1,40)
			
			;DisablePlayerControls(abMovement = False, abFighting = False, abCamSwitch = False, abSneaking = False, abMenu = True, abActivate = False, abJournalTabs = False)
			PlayerREF.SetExpressionOverride(13,100)
			PlayerREF.PlayIdle(IdleStudy)
			Wait(1.8)
			PlayerREF.SetExpressionOverride(10,25)
			Wait(0.25)
			PlayerREF.SetExpressionOverride(10,50)
			Wait(0.7)
			PlayerREF.SetExpressionOverride(10,75)
			Wait(1.3)
			PlayerREF.SetExpressionOverride(10,100)
			PlayerREF.PlayIdle(IdleStudy_Exit)
			Wait(1.0)
			PlayerREF.PlayIdle(IdleLaugh)
			Wait(0.65)
			vRDN_HappyThoughtsSpell.Cast(PlayerREF) ;won't summon because player doesn't have Happy Thoughts on his list yet
			;Camera.SplineTranslateToRef(CamPoint3,520,250,0)
			;Wait(1)
			EnablePlayerControls()
			SetHUDCartMode(False)
			SetInChargen(False, False, False)
			SetCameraTarget(PlayerREF)
			CamPoint1.Delete()
			CamPoint2.Delete()
			CamPoint3.Delete()
			FaceLightObj.Delete()
			Camera.Delete()
			If Helmet
				PlayerREF.EquipItemEX(Helmet,0,False,False)
			EndIf
			Wait(1)
			vRDN_RudolphSummonSpell.Cast(PlayerREF)
			Wait(2)
			PlayerREF.AddSpell(vRDN_HappyThoughtsSpell)
			Wait(2)
			PlayerREF.ClearExpressionOverride()
		EndIf
	EndIf

EndEvent
