Scriptname _EDSkyUIConfig extends SKI_ConfigBase

;====================================================================================

_EDQuestScript Property _EDQuest Auto

String[] Pages
String[] TemperDelayRandomList
String[] BreakTypeList
String[] WeapTypeList
String[] EquipSlotList
String[] DegradeTextList
String[] WidgetStyleList
String[] WidgetPosList
String[] WidgetOrientList
String[] WidgetItemsList

Int DecayChanceOption
Int FollowerDecayChanceOption
Int EnchantRarityOption
Int TemperRarityOption
Int NPCsLootOption
Int TemperServiceOption
Int TemperDelayOption
Int TemperDelayRandomOption
Int TemperCostMultOption
Int LootFilterOption
Int LessLeveledLootOption
Int BreakChanceOption
Int FollowerBreakChanceOption
Int BreakTypeOption
Int BreakableItemsOption
Int MainWeapKeyOption
Int OffWeapKeyOption
Int ShieldKeyOption
Int MainWeapTypeOption
Int OffWeapTypeOption
Int EquipImmuneOption
Int DegradeTextOption
Int EquipmentRepairKitOption
Int ExamineKeyOption
Int WidgetStyleOption
Int WidgetPosOption
Int WidgetOrientOption
Int WidgetXOffsetOption
Int WidgetYOffsetOption
Int WidgetAlphaOption
Int WidgetKeyOption
Int WidgetItemsOption
Int WidgetContextualOption
Int WidgetVisDelayOption

Int DecayChance
Int FollowerDecayChance
Int EnchantRarity
Int TemperRarity
Int TemperDelayRandom
Int BreakChance
Int FollowerBreakChance
Int BreakType
Int MainWeapType
Int OffWeapType
Int EquipImmune
Int DegradeText
Int WidgetStyle
Int WidgetPos
Int WidgetOrient
Int WidgetItems
Int BreakableItems
Int MainWeapKey = -1
Int OffWeapKey = -1
Int ShieldKey = -1
Int ExamineKey = -1
Int WidgetKey = -1

Float TemperDelay
Float TemperCostMult
Float LootFilter
Float WidgetXOffset
Float WidgetYOffset
Float WidgetAlpha
Float WidgetVisDelay

Bool NPCsLoot
Bool TemperService
Bool LessLeveledLoot
Bool BreakArmor
Bool BreakWeapon
Bool EquipmentRepairKit
Bool WidgetContextual

;====================================================================================

Function SetContextual()
	If _EDQuest._EDContextualToggle.GetValue() as Int == 1 && _EDQuest.WidgetHide
		_EDQuest.WidgetHide = False
		SendModEvent("_ED_UIConfigured")
		RegisterForSingleUpdate(10.0)
	EndIf
EndFunction

