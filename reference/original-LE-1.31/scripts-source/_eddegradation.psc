Scriptname _EDDegradation extends ReferenceAlias  

;====================================================================================

Keyword Property CraftingSmithingSharpeningWheel Auto
Keyword Property CraftingSmithingArmorTable Auto

_EDQuestScript Property _EDQuest Auto
_EDSkyUIConfig Property _EDSKConfigQuest Auto

Bool HeadSlot
Bool HitDelay
Bool HitWeapDelay
Bool ShieldEquipped
Bool BowEquipped
Bool CritHit
Bool AggressiveHit
Bool Whetstone

Float RWeaponDura
Float LWeaponDura
Float HeadDura
Float BodyDura
Float HandDura
Float FeetDura
Float ShieldDura

Int DecayChance

Actor targ

;====================================================================================						CHANGES HERE MUST ALSO BE MADE FOR FOLLOWERS

Function TemperDecay(Int WeaponSlot = 1, Int ArmorSlot = 0, Float DecayMag, Bool PowerAttacked = False)
	Int Chance = Utility.RandomInt(1, 10000)
	If Chance < DecayChance
		Bool BreakItem = False
		Float CurrentHealth = WornObject.GetItemHealthPercent(targ, WeaponSlot, ArmorSlot)
		If CurrentHealth < 1.0
			CurrentHealth = 1.0
		EndIf
		Float BreakChance = _EDQuest.PlayerBreakChance
		Float BaseHealth = (CurrentHealth * 10.0) as Int / 10.0
		If PowerAttacked
			DecayMag = DecayMag * 2.0
		EndIf
		If BreakChance > 0.0
			Int BreakCeiling
			If _EDQuest.RequiemInstalled
				BreakCeiling = Round((60.0 * Math.pow(BaseHealth, -3.0) * BreakChance * Math.pow(DecayMag * 10.0, 0.75) * 1550.0))
			Else
				BreakCeiling = Round(((96.149 * Math.pow(BaseHealth, 2.0)) - (345.42 * BaseHealth) + 309.27) * BreakChance * Math.pow(DecayMag * 10.0, 0.75) * 1550.0)
			EndIf
			If _EDQuest.BreakType == 0
				If CurrentHealth < 1.1 && Chance < BreakCeiling
					BreakItem = True
				EndIf
			ElseIf _EDQuest.BreakType == 1
				If CurrentHealth >= 1.1
					If (PowerAttacked || AggressiveHit || CritHit) && Chance < BreakCeiling
						BreakItem = True
					EndIf
				ElseIf Chance < BreakCeiling
					BreakItem = True
				EndIf
			ElseIf Chance < BreakCeiling
				BreakItem = True
			EndIf
		EndIf
		If BreakItem
			Form BrokeItem
			If ArmorSlot == 0
				If _EDQuest.BreakableItems < 2
					BrokeItem = targ.GetEquippedObject(WeaponSlot)
				EndIf
			Else
				If ArmorSlot == 0x00000200
					If _EDQuest.BreakableItems < 2
						BrokeItem = targ.GetWornForm(ArmorSlot)
					EndIf
				ElseIf (_EDQuest.BreakableItems == 0 || _EDQuest.BreakableItems == 2) && !targ.HasMagicEffectWithKeyword(_EDQuest.MagicArmorSpell)
					BrokeItem = targ.GetWornForm(ArmorSlot)
				EndIf
			EndIf
			If BrokeItem && !BrokeItem.HasKeyword(_EDQuest.MagicDisallowEnchanting) && !_EDQuest._EDNoBreakList.HasForm(BrokeItem) && StringUtil.Find(BrokeItem.GetName(), "Bound") as Int == -1
				If ArmorSlot == 0
					_EDQuest._EDWeaponBreakLP.Play(targ)
				Else
					_EDQuest._EDArmorBreakLP.Play(targ)
				EndIf
				_EDQuest.CheckMaterial(targ, BrokeItem, true)
				Debug.Notification(BrokeItem.GetName() + _EDQuest.ItemBreak)
			EndIf
		ElseIf CurrentHealth >= 1.00099
			Float NewHealth = CurrentHealth - (DecayMag * _EDQuest.PlayerDegMult)
			Float BufferHealth = (((NewHealth * 10.0) as Int) / 10.0) + 0.00099
			If NewHealth > BufferHealth
				NewHealth = BufferHealth
			EndIf
			_EDQuest.SetWidgetValues(WeaponSlot, ArmorSlot, NewHealth)
			If _EDQuest.DegradeText > 0
				Bool DisplayText = False
				Float BaseCurrentHealth = ((CurrentHealth * 10.0) as Int) / 10.0
				Float BaseNewHealth = ((NewHealth * 10.0) as Int) / 10.0
				If _EDQuest.DegradeText == 1
					If BaseNewHealth == 1.0 && BaseCurrentHealth == 1.1 && (BaseNewHealth < BaseCurrentHealth)
						If BreakChance > 0.0 && _EDQuest.BreakType == 0
							If ArmorSlot == 0
								Debug.Notification(targ.GetEquippedObject(WeaponSlot).GetName() + _EDQuest.DegradeUntemper)
							Else
								Debug.Notification(targ.GetWornForm(ArmorSlot).GetName() + _EDQuest.DegradeUntemper)
							EndIf
						Else
							DisplayText = True
						EndIf
					EndIf
				ElseIf (BaseNewHealth < BaseCurrentHealth)
					DisplayText = True
				EndIf
				If DisplayText
					If ArmorSlot == 0
						Debug.Notification(targ.GetEquippedObject(WeaponSlot).GetName() + _EDQuest.DegradeLevel)
					Else
						Debug.Notification(targ.GetWornForm(ArmorSlot).GetName() + _EDQuest.DegradeLevel)
					EndIf
				EndIf
			EndIf
			WornObject.SetItemHealthPercent(targ, WeaponSlot, ArmorSlot, NewHealth)
			;Debug.Notification(targ.GetEquippedObject(WeaponSlot).GetName() + " " + WornObject.GetItemHealthPercent(targ, WeaponSlot, ArmorSlot) + " " + NewHealth + " " + BufferHealth)								;DEBUG
		EndIf
	EndIf
