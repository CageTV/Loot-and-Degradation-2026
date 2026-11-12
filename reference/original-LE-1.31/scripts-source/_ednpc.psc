Scriptname _EDNPC extends activemagiceffect  

;====================================================================================

Armor CurrentArmor

Weapon CurrentWeapon
Weapon PreviousWeapon

_EDQuestScript Property _EDQuest Auto

Int CurrentLevel
Int LevelIncrementMult
Int LevelIncrementMult2
Int LevelIncrementMult3
Int LevelIncrementMult4
Int LevelIncrementMult5
Int TemperRarity
Int EnchantRarity

Float RandomDeg

Bool LessLeveledLoot

Actor targ

Import Math

;====================================================================================

Int Function Round(Float i)
	If (i - (i as Int)) < 0.5
		Return (i as Int)
	Else
		Return (Math.Ceiling(i) as Int)
	EndIf
EndFunction

Function SetRandomEnchant(Int WeaponSlot = 1, Int ArmorSlot = 0, FormList EnchantList, Int EnchantListSize, String[] NameList)
	If EnchantRarity > 0 && !WornObject.GetEnchantment(targ, WeaponSlot, ArmorSlot)
		Enchantment RandomEnchant
		Int RandomIndex
		Float EnchantMag
		Float MagMax = 70.0
		If !LessLeveledLoot
			If CurrentLevel <= LevelIncrementMult
				MagMax = 12.5
			ElseIf CurrentLevel <= LevelIncrementMult2
				MagMax = 15.0
			ElseIf CurrentLevel <= LevelIncrementMult3
				MagMax = 20.0
			ElseIf CurrentLevel <= LevelIncrementMult4
				MagMax = 30.0
			ElseIf CurrentLevel <= LevelIncrementMult5
				MagMax = 45.0
			EndIf
		EndIf
		If ArmorSlot == 0
			If !CurrentWeapon.GetEnchantment()
				If LessLeveledLoot
					RandomIndex = Ceiling(Utility.RandomInt(1, EnchantListSize * Round((EnchantRarity / 1.33) * 30.0 * pow(1.325, -0.0815 * CurrentLevel as Float)) * 3) / 100.0) - 1
				Else
					RandomIndex = Ceiling(Utility.RandomInt(1, EnchantListSize * Round((EnchantRarity / 1.33) * 30.0 * pow(1.325, -0.0815 * CurrentLevel as Float))) / 100.0) - 1
				EndIf
				RandomEnchant = EnchantList.GetAt(RandomIndex) as Enchantment
				If RandomEnchant
					EnchantMag = RandomEnchant.GetNthEffectMagnitude(0)
					If EnchantMag <= MagMax
						WornObject.SetEnchantment(targ, WeaponSlot, ArmorSlot, RandomEnchant, 500.0)
						Float RandomCharge = Utility.RandomFloat(0.0, 500.0)
						If WeaponSlot == 1
							targ.SetActorValue("RightItemCharge", RandomCharge)
						Else
							targ.SetActorValue("LeftItemCharge", RandomCharge)
						EndIf
						String Affix = NameList[RandomIndex]
						WornObject.SetDisplayName(targ, WeaponSlot, ArmorSlot, CurrentWeapon.GetName() + Affix)
					EndIf
				EndIf
			EndIf
		ElseIf !CurrentArmor.GetEnchantment()
			If LessLeveledLoot
				RandomIndex = Ceiling(Utility.RandomInt(1, EnchantListSize * Round(EnchantRarity * 30.0 * pow(1.325, -0.0815 * CurrentLevel as Float)) * 3) / 100.0) - 1
			Else
				RandomIndex = Ceiling(Utility.RandomInt(1, EnchantListSize * Round(EnchantRarity * 30.0 * pow(1.325, -0.0815 * CurrentLevel as Float))) / 100.0) - 1
			EndIf
			RandomEnchant = EnchantList.GetAt(RandomIndex) as Enchantment
			If RandomEnchant
				EnchantMag = RandomEnchant.GetNthEffectMagnitude(0)
				If EnchantMag <= MagMax
					WornObject.SetEnchantment(targ, WeaponSlot, ArmorSlot, RandomEnchant, 500.0)
					String Affix = NameList[RandomIndex]
					WornObject.SetDisplayName(targ, WeaponSlot, ArmorSlot, CurrentArmor.GetName() + Affix)
				EndIf
			EndIf
		EndIf
	EndIf
EndFunction