Function ApplySettings()
	If DecayChance == 0
		_EDQuest.DecayChance = 0
	Else
		_EDQuest.DecayChance = 6667
		If DecayChance == 1
			_EDQuest.PlayerDegMult = 0.25
		ElseIf DecayChance == 2
			_EDQuest.PlayerDegMult = 0.5
		ElseIf DecayChance == 3
			_EDQuest.PlayerDegMult = 0.75
		ElseIf DecayChance == 4
			_EDQuest.PlayerDegMult = 1.0
		ElseIf DecayChance == 5
			_EDQuest.PlayerDegMult = 1.25
		ElseIf DecayChance == 6
			_EDQuest.PlayerDegMult = 1.5
		Else
			_EDQuest.PlayerDegMult = 1.75
		EndIf
	EndIf

	If FollowerDecayChance == 0
		_EDQuest.FollowerDecayChance = 0
		_EDQuest._EDFollowerToggle.SetValue(0)
	Else
		_EDQuest.FollowerDecayChance = 6667
		If FollowerDecayChance == 1
			_EDQuest.FollowerDegMult = 0.25
		ElseIf FollowerDecayChance == 2
			_EDQuest.FollowerDegMult = 0.5
		ElseIf FollowerDecayChance == 3
			_EDQuest.FollowerDegMult = 0.75
		ElseIf FollowerDecayChance == 4
			_EDQuest.FollowerDegMult = 1.0
		ElseIf FollowerDecayChance == 5
			_EDQuest.FollowerDegMult = 1.25
		ElseIf FollowerDecayChance == 6
			_EDQuest.FollowerDegMult = 1.5
		Else
			_EDQuest.FollowerDegMult = 1.75
		EndIf
		_EDQuest._EDFollowerToggle.SetValue(1)
	EndIf

	If EnchantRarity == 0
		_EDQuest.EnchantRarity = 0
	ElseIf EnchantRarity == 1
		_EDQuest.EnchantRarity = 200
	ElseIf EnchantRarity == 2
		_EDQuest.EnchantRarity = 100
	ElseIf EnchantRarity == 3
		_EDQuest.EnchantRarity = 66
	ElseIf EnchantRarity == 4
		_EDQuest.EnchantRarity = 50
	ElseIf EnchantRarity == 5
		_EDQuest.EnchantRarity = 40
	ElseIf EnchantRarity == 6
		_EDQuest.EnchantRarity = 34
	Else
		_EDQuest.EnchantRarity = 29
	EndIf

	If TemperRarity == 0
		_EDQuest.TemperRarity = 0
	Else
		_EDQuest.TemperRarity = 12500000
		_EDQuest.LevelIncrementMult = TemperRarity
	EndIf

	If BreakChance == 0
		_EDQuest.PlayerBreakChance = 0.0
	ElseIf BreakChance == 1
		_EDQuest.PlayerBreakChance = 0.4
	ElseIf BreakChance == 2
		_EDQuest.PlayerBreakChance = 0.6
	ElseIf BreakChance == 3
		_EDQuest.PlayerBreakChance = 0.8
	ElseIf BreakChance == 4
		_EDQuest.PlayerBreakChance = 1.0
	ElseIf BreakChance == 5
		_EDQuest.PlayerBreakChance = 1.2
	ElseIf BreakChance == 6
		_EDQuest.PlayerBreakChance = 1.4
	Else
		_EDQuest.PlayerBreakChance = 1.6
	EndIf

	If FollowerBreakChance == 0
		_EDQuest.FollowerBreakChance = 0.0
	ElseIf FollowerBreakChance == 1
		_EDQuest.FollowerBreakChance = 0.4
	ElseIf FollowerBreakChance == 2
		_EDQuest.FollowerBreakChance = 0.6
	ElseIf FollowerBreakChance == 3
		_EDQuest.FollowerBreakChance = 0.8
	ElseIf FollowerBreakChance == 4
		_EDQuest.FollowerBreakChance = 1.0
	ElseIf FollowerBreakChance == 5
		_EDQuest.FollowerBreakChance = 1.2
	ElseIf FollowerBreakChance == 6
		_EDQuest.FollowerBreakChance = 1.4
	Else
		_EDQuest.FollowerBreakChance = 1.6
	EndIf

	_EDQuest.NPCsLoot = NPCsLoot
	_EDQuest.LessLeveledLoot = LessLeveledLoot
	_EDQuest.TemperCostMult = TemperCostMult
	_EDQuest.BreakType = BreakType
	_EDQuest.BreakableItems = BreakableItems
	_EDQuest.DegradeText = DegradeText
	If WidgetStyle == 0
		_EDQuest.WidgetVisible = False
		_EDQuest.WidgetItems = 0
		_EDQuest._EDContextualToggle.SetValue(0)
	Else
		_EDQuest.WidgetVisible = True
	EndIf
	_EDQuest.WidgetStyle = WidgetStyle
	_EDQuest.WidgetPos = WidgetPos
	_EDQuest.WidgetOrient = WidgetOrient
	_EDQuest.WidgetXOffset = WidgetXOffset as Int
	_EDQuest.WidgetYOffset = (WidgetYOffset * -1) as Int
	_EDQuest.WidgetAlpha = WidgetAlpha
	_EDQuest.WidgetItems = WidgetItems
	If WidgetContextual
		_EDQuest.WidgetHide = True
		_EDQuest._EDContextualToggle.SetValue(1)
	Else
		If WidgetVisDelay == 0.0
			_EDQuest.WidgetHide = False
		Else
			_EDQuest.WidgetHide = True
		EndIf
		_EDQuest._EDContextualToggle.SetValue(0)
	EndIf
	If EquipmentRepairKit
		_EDQuest._EDWhetstoneToggle.SetValue(1)
		If !_EDQuest.WhetstonesAdded
			_EDQuest.LItemMiscHunterAnimalParts75.AddForm(_EDQuest._EDWhetstoneRepair, 1, 1)
			_EDQuest.LItemBlacksmithMinimum.AddForm(_EDQuest._EDWhetstoneRepair, 1, 1)
			_EDQuest.LItemBlacksmithMinimum.AddForm(_EDQuest.BlacksmithHammer01, 1, 1)
			_EDQuest.LItemBlacksmithMineralsRaw75.AddForm(_EDQuest._EDWhetstoneRepair, 1, 1)
			_EDQuest.LootToolRandom05.AddForm(_EDQuest.BlacksmithHammer01, 1, 1)
			_EDQuest.LootToolRandom05.AddForm(_EDQuest.BlacksmithHammer01, 1, 1)
			_EDQuest.WhetstonesAdded = True
		EndIf
	Else
		_EDQuest._EDWhetstoneToggle.SetValue(0)
	EndIf
		
	If TemperDelayRandom == 1
		_EDQuest.TemperDelayRandom = True
	Else
		_EDQuest.TemperDelayRandom = False
	EndIf
	If TemperService
		_EDQuest._EDServicesQuest.Start()
	Else
		_EDQuest._EDServicesQuest.Stop()
	EndIf
	_EDQuest.TemperService = TemperService
	If _EDQuest.TemperDelay > 0 && TemperDelay == 0
		_EDQuest.EmptyContainer.RemoveAllItems(_EDQuest.PlayerRef, false, true)
	EndIf
	_EDQuest.TemperDelay = TemperDelay as Int
	_EDQuest.LootFilter = LootFilter as Int
	If MainWeapKey > -1
		RegisterForKey(MainWeapKey)
	Else
		UnregisterForKey(MainWeapKey)
	EndIf
	If OffWeapKey > -1
		RegisterForKey(OffWeapKey)
	Else
		UnregisterForKey(OffWeapKey)
	EndIf
	If ShieldKey > -1
		RegisterForKey(ShieldKey)
	Else
		UnregisterForKey(ShieldKey)
	EndIf
	If ExamineKey > -1
		RegisterForKey(ExamineKey)
	Else
		UnregisterForKey(ExamineKey)
	EndIf
	If WidgetKey > -1
		RegisterForKey(WidgetKey)
	Else
		UnregisterForKey(WidgetKey)
	EndIf
	If EquipImmune == 1
		Form EquippedHead = _EDQuest.PlayerRef.GetWornForm(0x00000001)
		If !EquippedHead
			EquippedHead = _EDQuest.PlayerRef.GetWornForm(0x00000002)
		EndIf
		If EquippedHead
			If !EquippedHead.HasKeyword(_EDQuest.MagicDisallowEnchanting)
				If _EDQuest._EDNoBreakList.HasForm(EquippedHead)
					_EDQuest._EDNoBreakList.RemoveAddedForm(EquippedHead)
					Debug.Notification(EquippedHead.GetName() + _EDQuest.RemoveImmune)
				Else
					_EDQuest._EDNoBreakList.AddForm(EquippedHead)
					Debug.Notification(EquippedHead.GetName() + _EDQuest.AddImmune)
				EndIf
			Else
				Debug.Notification(EquippedHead.GetName() + _EDQuest.NoImmune)
			EndIf
		EndIf
	ElseIf EquipImmune == 2
		Form EquippedBody = _EDQuest.PlayerRef.GetWornForm(0x00000004)
		If EquippedBody
			If !EquippedBody.HasKeyword(_EDQuest.MagicDisallowEnchanting)
				If _EDQuest._EDNoBreakList.HasForm(EquippedBody)
					_EDQuest._EDNoBreakList.RemoveAddedForm(EquippedBody)
					Debug.Notification(EquippedBody.GetName() + _EDQuest.RemoveImmune)
				Else
					_EDQuest._EDNoBreakList.AddForm(EquippedBody)
					Debug.Notification(EquippedBody.GetName() + _EDQuest.AddImmune)
				EndIf
			Else
				Debug.Notification(EquippedBody.GetName() + _EDQuest.NoImmune)
			EndIf
		EndIf
	ElseIf EquipImmune == 3
		Form EquippedHand = _EDQuest.PlayerRef.GetWornForm(0x00000008)
		If EquippedHand
			If !EquippedHand.HasKeyword(_EDQuest.MagicDisallowEnchanting)
				If _EDQuest._EDNoBreakList.HasForm(EquippedHand)
					_EDQuest._EDNoBreakList.RemoveAddedForm(EquippedHand)
					Debug.Notification(EquippedHand.GetName() + _EDQuest.RemoveImmune)
				Else
					_EDQuest._EDNoBreakList.AddForm(EquippedHand)
					Debug.Notification(EquippedHand.GetName() + _EDQuest.AddImmune)
				EndIf
			Else
				Debug.Notification(EquippedHand.GetName() + _EDQuest.NoImmune)
			EndIf
		EndIf
	ElseIf EquipImmune == 4
		Form EquippedFeet = _EDQuest.PlayerRef.GetWornForm(0x00000080)
		If EquippedFeet
			If !EquippedFeet.HasKeyword(_EDQuest.MagicDisallowEnchanting)
				If _EDQuest._EDNoBreakList.HasForm(EquippedFeet)
					_EDQuest._EDNoBreakList.RemoveAddedForm(EquippedFeet)
					Debug.Notification(EquippedFeet.GetName() + _EDQuest.RemoveImmune)
				Else
					_EDQuest._EDNoBreakList.AddForm(EquippedFeet)
					Debug.Notification(EquippedFeet.GetName() + _EDQuest.AddImmune)
				EndIf
			Else
				Debug.Notification(EquippedFeet.GetName() + _EDQuest.NoImmune)
			EndIf
		EndIf
	ElseIf EquipImmune == 5
		Form EquippedShield = _EDQuest.PlayerRef.GetWornForm(0x00000200)
		If EquippedShield
			If !EquippedShield.HasKeyword(_EDQuest.MagicDisallowEnchanting)
				If _EDQuest._EDNoBreakList.HasForm(EquippedShield)
					_EDQuest._EDNoBreakList.RemoveAddedForm(EquippedShield)
					Debug.Notification(EquippedShield.GetName() + _EDQuest.RemoveImmune)
				Else
					_EDQuest._EDNoBreakList.AddForm(EquippedShield)
					Debug.Notification(EquippedShield.GetName() + _EDQuest.AddImmune)
				EndIf
			Else
				Debug.Notification(EquippedShield.GetName() + _EDQuest.NoImmune)
			EndIf
		EndIf
	ElseIf EquipImmune == 6
		Form EquippedRWeapon = _EDQuest.PlayerRef.GetEquippedObject(1)
		If EquippedRWeapon
			If !EquippedRWeapon.HasKeyword(_EDQuest.MagicDisallowEnchanting)
				If _EDQuest._EDNoBreakList.HasForm(EquippedRWeapon)
					_EDQuest._EDNoBreakList.RemoveAddedForm(EquippedRWeapon)
					Debug.Notification(EquippedRWeapon.GetName() + _EDQuest.RemoveImmune)
				Else
					_EDQuest._EDNoBreakList.AddForm(EquippedRWeapon)
					Debug.Notification(EquippedRWeapon.GetName() + _EDQuest.AddImmune)
				EndIf
			Else
				Debug.Notification(EquippedRWeapon.GetName() + _EDQuest.NoImmune)
			EndIf
		EndIf
	EndIf
	EquipImmune = 0
	SendModEvent("_ED_UIConfigured")
