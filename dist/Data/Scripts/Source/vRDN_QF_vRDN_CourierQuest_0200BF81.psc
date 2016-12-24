;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 4
Scriptname vRDN_QF_vRDN_CourierQuest_0200BF81 Extends Quest Hidden

;BEGIN ALIAS PROPERTY BellNote
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_BellNote Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY GoldBell
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_GoldBell Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
;(vRDN_CourierQuest as WICourierScript).AddItemToContainer(alias_GoldBell.GetRef())
(vRDN_CourierQuest as WICourierScript).AddItemToContainer(alias_BellNote.GetRef())
SetStage(10)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_3
Function Fragment_3()
;BEGIN CODE
vRDN_CourierItemsMSG.Show()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Quest Property vRDN_CourierQuest  Auto  

Message Property vRDN_CourierItemsMSG  Auto  
