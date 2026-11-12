Scriptname _EDFollower extends activemagiceffect  

;====================================================================================

_EDQuestScript Property _EDQuest Auto

Bool Equipped
Bool HeadSlot
Bool HitDelay
Bool HitWeapDelay
Bool ShieldEquipped
Bool BowEquipped
Bool CritHit
Bool AggressiveHit

Float RWeaponDura
Float LWeaponDura
Float HeadDura
Float BodyDura
Float HandDura
Float FeetDura
Float ShieldDura

Int DecayChance

Actor targ

;====================================================================================

Function TemperDecay(Int WeaponSlot = 1, Int ArmorSlot = 0, Float DecayMag, Bool PowerAttacked = False)
	Int Chance = Utility.RandomInt(1, 10000)
	If Chance < DecayChance
		Bool BreakItem = False
		Float CurrentHealth = WornObject.GetItemHealthPercent(targ, WeaponSlot, ArmorSlot)
		If CurrentHealth < 1.0
			CurrentHealth = 1.0
		EndIf
		Float BreakChance = _EDQuest.FollowerBreakChance
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
				;Debug.Notification(BrokeItem.GetName() + _EDQuest.ItemBreak)
			EndIf
		ElseIf CurrentHealth >= 1.00099
			Float NewHealth = CurrentHealth - (DecayMag * _EDQuest.FollowerDegMult)
			Float BufferHealth = (((NewHealth * 10.0) as Int) / 10.0) + 0.00099
			If NewHealth > BufferHealth
				NewHealth = BufferHealth
			EndIf
			WornObject.SetItemHealthPercent(targ, WeaponSlot, ArmorSlot, NewHealth)
			;Debug.Notification(targ.GetEquippedObject(WeaponSlot).GetName() + " " + WornObject.GetItemHealthPercent(targ, WeaponSlot, ArmorSlot))								;DEBUG
		EndIf
	EndIf
EndFunction

Function SetBufferHealth(Int WeaponSlot = 1, Int ArmorSlot = 0)
	Float CurrentHealth = WornObject.GetItemHealthPercent(targ, WeaponSlot, ArmorSlot) * 100000.0
	Int iCurrentHealth = CurrentHealth as Int
	Float AdjHealth = (CurrentHealth / 10000.0) as Int * 10000.0
	If (CurrentHealth == AdjHealth || iCurrentHealth == AdjHealth) && CurrentHealth >= 110000.0
		WornObject.SetItemHealthPercent(targ, WeaponSlot, ArmorSlot, (CurrentHealth + 99.0) / 100000.0)
	EndIf
	;Debug.Notification(targ.GetWornForm(ArmorSlot).GetName() + " " + WornObject.GetItemHealthPercent(targ, WeaponSlot, ArmorSlot))								;DEBUG
EndFunction

Function UpdateAllGearHealth()
	If _EDQuest.FollowerDecayChance > 0
		SetBufferHealth(1)
		RWeaponDura = _EDQuest.CheckMaterial(targ, targ.GetEquippedObject(1))
		Weapon Offhand = targ.GetEquippedObject(0) as Weapon
		If Offhand
			Int Type = Offhand.GetWeaponType() as Int
			If Type < 5
				SetBufferHealth(0)
				BowEquipped = False
			ElseIf Type == 7 || Type == 9
				BowEquipped = True		
			Else
				BowEquipped = False
			EndIf
			LWeaponDura = _EDQuest.CheckMaterial(targ, Offhand)
		Else
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
			EndIf
			HeadSlot = False
		EndIf
		SetBufferHealth(1, 0x00000004)
		BodyDura = _EDQuest.CheckMaterial(targ, targ.GetWornForm(0x00000004))
		SetBufferHealth(1, 0x00000008)
		HandDura = _EDQuest.CheckMaterial(targ, targ.GetWornForm(0x00000008))
		SetBufferHealth(1, 0x00000080)
		FeetDura = _EDQuest.CheckMaterial(targ, targ.GetWornForm(0x00000080))
		Armor Shield = targ.GetWornForm(0x00000200) as Armor
		If Shield
			SetBufferHealth(1, 0x00000200)
			ShieldDura = _EDQuest.CheckMaterial(targ, Shield)
			ShieldEquipped = True
		Else
			ShieldEquipped = False
		EndIf
	EndIf
EndFunction

Int Function Round(Float i)
	If (i - (i as Int)) < 0.5
		Return (i as Int)
	Else
		Return (Math.Ceiling(i) as Int)
	EndIf
EndFunction

;====================================================================================
 
Event OnEffectStart(Actor akTarget, Actor akCaster)
	targ = akTarget
	GoToState("Alive")
EndEvent

State Alive

	Event OnBeginState()
		UpdateAllGearHealth()
		RegisterForAnimationEvent(targ, "weaponSwing")
		RegisterForAnimationEvent(targ, "weaponLeftSwing")
		RegisterForAnimationEvent(targ, "arrowRelease")
		RegisterForAnimationEvent(targ, "bashStop")
	EndEvent

	Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
		Utility.Wait(0.5)
		If !Equipped && (akBaseItem as Weapon || akBaseItem as Armor)
			UpdateAllGearHealth()
		EndIf
	EndEvent

	Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
		Equipped = True
		If akBaseObject as Weapon || akBaseObject as Armor
			UpdateAllGearHealth()
		EndIf
		Utility.Wait(0.5)
		Equipped = False
	EndEvent

	Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
		If !HitDelay && akAggressor && akSource as Weapon
			DecayChance = _EDQuest.FollowerDecayChance
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

	Event OnAnimationEvent(ObjectReference aktarg, string EventName)
		If !HitWeapDelay
			Float WeaponDecay
			DecayChance = _EDQuest.FollowerDecayChance
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

	Event OnUpdate()
		HitDelay = False
		HitWeapDelay = False
	EndEvent

	Event OnEffectFinish(Actor akTarget, Actor akCaster)
		If _EDQuest.ModUpdated 
			targ.RemoveSpell(_EDQuest._EDFollowerSpell)
			Utility.Wait(0.1)
			targ.AddSpell(_EDQuest._EDFollowerSpell)
		Else
			Utility.Wait(1.5)
			targ.AddSpell(_EDQuest._EDFollowerSpell)
		EndIf
		GoToState("Dead")
	EndEvent

EndState

State Dead
EndState