EndFunction

;====================================================================================

Event OnConfigInit()
	ModName = "$Loot and Degradation"

	Pages = New String[2]
	Pages[0] = "$General"
	Pages[1] = "$Extra"

	TemperDelayRandomList = New String[2]
	TemperDelayRandomList[0] = "$Fixed"
	TemperDelayRandomList[1] = "$Random"

	BreakTypeList = New String[3]
	BreakTypeList[0] = "$Classic"
	BreakTypeList[1] = "$Mixed"
	BreakTypeList[2] = "$Progressive"

	WeapTypeList = New String[3]
	WeapTypeList[0] = "$One-Handed"
	WeapTypeList[1] = "$Two-Handed"
	WeapTypeList[2] = "$Bows/Crossbows"

	EquipSlotList = New String[7]
	EquipSlotList[0] = "$None"
	EquipSlotList[1] = "$Head"
	EquipSlotList[2] = "$Body"
	EquipSlotList[3] = "$Hands"
	EquipSlotList[4] = "$Feet"
	EquipSlotList[5] = "$Shield"
	EquipSlotList[6] = "$Main Weapon"

	DegradeTextList = New String[3]
	DegradeTextList[0] = "$Disabled"
	DegradeTextList[1] = "$Untempered"
	DegradeTextList[2] = "$All"

	WidgetStyleList = New String[4]
	WidgetStyleList[0] = "$Disabled"
	WidgetStyleList[1] = "$Percentage-Based"
	WidgetStyleList[2] = "$Alpha-Based"
	WidgetStyleList[3] = "$Alpha/Percentage-Based"

	WidgetPosList = New String[4]
	WidgetPosList[0] = "$Middle, Right"
	WidgetPosList[1] = "$Middle, Left"
	WidgetPosList[2] = "$Bottom, Middle"
	WidgetPosList[3] = "$Top, Middle"

	WidgetOrientList = New String[2]
	WidgetOrientList[0] = "$Vertical"
	WidgetOrientList[1] = "$Horizontal"
	
	WidgetItemsList = New String[3]
	WidgetItemsList[0] = "$All"
	WidgetItemsList[1] = "$Weapons Only"
	WidgetItemsList[2] = "$Armor Only"

	If _EDQuest.DecayChance == 0
		DecayChance = 0
	Else
		If _EDQuest.PlayerDegMult == 0.25
			DecayChance = 1
		ElseIf _EDQuest.PlayerDegMult == 0.5
			DecayChance = 2
		ElseIf _EDQuest.PlayerDegMult == 0.75
			DecayChance = 3
		ElseIf _EDQuest.PlayerDegMult == 1.0
			DecayChance = 4
		ElseIf _EDQuest.PlayerDegMult == 1.25
			DecayChance = 5
		ElseIf _EDQuest.PlayerDegMult == 1.5
			DecayChance = 6
		Else
			DecayChance = 7
		EndIf
	EndIf

	If _EDQuest.FollowerDecayChance == 0
		FollowerDecayChance = 0
	Else
		If _EDQuest.FollowerDegMult == 0.25
			FollowerDecayChance = 1
		ElseIf _EDQuest.FollowerDegMult == 0.5
			FollowerDecayChance = 2
		ElseIf _EDQuest.FollowerDegMult == 0.75
			FollowerDecayChance = 3
		ElseIf _EDQuest.FollowerDegMult == 1.0
			FollowerDecayChance = 4
		ElseIf _EDQuest.FollowerDegMult == 1.25
			FollowerDecayChance = 5
		ElseIf _EDQuest.FollowerDegMult == 1.5
			FollowerDecayChance = 6
		Else
			FollowerDecayChance = 7
		EndIf
	EndIf

	If _EDQuest.EnchantRarity == 0
		EnchantRarity = 0
	ElseIf _EDQuest.EnchantRarity == 200
		EnchantRarity = 1
	ElseIf _EDQuest.EnchantRarity == 100
		EnchantRarity = 2
	ElseIf _EDQuest.EnchantRarity == 66
		EnchantRarity = 3
	ElseIf _EDQuest.EnchantRarity == 50
		EnchantRarity = 4
	ElseIf _EDQuest.EnchantRarity == 40
		EnchantRarity = 5
	ElseIf _EDQuest.EnchantRarity == 34
		EnchantRarity = 6
	Else
		EnchantRarity = 7
	EndIf

	If _EDQuest.TemperRarity == 0
		TemperRarity = 0
	Else
		TemperRarity = _EDQuest.LevelIncrementMult
	EndIf

	If _EDQuest.PlayerBreakChance == 0.0
		BreakChance = 0
	ElseIf _EDQuest.PlayerBreakChance == 0.4
		BreakChance = 1
	ElseIf _EDQuest.PlayerBreakChance == 0.6
		BreakChance = 2
	ElseIf _EDQuest.PlayerBreakChance == 0.8
		BreakChance = 3
	ElseIf _EDQuest.PlayerBreakChance == 1.0
		BreakChance = 4
	ElseIf _EDQuest.PlayerBreakChance == 1.2
		BreakChance = 5
	ElseIf _EDQuest.PlayerBreakChance == 1.4
		BreakChance = 6
	Else
		BreakChance = 7
	EndIf

	If _EDQuest.FollowerBreakChance == 0.0
		FollowerBreakChance = 0
	ElseIf _EDQuest.FollowerBreakChance == 0.4
		FollowerBreakChance = 1
	ElseIf _EDQuest.FollowerBreakChance == 0.6
		FollowerBreakChance = 2
	ElseIf _EDQuest.FollowerBreakChance == 0.8
		FollowerBreakChance = 3
	ElseIf _EDQuest.FollowerBreakChance == 1.0
		FollowerBreakChance = 4
	ElseIf _EDQuest.FollowerBreakChance == 1.2
		FollowerBreakChance = 5
	ElseIf _EDQuest.FollowerBreakChance == 1.4
		FollowerBreakChance = 6
	Else
		FollowerBreakChance = 7
	EndIf

	TemperService = _EDQuest.TemperService
	TemperDelay = _EDQuest.TemperDelay as Float
	LootFilter = _EDQuest.LootFilter as Float
	NPCsLoot = _EDQuest.NPCsLoot
	TemperCostMult = _EDQuest.TemperCostMult
	LessLeveledLoot = _EDQuest.LessLeveledLoot
	BreakType = _EDQuest.BreakType
	BreakableItems = _EDQuest.BreakableItems
	DegradeText = _EDQuest.DegradeText
	WidgetStyle = _EDQuest.WidgetStyle
	WidgetPos = _EDQuest.WidgetPos
	WidgetOrient = _EDQuest.WidgetOrient
	WidgetXOffset = _EDQuest.WidgetXOffset
	WidgetYOffset = _EDQuest.WidgetYOffset * -1
	WidgetAlpha = _EDQuest.WidgetAlpha
	WidgetItems = _EDQuest.WidgetItems
	If _EDQuest._EDContextualToggle.GetValue() as Int == 1
		WidgetContextual = True
	Else
		WidgetContextual = False
	EndIf
	If _EDQuest._EDWhetstoneToggle.GetValue() as Int == 1
		EquipmentRepairKit = True
	Else
		EquipmentRepairKit = False
	EndIf
	If _EDQuest.TemperDelayRandom
		TemperDelayRandom = 1
	Else
		TemperDelayRandom = 0
	EndIf