EndFunction

Function SetBufferHealth(Int WeaponSlot = 1, Int ArmorSlot = 0, Bool NotEquipped = False)
	Float CurrentHealth
	Float ModdedHealth
	If !NotEquipped
		CurrentHealth = WornObject.GetItemHealthPercent(targ, WeaponSlot, ArmorSlot) * 100000.0
		Int iCurrentHealth = CurrentHealth as Int
		Float AdjHealth = (CurrentHealth / 10000.0) as Int * 10000.0
		If (CurrentHealth == AdjHealth || iCurrentHealth == AdjHealth) && CurrentHealth >= 110000.0
			If Whetstone
				CurrentHealth = CurrentHealth + 74.0
			Else
				CurrentHealth = CurrentHealth + 99.0
			EndIf
			WornObject.SetItemHealthPercent(targ, WeaponSlot, ArmorSlot, CurrentHealth / 100000.0)
		EndIf
	EndIf
	_EDQuest.SetWidgetValues(WeaponSlot, ArmorSlot, CurrentHealth / 100000.0)
	;Debug.Notification(targ.GetWornForm(ArmorSlot).GetName() + " " + WornObject.GetItemHealthPercent(targ, WeaponSlot, ArmorSlot))								;DEBUG
EndFunction

Function UpdateAllGearHealth()
	If _EDQuest.DecayChance > 0
		Int Type
		Weapon Mainhand = targ.GetEquippedObject(1) as Weapon
		If Mainhand
			SetBufferHealth(1)
			RWeaponDura = _EDQuest.CheckMaterial(targ, Mainhand)
			_EDQuest.MHWeapType = Mainhand.GetWeaponType() as Int
		Else
			SetBufferHealth(1, 0, true)
		EndIf
		Weapon Offhand = targ.GetEquippedObject(0) as Weapon
		If Offhand
			Type = Offhand.GetWeaponType() as Int
			_EDQuest.OHWeapType = Type
			If Type < 5
				SetBufferHealth(0)
				BowEquipped = False
			Else
				SetBufferHealth(0, 0, true)
				If Type == 7 || Type == 9
					BowEquipped = True		
				Else
					BowEquipped = False
				EndIf
			EndIf
			LWeaponDura = _EDQuest.CheckMaterial(targ, Offhand)
		Else
			SetBufferHealth(0, 0, true)
			BowEquipped = False
		EndIf
		Armor HeadPiece = targ.GetWornForm(0x00000001) as Armor
		If HeadPiece
			SetBufferHealth(1, 0x00000001)
			HeadDura = _EDQuest.CheckMaterial(targ, HeadPiece)
			HeadSlot = True
		Else
			HeadPiece = targ.GetWornForm(0x00000002) as Armor
			If HeadPiece
				SetBufferHealth(1, 0x00000002)
				HeadDura = _EDQuest.CheckMaterial(targ, HeadPiece)
			Else
				SetBufferHealth(1, 0x00000001, true)
			EndIf
			HeadSlot = False
		EndIf
		Armor Cuirass = targ.GetWornForm(0x00000004) as Armor
		If Cuirass
			SetBufferHealth(1, 0x00000004)
			BodyDura = _EDQuest.CheckMaterial(targ, Cuirass)
		Else
			SetBufferHealth(1, 0x00000004, true)
		EndIf
		Armor Gloves = targ.GetWornForm(0x00000008) as Armor
		If Gloves
			SetBufferHealth(1, 0x00000008)
			HandDura = _EDQuest.CheckMaterial(targ, Gloves)
		Else
			SetBufferHealth(1, 0x00000008, true)
		EndIf
		Armor Boots = targ.GetWornForm(0x00000080) as Armor
		If Boots
			SetBufferHealth(1, 0x00000080)
			FeetDura = _EDQuest.CheckMaterial(targ, Boots)
		Else
			SetBufferHealth(1, 0x00000080, true)
		EndIf
		Armor Shield = targ.GetWornForm(0x00000200) as Armor
		If Shield
			SetBufferHealth(1, 0x00000200)
			ShieldDura = _EDQuest.CheckMaterial(targ, Shield)
			_EDQuest.OHWeapType = 10
			ShieldEquipped = True
		Else
			If OffHand && Type > 4
				SetBufferHealth(1, 0x00000200, true)
			EndIf
			ShieldEquipped = False
		EndIf
		_EDQuest.UpdateStatus()
	EndIf