Function SetRandomTemp(Int WeaponSlot = 1, Int ArmorSlot = 0)
	If TemperRarity > 0
		Int RandomChance
		Int AdjustedLevel
		Int MaxChance
		If CurrentLevel <= LevelIncrementMult
			AdjustedLevel = CurrentLevel
		ElseIf CurrentLevel <= LevelIncrementMult2
			AdjustedLevel = CurrentLevel - LevelIncrementMult
		ElseIf CurrentLevel <= LevelIncrementMult3
			AdjustedLevel = CurrentLevel - LevelIncrementMult2
		ElseIf CurrentLevel <= LevelIncrementMult4
			AdjustedLevel = CurrentLevel - LevelIncrementMult3
		ElseIf CurrentLevel <= LevelIncrementMult5
			AdjustedLevel = CurrentLevel - LevelIncrementMult4
		Else
			AdjustedLevel = CurrentLevel - LevelIncrementMult5
		EndIf
		If ArmorSlot == 0
			MaxChance = Round((TemperRarity / 1.15) * LevelIncrementMult as Float * pow(AdjustedLevel as Float, -1.14))
		Else
			MaxChance = Round(TemperRarity * LevelIncrementMult as Float * pow(AdjustedLevel as Float, -1.14))
		EndIf
		RandomChance = Utility.RandomInt(1, MaxChance)
		Float RandomTemper = 1.0
		If LessLeveledLoot
			If RandomChance > 7500000
			ElseIf RandomChance > 3750000
				RandomTemper = 1.1
			ElseIf RandomChance > 1875000
				RandomTemper = 1.2
			ElseIf RandomChance > 937500
				RandomTemper = 1.3
			ElseIf RandomChance > 468750
				RandomTemper = 1.4
			ElseIf RandomChance > 234375
				RandomTemper = 1.5
			Else
				RandomTemper = 1.6
			EndIf
		Else
			If RandomChance <= 7500000
				RandomTemper = 1.1
			ElseIf RandomChance > Round((0.818 * MaxChance) + (AdjustedLevel * 150000.0 / LevelIncrementMult as Float / 8.0))
				RandomTemper = 0.9
			EndIf
		EndIf
		If CurrentLevel <= LevelIncrementMult
		ElseIf CurrentLevel <= LevelIncrementMult2
			RandomTemper += 0.1
		ElseIf CurrentLevel <= LevelIncrementMult3
			RandomTemper += 0.2
		ElseIf CurrentLevel <= LevelIncrementMult4
			RandomTemper += 0.3
		ElseIf CurrentLevel <= LevelIncrementMult5
			RandomTemper += 0.4
		Else
			RandomTemper += 0.5
		EndIf
		If RandomTemper > 1.0
			If RandomTemper > 1.7
				RandomTemper = 1.7
			EndIf
			WornObject.SetItemHealthPercent(targ, WeaponSlot, ArmorSlot, RandomTemper + RandomDeg)
			;Debug.Notification(targ.GetWornForm(ArmorSlot).GetName() + " " + RandomTemper + " " + WornObject.GetItemHealthPercent(targ, WeaponSlot, ArmorSlot))
		EndIf
	EndIf
EndFunction

Bool Function CheckEquipped(Int WeaponSlot = 1, Int ArmorSlot = 0, FormList EnchantList = None, Int EnchantListSize = 0, String[] NameList = None)
	If ArmorSlot == 0
		CurrentWeapon = targ.GetEquippedObject(WeaponSlot) as Weapon
		If CurrentWeapon && !CurrentWeapon.IsStaff() && !_EDQuest._EDIgnoreWeaponList.HasForm(CurrentWeapon) && !CurrentWeapon.HasKeyword(_EDQuest.MagicDisallowEnchanting) && StringUtil.Find(CurrentWeapon.GetName(), "Bound") as Int == -1
			SetRandomTemp(WeaponSlot, ArmorSlot)
			SetRandomEnchant(WeaponSlot, ArmorSlot, EnchantList, EnchantListSize, NameList)
			If CurrentWeapon.GetWeaponType() as Int > 4
				Return True
			EndIf
		EndIf
	Else
		CurrentArmor = targ.GetWornForm(ArmorSlot) as Armor
		If CurrentArmor
			If !_EDQuest._EDIgnoreArmorList.HasForm(CurrentArmor) && !CurrentArmor.HasKeyword(_EDQuest.MagicDisallowEnchanting) && StringUtil.Find(CurrentArmor.GetName(), "Bound") as Int == -1
				If !CurrentArmor.HasKeyword(_EDQuest.VendorItemClothing)
					SetRandomTemp(WeaponSlot, ArmorSlot)
					SetRandomEnchant(WeaponSlot, ArmorSlot, EnchantList, EnchantListSize, NameList)
				ElseIf ArmorSlot == 0x00000080
					SetRandomEnchant(WeaponSlot, ArmorSlot, EnchantList, EnchantListSize, NameList)
				EndIf
			EndIf
			Return True
		EndIf
	EndIf
	Return False