EndEvent

Event OnPageReset(String Page)
	If Page == ""
		LoadCustomContent("lootanddegradation/title.dds")
		Return
	Else
		UnloadCustomContent()
	EndIf
	If Page == "$General"
		SetCursorFillMode(TOP_TO_BOTTOM)
		AddHeaderOption("$Loot")
		If _EDQuest.RequiemInstalled
			TemperRarityOption = AddSliderOption("$Tempered Level Tiers", TemperRarity, "{0}", OPTION_FLAG_DISABLED)
		Else
			If LessLeveledLoot
				TemperRarityOption = AddSliderOption("$Tempered Equipment Chance", TemperRarity, "{0}")
			Else
				TemperRarityOption = AddSliderOption("$Tempered Level Tiers", TemperRarity, "{0}")
			EndIf
		EndIf
		EnchantRarityOption = AddSliderOption("$Enchanted Equipment Chance", EnchantRarity, "{0}")
		If TemperRarity > 0 || EnchantRarity > 0
			LessLeveledLootOption = AddToggleOption("$Less Leveled Loot", LessLeveledLoot)
		Else
			LessLeveledLootOption = AddToggleOption("$Less Leveled Loot", LessLeveledLoot, OPTION_FLAG_DISABLED)
		EndIf
		NPCsLootOption = AddToggleOption("$NPCs Loot", NPCsLoot)
		If NPCsLoot
			LootFilterOption = AddSliderOption("", LootFilter, "${0} Gold")
		Else
			LootFilterOption = AddSliderOption("", LootFilter, "${0} Gold", OPTION_FLAG_DISABLED)
		EndIf
		AddHeaderOption("$Services")
		TemperServiceOption = AddToggleOption("$Tempering Service", TemperService)
		If TemperService
			TemperCostMultOption = AddSliderOption("$Tempering Cost Multiplier", TemperCostMult, "{1}")
			TemperDelayOption = AddSliderOption("$Tempering Delay", TemperDelay, "${0} Hours")
			If TemperDelay > 0
				TemperDelayRandomOption = AddTextOption("", TemperDelayRandomList[TemperDelayRandom])
			Else
				TemperDelayRandomOption = AddTextOption("", TemperDelayRandomList[TemperDelayRandom], OPTION_FLAG_DISABLED)
			EndIf
		Else
			TemperCostMultOption = AddSliderOption("$Tempering Cost Multiplier", TemperCostMult, "{1}", OPTION_FLAG_DISABLED)
			TemperDelayOption = AddSliderOption("$Tempering Delay", TemperDelay, "${0} Hours", OPTION_FLAG_DISABLED)
			TemperDelayRandomOption = AddTextOption("", TemperDelayRandomList[TemperDelayRandom], OPTION_FLAG_DISABLED)
		EndIf	
		EquipmentRepairKitOption = AddToggleOption("$Equipment Repair Kits", EquipmentRepairKit)

		SetCursorPosition(1)
		AddHeaderOption("$Degradation")
		DecayChanceOption = AddSliderOption("$Player Degradation Rate", DecayChance, "{0}")
		If DecayChance > 0
			DegradeTextOption = AddMenuOption("$Text Notifications", DegradeTextList[DegradeText])
			BreakChanceOption = AddSliderOption("$Player Item Break Chance", BreakChance, "{0}")
		Else
			DegradeTextOption = AddMenuOption("$Text Notifications", DegradeTextList[DegradeText], OPTION_FLAG_DISABLED)
			BreakChanceOption = AddSliderOption("$Player Item Break Chance", BreakChance, "{0}", OPTION_FLAG_DISABLED)
		EndIf
		AddEmptyOption()
		FollowerDecayChanceOption = AddSliderOption("$Follower Degradation Rate", FollowerDecayChance, "{0}")
		If FollowerDecayChance > 0
			FollowerBreakChanceOption = AddSliderOption("$Follower Item Break Chance", FollowerBreakChance, "{0}")
		Else
			FollowerBreakChanceOption = AddSliderOption("$Follower Item Break Chance", FollowerBreakChance, "{0}", OPTION_FLAG_DISABLED)
		EndIf
		AddEmptyOption()
		If BreakChance > 0 || FollowerBreakChance > 0
			BreakTypeOption = AddMenuOption("$Item Break System", BreakTypeList[BreakType])
			BreakableItemsOption = AddMenuOption("$Breakable Items", WidgetItemsList[BreakableItems])
			EquipImmuneOption = AddMenuOption("$Equipment Immunity", EquipSlotList[EquipImmune])
		Else
			BreakTypeOption = AddMenuOption("$Item Break System", BreakTypeList[BreakType], OPTION_FLAG_DISABLED)
			BreakableItemsOption = AddMenuOption("$Breakable Items", WidgetItemsList[BreakableItems], OPTION_FLAG_DISABLED)
			EquipImmuneOption = AddMenuOption("$Equipment Immunity", EquipSlotList[EquipImmune], OPTION_FLAG_DISABLED)
		EndIf
	ElseIf Page == "$Extra"
		SetCursorFillMode(TOP_TO_BOTTOM)
		AddHeaderOption("$Hotkeys")
		MainWeapTypeOption = AddMenuOption("$Weapon 1", WeapTypeList[MainWeapType])
		MainWeapKeyOption = AddKeyMapOption("", MainWeapKey, OPTION_FLAG_WITH_UNMAP)
		OffWeapTypeOption = AddMenuOption("$Weapon 2", WeapTypeList[OffWeapType])
		OffWeapKeyOption = AddKeyMapOption("", OffWeapKey, OPTION_FLAG_WITH_UNMAP)
		ShieldKeyOption = AddKeyMapOption("$Shield", ShieldKey, OPTION_FLAG_WITH_UNMAP)
		If DecayChance > 0
			ExamineKeyOption = AddKeyMapOption("$Examine Equipment", ExamineKey, OPTION_FLAG_WITH_UNMAP)
		Else
			ExamineKeyOption = AddKeyMapOption("$Examine Equipment", ExamineKey, OPTION_FLAG_DISABLED)
		EndIf
		If WidgetStyle > 0 && DecayChance > 0
			WidgetKeyOption = AddKeyMapOption("$Toggle Widgets", WidgetKey, OPTION_FLAG_WITH_UNMAP)
			If WidgetKey > -1
				WidgetVisDelayOption = AddSliderOption("", WidgetVisDelay, "${0} Seconds")
			Else
				WidgetVisDelayOption = AddSliderOption("", WidgetVisDelay, "${0} Seconds", OPTION_FLAG_DISABLED)
			EndIf
		Else
			WidgetKeyOption = AddKeyMapOption("$Toggle Widgets", WidgetKey, OPTION_FLAG_DISABLED)
			WidgetVisDelayOption = AddSliderOption("", WidgetVisDelay, "${0} Seconds", OPTION_FLAG_DISABLED)
		EndIf

		SetCursorPosition(1)
		AddHeaderOption("$Widgets")
		If DecayChance > 0
			WidgetStyleOption = AddMenuOption("$Style", WidgetStyleList[WidgetStyle])
			If WidgetStyle > 0
				WidgetContextualOption = AddToggleOption("$Contextual", WidgetContextual)
				WidgetItemsOption = AddMenuOption("$Visible Items", WidgetItemsList[WidgetItems])
				WidgetPosOption = AddMenuOption("$Position", WidgetPosList[WidgetPos])
				WidgetOrientOption = AddTextOption("$Orientation", WidgetOrientList[WidgetOrient])
				WidgetXOffsetOption = AddSliderOption("$X Offset", WidgetXOffset, "{0}")
				WidgetYOffsetOption = AddSliderOption("$Y Offset", WidgetYOffset, "{0}")
				If WidgetStyle == 1
					WidgetAlphaOption = AddSliderOption("$Alpha", WidgetAlpha, "{0}")
				Else
					WidgetAlpha = 100.0
					WidgetAlphaOption = AddSliderOption("$Alpha", WidgetAlpha, "{0}", OPTION_FLAG_DISABLED)
				EndIf
			Else
				WidgetContextualOption = AddToggleOption("$Contextual", WidgetContextual, OPTION_FLAG_DISABLED)
				WidgetItemsOption = AddMenuOption("$Visible Items", WidgetItemsList[WidgetItems], OPTION_FLAG_DISABLED)
				WidgetPosOption = AddMenuOption("$Position", WidgetPosList[WidgetPos], OPTION_FLAG_DISABLED)
				WidgetOrientOption = AddTextOption("$Orientation", WidgetOrientList[WidgetOrient], OPTION_FLAG_DISABLED)
				WidgetXOffsetOption = AddSliderOption("$X Offset", WidgetXOffset, "{0}", OPTION_FLAG_DISABLED)
				WidgetYOffsetOption = AddSliderOption("$Y Offset", WidgetYOffset, "{0}", OPTION_FLAG_DISABLED)
				WidgetAlphaOption = AddSliderOption("$Alpha", WidgetAlpha, "{0}", OPTION_FLAG_DISABLED)
			EndIf
		Else
			WidgetStyleOption = AddMenuOption("$Style", WidgetStyleList[WidgetStyle], OPTION_FLAG_DISABLED)
			WidgetPosOption = AddMenuOption("$Position", WidgetPosList[WidgetPos], OPTION_FLAG_DISABLED)
			WidgetOrientOption = AddTextOption("$Orientation", WidgetOrientList[WidgetOrient], OPTION_FLAG_DISABLED)
			WidgetXOffsetOption = AddSliderOption("$X Offset", WidgetXOffset, "{0}", OPTION_FLAG_DISABLED)
			WidgetYOffsetOption = AddSliderOption("$Y Offset", WidgetYOffset, "{0}", OPTION_FLAG_DISABLED)
			WidgetAlphaOption = AddSliderOption("$Alpha", WidgetAlpha, "{0}", OPTION_FLAG_DISABLED)
		EndIf
	EndIf