EndFunction

Int Function Round(Float i)
	If (i - (i as Int)) < 0.5
		Return (i as Int)
	Else
		Return (Math.Ceiling(i) as Int)
	EndIf
EndFunction

;====================================================================================						CHANGES HERE MUST ALSO BE MADE FOR FOLLOWERS

Event OnPlayerLoadGame()
	_EDQuest.Maintenance()
	UpdateAllGearHealth()
	RegisterForMenu("InventoryMenu")
	RegisterForMenu("BarterMenu")
	RegisterForMenu("Crafting Menu")
	If _EDQuest.EnchantRarity > 0 && _EDQuest.TemperRarity > 0
		RegisterforCrosshairRef()
	Else
		UnregisterforCrosshairRef()
	EndIf
	If _EDQuest.DecayChance > 0
		RegisterForAnimationEvent(targ, "weaponSwing")
		RegisterForAnimationEvent(targ, "weaponLeftSwing")
		RegisterForAnimationEvent(targ, "arrowRelease")
		RegisterForAnimationEvent(targ, "bashStop")
	Else
		UnregisterForAnimationEvent(targ, "weaponSwing")
		UnregisterForAnimationEvent(targ, "weaponLeftSwing")
		UnregisterForAnimationEvent(targ, "arrowRelease")
		UnregisterForAnimationEvent(targ, "bashStop")
	EndIf
EndEvent

Event OnInit()
	Utility.Wait(3.0)
	targ = _EDQuest.PlayerRef
	UpdateAllGearHealth()
	RegisterForSingleUpdateGameTime(24.0)
	RegisterForMenu("InventoryMenu")
	RegisterForMenu("BarterMenu")
	RegisterForMenu("Crafting Menu")
	RegisterforCrosshairRef()
	RegisterForAnimationEvent(targ, "weaponSwing")
	RegisterForAnimationEvent(targ, "weaponLeftSwing")
	RegisterForAnimationEvent(targ, "arrowRelease")
	RegisterForAnimationEvent(targ, "bashStop")
