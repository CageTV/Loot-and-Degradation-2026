Scriptname _EDCourierHere extends activemagiceffect 

Bool Property IsCourier Auto 

_EDQuestScript Property _EDQuest Auto
_EDSkyUIConfig Property _EDSKConfigQuest Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	If IsCourier
		_EDQuest.EmptyContainer.RemoveAllItems(_EDQuest.PlayerRef, false, true)
		Utility.Wait(2.0)
		akTarget.RemoveItem(_EDQuest._EDEmptyItem, 1, true)
	Else
		GoToState("Waiting")
	EndIf
EndEvent

State Waiting

	Event OnBeginState()
		Utility.Wait(3.0)
		_EDSKConfigQuest.SetContextual()
	EndEvent

	Event OnEffectFinish(Actor akTarget, Actor akCaster)
		_EDSKConfigQuest.OnUpdate()
	EndEvent

EndState