EndEvent

;====================================================================================

Event OnOptionSelect(Int Option)
	If Option == NPCsLootOption
		NPCsLoot = !NPCsLoot
		SetToggleOptionValue(NPCsLootOption, NPCsLoot)
		ForcePageReset()
	ElseIf Option == TemperServiceOption
		TemperService = !TemperService
		SetToggleOptionValue(TemperServiceOption, TemperService)
		ForcePageReset()
	ElseIf Option == LessLeveledLootOption
		LessLeveledLoot = !LessLeveledLoot
		If LessLeveledLoot
			If _EDQuest.RequiemInstalled
				TemperRarity = 0
			Else
				TemperRarity = 150
			EndIf
			EnchantRarity = 1
		Else
			If _EDQuest.RequiemInstalled
				TemperRarity = 0
			Else
				TemperRarity = 8
			EndIf
			EnchantRarity = 4
		EndIf
		SetToggleOptionValue(LessLeveledLootOption, LessLeveledLoot)
		ForcePageReset()
	ElseIf Option == TemperDelayRandomOption
		If TemperDelayRandom < 1
			TemperDelayRandom += 1
		Else
			TemperDelayRandom = 0
		EndIf
		SetTextOptionValue(TemperDelayRandomOption, TemperDelayRandomList[TemperDelayRandom])
	ElseIf Option == EquipmentRepairKitOption
		EquipmentRepairKit = !EquipmentRepairKit
		SetToggleOptionValue(EquipmentRepairKitOption, EquipmentRepairKit)
	ElseIf Option == WidgetContextualOption
		WidgetContextual = !WidgetContextual
		SetToggleOptionValue(WidgetContextualOption, WidgetContextual)
	ElseIf Option == WidgetOrientOption
		If WidgetOrient == 0
			WidgetOrient += 1
		Else
			WidgetOrient -= 1
		EndIf
		SetTextOptionValue(WidgetOrientOption, WidgetOrientList[WidgetOrient])
	EndIf