EndEvent

Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
	If (akBaseObject as Weapon) || (akBaseObject as Armor)
		UpdateAllGearHealth()
	EndIf
EndEvent

Event OnObjectUnequipped(Form akBaseObject, ObjectReference akReference)
	If (akBaseObject as Weapon) || (akBaseObject as Armor)
		Utility.Wait(0.5)
		UpdateAllGearHealth()
	EndIf
EndEvent

Event OnMenuClose(String MenuName)
	If _EDQuest.TemperService && (MenuName == "BarterMenu" || MenuName == "InventoryMenu")
		_EDQuest._EDNotEnoughGold.SetValue(0)
		_EDQuest.CalcTemperCosts(_EDQuest.LastVendor)
	EndIf
	If MenuName == "Crafting Menu"
		If targ.GetSitState() == 0
			Whetstone = True
			UpdateAllGearHealth()
		Else
			Whetstone = False
		EndIf
	EndIf
EndEvent

Event OnGetUp(ObjectReference akFurniture)
	If akFurniture.HasKeyword(CraftingSmithingSharpeningWheel) || akFurniture.HasKeyword(CraftingSmithingArmorTable)
		Whetstone = False
		UpdateAllGearHealth()
		_EDSKConfigQuest.SetContextual()
	EndIf
EndEvent

Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
	If !HitDelay && akAggressor && akSource as Weapon
		If akAggressor as Actor
			(akAggressor as Actor).AddSpell(_EDQuest._EDNPCSpell)
		EndIf
		DecayChance = _EDQuest.DecayChance
		CritHit = False
		If DecayChance > 0
			If abHitBlocked
				If ShieldEquipped
					TemperDecay(1, 0x00000200, 0.000085 * ShieldDura, abPowerAttack)	;shield
				Else
					CritHit = True
					TemperDecay(1, 0, 0.000091 * RWeaponDura, abPowerAttack)	;weapon
				EndIf
			Else
				If HeadSlot
					TemperDecay(1, 0x00000001, 0.000039 * HeadDura, abPowerAttack)	;head
				Else
					TemperDecay(1, 0x00000002, 0.000039 * HeadDura, abPowerAttack)	;head
				EndIf
				TemperDecay(1, 0x00000004, 0.000041 * BodyDura, abPowerAttack)	;body
				TemperDecay(1, 0x00000008, 0.000038 * HandDura, abPowerAttack)	;hands
				TemperDecay(1, 0x00000080, 0.000023 * FeetDura, abPowerAttack)	;feet
			EndIf
		EndIf
		HitDelay = True
		RegisterForSingleUpdate(3.0)
	EndIf
EndEvent
;																											CHANGES HERE MUST ALSO BE MADE FOR FOLLOWERS
Event OnAnimationEvent(ObjectReference aktarg, string EventName)
	If !HitWeapDelay
		Float WeaponDecay
		DecayChance = _EDQuest.DecayChance
		AggressiveHit = False
		If targ.GetAnimationVariableBool("bAllowRotation") || (BowEquipped && EventName == "bashStop")
			WeaponDecay = 0.000068
			AggressiveHit = True
		Else
			WeaponDecay = 0.000034
		EndIf
		If EventName == "weaponLeftSwing"
			TemperDecay(0, 0, WeaponDecay * LWeaponDura)
		ElseIf EventName != "bashStop" || BowEquipped
			TemperDecay(1, 0, WeaponDecay * RWeaponDura)
		EndIf
		HitWeapDelay = True
		If !HitDelay
			RegisterForSingleUpdate(2.0)
		EndIf
	EndIf
EndEvent

Event OnCrosshairRefChange(ObjectReference Ref)
	If Ref as Actor
		(Ref as Actor).AddSpell(_EDQuest._EDNPCSpell)
	EndIf
EndEvent

Event OnUpdateGameTime()
	If _EDQuest.CurrentLVL1Exp < 2160
		_EDQuest.LevelTemper()
		RegisterForSingleUpdateGameTime(24.0)
	EndIf
EndEvent

Event OnUpdate()
	HitDelay = False
	HitWeapDelay = False
	_EDQuest.UpdateStatus()
EndEvent