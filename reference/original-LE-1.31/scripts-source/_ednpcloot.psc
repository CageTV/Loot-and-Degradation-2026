Scriptname _EDNPCLoot extends activemagiceffect  

_EDQuestScript Property _EDQuest Auto

Int CheckCount = 0

Actor targ

;====================================================================================

Function TransferItems(Actor akKiller, Bool Friendly = False)
	Int LootFilter = _EDQuest.LootFilter
	If LootFilter == 0
		targ.RemoveAllItems(akKiller)
	Else
		Form Gold = _EDQuest.Gold001
		Form kForm
		Int iFormIndex = targ.GetNumItems() as Int
		If !Friendly
			While iFormIndex > 0
				iFormIndex -= 1
				kForm = targ.GetNthForm(iFormIndex)
				If kForm as Ammo || kForm == Gold
					targ.RemoveItem(kForm, targ.GetItemCount(kForm) as Int, true, akKiller)
				ElseIf kForm as Potion
					targ.RemoveItem(kForm, 1, true, akKiller)
				Else
					Int GoldValue = kForm.GetGoldValue() as Int
					If (GoldValue > LootFilter && GoldValue < 5000)
						targ.RemoveItem(kForm, 1, true, akKiller)
					EndIf
				EndIf
				Utility.Wait(0.1)
			EndWhile
		Else
			While iFormIndex > 0
				iFormIndex -= 1
				kForm = targ.GetNthForm(iFormIndex)
				If kForm as Ammo
					targ.RemoveItem(kForm, targ.GetItemCount(kForm) as Int, true, akKiller)
				ElseIf kForm as Weapon || (kForm as Armor && (kForm as Armor).IsShield()) || kForm as Potion
					targ.RemoveItem(kForm, 1, true, akKiller)
				EndIf
				Utility.Wait(0.1)
			EndWhile
		EndIf
	EndIf
EndFunction

Function DeathCheck(Actor akKiller)
	Utility.Wait(0.5)
	If targ && targ.IsDead() && akKiller
		If akKiller != _EDQuest.PlayerRef && !akKiller.IsPlayerTeammate()
			If akKiller.GetDistance(targ) as Int <= 768 && !akKiller.IsDead() && IsRightActor(targ, akKiller) && targ.GetFactionReaction(akKiller) as Int == 1
				TransferItems(akKiller)
			Else
				Search(akKiller)
			EndIf
		Else
			Utility.Wait(1.5)
			Search(_EDQuest.PlayerRef)
		EndIf
	EndIf
	GoToState("Dead")
EndFunction

Function Search(Actor akKiller)
	If targ && akKiller
		Actor Looter = Game.FindRandomActorFromRef(targ, 768.0)
		If Looter && !Looter.IsDead()
			If IsRightActor(Looter, akKiller)
				If Looter.GetFactionReaction(akKiller) as Int == 1
					TransferItems(Looter, true)
				ElseIf akKiller != _EDQuest.PlayerRef
					TransferItems(Looter)
				ElseIf CheckCount < 3
					CheckCount += 1
					Utility.Wait(1.0)
					Search(akKiller)
				EndIf
			ElseIf CheckCount < 3
				CheckCount += 1
				Utility.Wait(1.0)
				Search(akKiller)
			EndIf
		ElseIf CheckCount < 3
			CheckCount += 1
			Utility.Wait(3.0)
			Search(akKiller)
		EndIf
	EndIf
EndFunction

Bool Function IsRightActor(Actor Looter, Actor akKiller)
	If Looter != _EDQuest.PlayerRef && !Looter.IsPlayerTeammate() && Looter.HasKeyword(_EDQuest.ActorTypeNPC) && Looter.HasSpell(_EDQuest._EDNPCEmptySpell)
		Return True
	EndIf
	Return False
EndFunction

;====================================================================================

Event OnEffectStart(Actor akTarget, Actor akCaster)
	targ = akTarget
	targ.AddSpell(_EDQuest._EDNPCEmptySpell)
	GoToState("Waiting")
EndEvent

;====================================================================================

State Waiting

	Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
		targ.AddSpell(_EDQuest._EDNPCSpell)
		If _EDQuest.NPCsLoot
			GoToState("WaitingToDie")
		Else
			GoToState("Dead")
		EndIf
	EndEvent

	Event OnDeath(Actor akKiller)
		If _EDQuest.NPCsLoot
			DeathCheck(akKiller)
		Else
			GoToState("Dead")
		EndIf
	EndEvent

EndState

;====================================================================================

State WaitingToDie

	Event OnDeath(Actor akKiller)
		DeathCheck(akKiller)
	EndEvent

EndState

State Dead
EndState