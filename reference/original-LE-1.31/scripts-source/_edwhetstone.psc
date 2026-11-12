Scriptname _EDWhetstone extends ObjectReference  

Message Property _EDWhetstoneRepairMsg Auto
Message Property _EDWhetstoneDegradeMsg Auto

Sound Property _EDWhetStoneOpenLP Auto

ObjectReference Property Workbench Auto
ObjectReference Property Sharpening Auto

_EDQuestScript Property _EDQuest Auto
_EDSkyUIConfig Property _EDSKConfigQuest Auto

Bool Function CheckStatus(Actor akActor)
	If !akActor.IsInCombat()
		If !akActor.IsSneaking()
			If !akActor.IsOnMount()
				If !akActor.IsSwimming()
					Return True
				Else
					Debug.Notification(_EDQuest.RepairSwim)
				EndIf
			Else
				Debug.Notification(_EDQuest.RepairMount)
			EndIf
		Else
			Debug.Notification(_EDQuest.RepairSneak)
		EndIf
	Else
		Debug.Notification(_EDQuest.RepairCombat)
	EndIf
	Return False
EndFunction

Function Menu(Int iMessage = 0, Int iButton = 0,  Bool abMenu = True)
	While abMenu
		If iButton == -1
		ElseIf iMessage == 0
			iButton = _EDWhetstoneRepairMsg.Show()
			If iButton == 0									;Weapons
				If CheckStatus(_EDQuest.PlayerRef)
					Sharpening.Activate(_EDQuest.PlayerRef)
					abMenu = False
				EndIf
			ElseIf iButton == 1								;Armor
				If CheckStatus(_EDQuest.PlayerRef)
					Workbench.Activate(_EDQuest.PlayerRef)
					abMenu = False
				EndIf
			ElseIf iButton == 2								;Degrade
				iMessage = 1
			ElseIf iButton == 3								;Exit
				abMenu = False
			EndIf
		ElseIf iMessage == 1
			iButton = _EDWhetstoneDegradeMsg.Show()
			If iButton == 0									;head
				If _EDQuest.DegradeItem(1, 0x00000001)
				ElseIf _EDQuest.DegradeItem(1, 0x00000002)
				Else
					Debug.Notification(_EDQuest.NoEquip)
				EndIf
			ElseIf iButton == 1								;cuirass
				If _EDQuest.DegradeItem(1, 0x00000004)
				Else
					Debug.Notification(_EDQuest.NoEquip)
				EndIf
			ElseIf iButton == 2								;gloves
				If _EDQuest.DegradeItem(1, 0x00000008)
				Else
					Debug.Notification(_EDQuest.NoEquip)
				EndIf
			ElseIf iButton == 3								;boots
				If _EDQuest.DegradeItem(1, 0x00000080)
				Else
					Debug.Notification(_EDQuest.NoEquip)
				EndIf
			ElseIf iButton == 4								;mainweapon
				If _EDQuest.DegradeItem(1)
				Else
					Debug.Notification(_EDQuest.NoEquip)
				EndIf
			ElseIf iButton == 5								;offweapon
				Weapon Offhand = _EDQuest.PlayerRef.GetEquippedObject(0) as Weapon
				If Offhand
					Int Type = Offhand.GetWeaponType() as Int
					_EDQuest.OHWeapType = Type
					If Type < 5
						If _EDQuest.DegradeItem(0)
						Else
							Debug.Notification(_EDQuest.NoEquip)
						EndIf
					Else
						Debug.Notification(_EDQuest.NoEquip)
					EndIf
				Else
					Debug.Notification(_EDQuest.NoEquip)
				EndIf
			ElseIf iButton == 6								;shield
				If _EDQuest.DegradeItem(1, 0x00000200)
				Else
					Debug.Notification(_EDQuest.NoEquip)
				EndIf
			ElseIf iButton == 7				;cancel
				iMessage = 0
			EndIf
		EndIf
	EndWhile
EndFunction

Event OnEquipped(Actor akActor)
	If akActor == _EDQuest.PlayerRef
		_EDSKConfigQuest.SetContextual()
		_EDWhetStoneOpenLP.Play(_EDQuest.PlayerRef)
		Game.DisablePlayerControls(False, False, False, False, False, True)
		Game.EnablePlayerControls(False, False, False, False, False, True)
		Menu()
	EndIf
EndEvent