EndFunction

Bool Function DeathRandomTemper(Int WeaponSlot = 1, Int ArmorSlot = 0)
	Float CurrentHealth = 0.0
	If ArmorSlot == 0
		If targ.GetEquippedObject(WeaponSlot) as Weapon
			CurrentHealth = WornObject.GetItemHealthPercent(targ, WeaponSlot, ArmorSlot)
		EndIf
	ElseIf targ.GetWornForm(ArmorSlot) as Armor
		CurrentHealth = WornObject.GetItemHealthPercent(targ, WeaponSlot, ArmorSlot)
	EndIf
	If CurrentHealth >= 1.1
		WornObject.SetItemHealthPercent(targ, WeaponSlot, ArmorSlot, CurrentHealth + RandomDeg)
		Return True
	EndIf
	Return False
EndFunction

;====================================================================================
 
Event OnEffectStart(Actor akTarget, Actor akCaster)
	targ = akTarget
	TemperRarity = _EDQuest.TemperRarity
	EnchantRarity = _EDQuest.EnchantRarity
	LessLeveledLoot = _EDQuest.LessLeveledLoot
	If TemperRarity > 0 || EnchantRarity > 0
		If _EDQuest.DecayChance > 0
			RandomDeg = Utility.RandomFloat(0.00001, 0.00098)
		EndIf
		CurrentLevel = targ.GetLevel() as Int
		LevelIncrementMult = _EDQuest.LevelIncrementMult
		LevelIncrementMult2 = LevelIncrementMult * 2
		LevelIncrementMult3 = LevelIncrementMult * 3
		LevelIncrementMult4 = LevelIncrementMult * 4
		LevelIncrementMult5 = LevelIncrementMult * 5
		If CurrentLevel > (LevelIncrementMult * 6) - Round(LevelIncrementMult / 2)
			CurrentLevel = (LevelIncrementMult * 6) - Round(LevelIncrementMult / 2)
		ElseIf CurrentLevel < 1
			CurrentLevel = 1
		EndIf
		;CurrentLevel = 6																			;DEBUG
		If CheckEquipped(1, 0, _EDQuest._EDEnchantWeaponList, _EDQuest.EnchantWeaponListSize, _EDQuest.EnchantWeaponName)
		Else
			CheckEquipped(0, 0, _EDQuest._EDEnchantWeaponList, _EDQuest.EnchantWeaponListSize, _EDQuest.EnchantWeaponName)
		EndIf
		If CheckEquipped(1, 0x00000001, _EDQuest._EDEnchantHeadList, _EDQuest.EnchantHeadListSize, _EDQuest.EnchantHeadName)
		Else
			CheckEquipped(1, 0x00000002, _EDQuest._EDEnchantHeadList, _EDQuest.EnchantHeadListSize, _EDQuest.EnchantHeadName)
		EndIf
		CheckEquipped(1, 0x00000004, _EDQuest._EDEnchantBodyList, _EDQuest.EnchantBodyListSize, _EDQuest.EnchantBodyName)
		CheckEquipped(1, 0x00000008, _EDQuest._EDEnchantHandList, _EDQuest.EnchantHandListSize, _EDQuest.EnchantHandName)
		CheckEquipped(1, 0x00000080, _EDQuest._EDEnchantFeetList, _EDQuest.EnchantFeetListSize, _EDQuest.EnchantFeetName)
		CheckEquipped(1, 0x00000200, _EDQuest._EDEnchantShieldList, _EDQuest.EnchantShieldListSize, _EDQuest.EnchantShieldName)
	EndIf
	GoToState("WaitingToDie")
EndEvent

State WaitingToDie

	Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
		Utility.Wait(1.0)
		If (akBaseObject as Weapon) && (akBaseObject as Weapon) != CurrentWeapon && (akBaseObject as Weapon) != PreviousWeapon
			PreviousWeapon = CurrentWeapon
			CheckEquipped(1, 0, _EDQuest._EDEnchantWeaponList, _EDQuest.EnchantWeaponListSize, _EDQuest.EnchantWeaponName)
		EndIf
	EndEvent

	Event OnDying(Actor akKiller)
		If _EDQuest.DecayChance > 0 && _EDQuest.RequiemInstalled
			DeathRandomTemper(1, 0)
			DeathRandomTemper(0, 0)
			If DeathRandomTemper(1, 0x00000001)
			Else
				DeathRandomTemper(1, 0x00000002)
			EndIf
			DeathRandomTemper(1, 0x00000004)
			DeathRandomTemper(1, 0x00000008)
			DeathRandomTemper(1, 0x00000080)
			DeathRandomTemper(1, 0x00000200)
		EndIf
		GoToState("Dead")
	EndEvent

EndState

State Dead
EndState