EndEvent

Event OnOptionMenuOpen(Int Option)
	SetMenuDialogDefaultIndex(0)
	If Option == MainWeapTypeOption
		SetMenuDialogStartIndex(MainWeapType)
		SetMenuDialogOptions(WeapTypeList)
	ElseIf Option == OffWeapTypeOption
		SetMenuDialogStartIndex(OffWeapType)
		SetMenuDialogOptions(WeapTypeList)
	ElseIf Option == BreakTypeOption
		SetMenuDialogOptions(BreakTypeList)
		SetMenuDialogStartIndex(BreakType)
	ElseIf Option == EquipImmuneOption
		SetMenuDialogOptions(EquipSlotList)
		SetMenuDialogStartIndex(EquipImmune)
	ElseIf Option == DegradeTextOption
		SetMenuDialogOptions(DegradeTextList)
		SetMenuDialogStartIndex(DegradeText)
	ElseIf Option == WidgetStyleOption
		SetMenuDialogDefaultIndex(1)
		SetMenuDialogOptions(WidgetStyleList)
		SetMenuDialogStartIndex(WidgetStyle)
	ElseIf Option == WidgetPosOption
		SetMenuDialogOptions(WidgetPosList)
		SetMenuDialogStartIndex(WidgetPos)
	ElseIf Option == WidgetItemsOption
		SetMenuDialogOptions(WidgetItemsList)
		SetMenuDialogStartIndex(WidgetItems)
	ElseIf Option == BreakableItemsOption
		SetMenuDialogOptions(WidgetItemsList)
		SetMenuDialogStartIndex(BreakableItems)
	EndIf
EndEvent

Event OnOptionMenuAccept(Int Option, Int Index)
	If Option == BreakTypeOption
		BreakType = Index
		SetMenuOptionValue(BreakTypeOption, BreakTypeList[BreakType])
	ElseIf Option == MainWeapTypeOption
		MainWeapType = Index
		SetMenuOptionValue(MainWeapTypeOption, WeapTypeList[MainWeapType])
	ElseIf Option == OffWeapTypeOption
		OffWeapType = Index
		SetMenuOptionValue(OffWeapTypeOption, WeapTypeList[OffWeapType])
	ElseIf Option == EquipImmuneOption
		EquipImmune = Index
		SetMenuOptionValue(EquipImmuneOption, EquipSlotList[EquipImmune])
	ElseIf Option == DegradeTextOption
		DegradeText = Index
		SetMenuOptionValue(DegradeTextOption, DegradeTextList[DegradeText])
	ElseIf Option == WidgetStyleOption
		WidgetStyle = Index
		SetMenuOptionValue(WidgetStyleOption, WidgetStyleList[WidgetStyle])
	ElseIf Option == WidgetPosOption
		WidgetPos = Index
		SetMenuOptionValue(WidgetPosOption, WidgetPosList[WidgetPos])
		WidgetXOffset = 0
		WidgetYOffset = 0
		If WidgetPos < 2
			WidgetOrient = 0
		Else
			WidgetOrient = 1
		EndIf
	ElseIf Option == WidgetItemsOption
		WidgetItems = Index
		SetMenuOptionValue(WidgetItemsOption, WidgetItemsList[WidgetItems])
	ElseIf Option == BreakableItemsOption
		BreakableItems = Index
		SetMenuOptionValue(BreakableItemsOption, WidgetItemsList[BreakableItems])
	EndIf
	ForcePageReset()
