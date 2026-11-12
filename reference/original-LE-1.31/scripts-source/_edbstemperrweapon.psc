;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 2
Scriptname _EDBSTemperRWeapon Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_1
Function Fragment_1(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
_EDQuest.TemperItem(akSpeaker, 1, 0, _EDQuest._EDHasEquippedRWeapon, _EDQuest._EDRWeaponDiscount)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

_EDQuestScript Property _EDQuest Auto
