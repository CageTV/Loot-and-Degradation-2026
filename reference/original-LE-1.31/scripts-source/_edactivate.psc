;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 24
Scriptname _EDActivate Extends Perk Hidden

;BEGIN FRAGMENT Fragment_8
Function Fragment_8(ObjectReference akTargetRef, Actor akActor)
;BEGIN CODE
ActorBase TargetBase = (akTargetRef as Actor).GetActorBase()
_EDQuest.LastVendor = TargetBase
_EDQuest.IsFletcher = False
If TargetBase.GetClass() == _EDQuest.VendorFletcher
_EDQuest.IsFletcher = True
EndIf
_EDQuest.AddToArray(TargetBase)
_EDQuest._EDNotEnoughGold.SetValue(0)
_EDQuest.CalcTemperCosts(TargetBase)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_5
Function Fragment_5(ObjectReference akTargetRef, Actor akActor)
;BEGIN CODE
(akTargetRef as Actor).AddSpell(_EDQuest._EDFollowerSpell)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

_EDQuestScript Property _EDQuest Auto
