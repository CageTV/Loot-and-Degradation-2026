;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 2
Scriptname _EDBSTemperHead Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_1
Function Fragment_1(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
If _EDQuest.HeadSlot
_EDQuest.TemperItem(akSpeaker, 1, 0x00000001, _EDQuest._EDHasEquippedHead, _EDQuest._EDHeadDiscount)
Else
_EDQuest.TemperItem(akSpeaker, 1, 0x00000002, _EDQuest._EDHasEquippedHead, _EDQuest._EDHeadDiscount)
EndIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

_EDQuestScript Property _EDQuest Auto