EndEvent

Event OnOptionSliderOpen(Int Option)
	If Option == TemperDelayOption
		SetSliderDialogStartValue(TemperDelay)
		SetSliderDialogDefaultValue(0.0)
		SetSliderDialogRange(0.0, 168.0)
		SetSliderDialogInterval(2.0)
	ElseIf Option == LootFilterOption
		SetSliderDialogStartValue(LootFilter)
		SetSliderDialogDefaultValue(25.0)
		SetSliderDialogRange(0.0, 500.0)
		SetSliderDialogInterval(5.0)
	ElseIf Option == TemperCostMultOption
		SetSliderDialogStartValue(TemperCostMult)
		SetSliderDialogDefaultValue(1.0)
		SetSliderDialogRange(0.25, 3.0)
		SetSliderDialogInterval(0.1)
	ElseIf Option == WidgetXOffsetOption
		SetSliderDialogStartValue(WidgetXOffset)
		SetSliderDialogDefaultValue(0.0)
		SetSliderDialogRange(-550.0, 550.0)
		SetSliderDialogInterval(5.0)
	ElseIf Option == WidgetYOffsetOption
		SetSliderDialogStartValue(WidgetYOffset)
		SetSliderDialogDefaultValue(0.0)
		SetSliderDialogRange(-250.0, 250.0)
		SetSliderDialogInterval(5.0)
	ElseIf Option == WidgetAlphaOption
		SetSliderDialogStartValue(WidgetAlpha)
		SetSliderDialogDefaultValue(100.0)
		SetSliderDialogRange(5.0, 100.0)
		SetSliderDialogInterval(5.0)
	ElseIf Option == WidgetVisDelayOption
		SetSliderDialogStartValue(WidgetVisDelay)
		SetSliderDialogDefaultValue(0.0)
		SetSliderDialogRange(0.0, 20.0)
		SetSliderDialogInterval(1.0)
	ElseIf Option == TemperRarityOption
		SetSliderDialogStartValue(TemperRarity)
		If LessLeveledLoot
			SetSliderDialogDefaultValue(150.0)
			SetSliderDialogRange(0.0, 300.0)
			SetSliderDialogInterval(10.0)
		Else
			SetSliderDialogDefaultValue(8.0)
			SetSliderDialogRange(0.0, 50.0)
			SetSliderDialogInterval(1.0)
		EndIf
	Else
		SetSliderDialogDefaultValue(4.0)
		SetSliderDialogRange(0.0, 7.0)
		SetSliderDialogInterval(1.0)
		If Option == EnchantRarityOption
			SetSliderDialogStartValue(EnchantRarity)
		ElseIf Option == DecayChanceOption
			SetSliderDialogStartValue(DecayChance)
		ElseIf Option == FollowerDecayChanceOption
			SetSliderDialogStartValue(FollowerDecayChance)
		ElseIf Option == BreakChanceOption
			SetSliderDialogStartValue(BreakChance)
		ElseIf Option == FollowerBreakChanceOption
			SetSliderDialogStartValue(FollowerBreakChance)
		EndIf
	EndIf
EndEvent

Event OnOptionSliderAccept(Int Option, Float Value)
	If Option == TemperDelayOption
		TemperDelay = Value
		SetSliderOptionValue(TemperDelayOption, TemperDelay, "${0} Hours")
	ElseIf Option == LootFilterOption
		LootFilter = Value
		SetSliderOptionValue(LootFilterOption, LootFilter, "${0} Gold")
	ElseIf Option == TemperCostMultOption
		TemperCostMult = Value
		SetSliderOptionValue(TemperCostMultOption, TemperCostMult, "{1}")
	ElseIf Option == TemperRarityOption
		TemperRarity = Value as Int
		SetSliderOptionValue(TemperRarityOption, TemperRarity, "{0}")
	ElseIf Option == EnchantRarityOption
		EnchantRarity = Value as Int
		SetSliderOptionValue(EnchantRarityOption, EnchantRarity, "{0}")
	ElseIf Option == DecayChanceOption
		DecayChance = Value as Int
		SetSliderOptionValue(DecayChanceOption, DecayChance, "{0}")
		If DecayChance == 0
			WidgetStyle = 0
			WidgetKey = -1
			WidgetVisDelay = 0.0
			ExamineKey = -1
		EndIf
	ElseIf Option == FollowerDecayChanceOption
		FollowerDecayChance = Value as Int
		SetSliderOptionValue(FollowerDecayChanceOption, FollowerDecayChance, "{0}")
	ElseIf Option == BreakChanceOption
		BreakChance = Value as Int
		SetSliderOptionValue(BreakChanceOption, BreakChance, "{0}")
	ElseIf Option == FollowerBreakChanceOption
		FollowerBreakChance = Value as Int
		SetSliderOptionValue(FollowerBreakChanceOption, FollowerBreakChance, "{0}")
	ElseIf Option == WidgetXOffsetOption
		WidgetXOffset = Value
		SetSliderOptionValue(WidgetXOffsetOption, WidgetXOffset, "{0}")
	ElseIf Option == WidgetYOffsetOption
		WidgetYOffset = Value
		SetSliderOptionValue(WidgetYOffsetOption, WidgetYOffset, "{0}")
	ElseIf Option == WidgetAlphaOption
		WidgetAlpha = Value
		SetSliderOptionValue(WidgetAlphaOption, WidgetAlpha, "{0}")
	ElseIf Option == WidgetVisDelayOption
		WidgetVisDelay = Value
		SetSliderOptionValue(WidgetVisDelayOption, WidgetVisDelay, "{0}")
	EndIf
	ForcePageReset()
EndEvent

Event OnOptionKeyMapChange(Int Option, Int KeyCode, String ConflictControl, String ConflictName)
	If Option == MainWeapKeyOption
		MainWeapKey = KeyCode
		SetKeyMapOptionValue(MainWeapKeyOption, MainWeapKey, OPTION_FLAG_WITH_UNMAP)
	ElseIf Option == OffWeapKeyOption
		OffWeapKey = KeyCode
		SetKeyMapOptionValue(OffWeapKeyOption, OffWeapKey, OPTION_FLAG_WITH_UNMAP)
	ElseIf Option == ShieldKeyOption
		ShieldKey = KeyCode
		SetKeyMapOptionValue(ShieldKeyOption, ShieldKey, OPTION_FLAG_WITH_UNMAP)
	ElseIf Option == ExamineKeyOption
		ExamineKey = KeyCode
		SetKeyMapOptionValue(ExamineKeyOption, ExamineKey, OPTION_FLAG_WITH_UNMAP)
	ElseIf Option == WidgetKeyOption
		WidgetKey = KeyCode
		SetKeyMapOptionValue(WidgetKeyOption, WidgetKey, OPTION_FLAG_WITH_UNMAP)
	EndIf
	ForcePageReset()
EndEvent

;====================================================================================

Event OnOptionHighlight(Int Option)
	If Option == TemperRarityOption
		SetInfoText("$EDTemperedTiers")
	ElseIf Option == EnchantRarityOption
		SetInfoText("$EDNPCRarity")
	ElseIf Option == DecayChanceOption
		SetInfoText("$EDDecayChance")
	ElseIf Option == FollowerDecayChanceOption
		SetInfoText("$EDFollowerDecayChance")
	ElseIf Option == NPCsLootOption
		SetInfoText("$EDNPCsLoot")
	ElseIf Option == TemperServiceOption
		SetInfoText("$EDTemperService")
	ElseIf Option == TemperDelayOption
		SetInfoText("$EDTemperDelay")
	ElseIf Option == TemperDelayRandomOption
		SetInfoText("$EDTemperDelayRandom")
	ElseIf Option == LootFilterOption
		SetInfoText("$EDLootFilter")
	ElseIf Option == LessLeveledLootOption
		SetInfoText("$EDLessLeveledLoot")
	ElseIf Option == TemperCostMultOption
		SetInfoText("$EDTemperCostMult")
	ElseIf Option == BreakChanceOption || Option == FollowerBreakChanceOption
		SetInfoText("$EDBreakChance")
	ElseIf Option == BreakTypeOption
		SetInfoText("$EDBreakType")
	ElseIf Option == BreakableItemsOption
		SetInfoText("$EDBreakWeaponArmor")
	ElseIf Option == MainWeapTypeOption || Option == MainWeapKeyOption || Option == OffWeapTypeOption || Option == OffWeapKeyOption || Option == ShieldKeyOption
		SetInfoText("$EDWeapSwitch")
	ElseIf Option == EquipImmuneOption
		SetInfoText("$EDEquipImmune")
	ElseIf Option == DegradeTextOption
		SetInfoText("$EDDegradeText")
	ElseIf Option == EquipmentRepairKitOption
		SetInfoText("$EDEquipmentRepairKits")
	ElseIf Option == ExamineKeyOption
		SetInfoText("$EDExamineKey")
	ElseIf Option == WidgetKeyOption
		SetInfoText("$EDWidgetKey")
	ElseIf Option == WidgetStyleOption
		SetInfoText("$EDWidgetStyle")
	ElseIf Option == WidgetPosOption || Option == WidgetAlphaOption || Option == WidgetXOffsetOption || Option == WidgetYOffsetOption || Option == WidgetOrientOption
		SetInfoText("$EDWidgetPos")
	ElseIf Option == WidgetItemsOption
		SetInfoText("$EDWidgetItems")
	ElseIf Option == WidgetContextualOption
		SetInfoText("$EDWidgetContextual")
	ElseIf Option == WidgetVisDelayOption
		SetInfoText("$EDWidgetVisDelay")
	EndIf
EndEvent

;====================================================================================

Event OnKeyDown(Int KeyCode)
	If !UI.IsTextInputEnabled() && !Utility.IsInMenuMode()
		UnregisterForKey(MainWeapKey)
		UnregisterForKey(OffWeapKey)
		UnregisterForKey(ShieldKey)
		UnregisterForKey(ExamineKey)
		UnregisterForKey(WidgetKey)
		If KeyCode == MainWeapKey
			_EDQuest.FindEquip(0, MainWeapType, 1)
		EndIf
		If KeyCode == OffWeapKey
			_EDQuest.FindEquip(0, OffWeapType, 2)
		EndIf
		If KeyCode == ShieldKey
			_EDQuest.FindEquip(0x00000200)
		EndIf
		If KeyCode == WidgetKey
			If WidgetVisDelay == 0.0
				_EDQuest.WidgetHide = !_EDQuest.WidgetHide
				SendModEvent("_ED_UIConfigured")
			ElseIf _EDQuest.WidgetHide
				_EDQuest.WidgetHide = False
				SendModEvent("_ED_UIConfigured")
			EndIf
		EndIf
		If KeyCode == ExamineKey
			_EDQuest.Examine()
			Utility.Wait(4.0)
		EndIf
		Utility.Wait(1.0)
		If MainWeapKey > -1
			RegisterForKey(MainWeapKey)
		EndIf
		If OffWeapKey > -1
			RegisterForKey(OffWeapKey)
		EndIf
		If ShieldKey > -1
			RegisterForKey(ShieldKey)
		EndIf
		If WidgetKey > -1
			If WidgetVisDelay != 0.0 && !_EDQuest.WidgetHide
				Utility.Wait(WidgetVisDelay - 1.0)
				If WidgetVisDelay != 0.0 && !_EDQuest.WidgetHide
					_EDQuest.WidgetHide = True
					SendModEvent("_ED_UIConfigured")
				EndIf
			EndIf
			RegisterForKey(WidgetKey)
		EndIf
		If ExamineKey > -1
			RegisterForKey(ExamineKey)
		EndIf
	EndIf
EndEvent

Event OnUpdate()
	If _EDQuest._EDContextualToggle.GetValue() as Int == 1
		_EDQuest.WidgetHide = True
		SendModEvent("_ED_UIConfigured")
	EndIf
EndEvent

Event OnConfigClose()
	ApplySettings()
EndEvent