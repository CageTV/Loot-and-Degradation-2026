Scriptname _EDQuestScript extends Quest  

;====================================================================================

Spell Property _EDPlayerSpell Auto
Spell Property _EDFollowerSpell Auto
Spell Property _EDNPCSpell Auto
Spell Property _EDNPCEmptySpell Auto

FormList Property _EDEnchantWeaponList Auto
FormList Property _EDEnchantArmorList Auto
FormList Property _EDEnchantHeadList Auto
FormList Property _EDEnchantBodyList Auto
FormList Property _EDEnchantHandList Auto
FormList Property _EDEnchantFeetList Auto
FormList Property _EDEnchantShieldList Auto
FormList Property _EDIgnoreWeaponList Auto
FormList Property _EDIgnoreArmorList Auto
FormList Property _EDExtraBSList Auto
FormList Property _EDNoBreakList Auto

LeveledItem Property LItemMiscHunterAnimalParts75 Auto
LeveledItem Property LItemBlacksmithMinimum Auto
LeveledItem Property LItemBlacksmithMineralsRaw75 Auto
LeveledItem Property LootToolRandom05 Auto

Form Gunmar
Form Hestla
Form Baldor

Faction Property _EDIgnoreFaction Auto

Race Property OrcRace Auto

GlobalVariable Property _EDFollowerToggle Auto
GlobalVariable Property _EDWhetstoneToggle Auto
GlobalVariable Property _EDHasEquippedRWeapon Auto
GlobalVariable Property _EDHasEquippedShield Auto
GlobalVariable Property _EDHasEquippedHead Auto
GlobalVariable Property _EDHasEquippedBody Auto
GlobalVariable Property _EDHasEquippedHand Auto
GlobalVariable Property _EDHasEquippedFeet Auto
GlobalVariable Property _EDRWeaponDiscount Auto
GlobalVariable Property _EDShieldDiscount Auto
GlobalVariable Property _EDHeadDiscount Auto
GlobalVariable Property _EDBodyDiscount Auto
GlobalVariable Property _EDHandDiscount Auto
GlobalVariable Property _EDFeetDiscount Auto
GlobalVariable Property _EDNotEnoughGold Auto
GlobalVariable Property _EDTemperLevel Auto
GlobalVariable Property _EDTemperType Auto
GlobalVariable Property _EDDoneCalc Auto
GlobalVariable Property _EDRequiemInstalled Auto
GlobalVariable Property _EDContextualToggle Auto

ObjectReference Property EmptyContainer Auto

Keyword Property VendorItemClothing Auto
Keyword Property MagicDisallowEnchanting Auto
Keyword Property MagicArmorSpell Auto
Keyword Property ActorTypeNPC Auto

Quest Property _EDNPCLootQuest Auto
Quest Property _EDServicesQuest Auto

MiscObject Property Gold001 Auto
MiscObject Property BlacksmithHammer01 Auto
MiscObject Property _EDEmptyItem Auto
MiscObject Property _EDWhetstoneRepair Auto
MiscObject Property _EDDwemerScrap Auto
MiscObject Property _EDEbonyScrap Auto
MiscObject Property _EDIronScrap Auto
MiscObject Property _EDMalaScrap Auto
MiscObject Property _EDMoonScrap Auto
MiscObject Property _EDOrichScrap Auto
MiscObject Property _EDSteelScrap Auto
MiscObject Property _EDChaurusScrap Auto
MiscObject Property _EDStalScrap Auto
MiscObject Property LeatherStrips Auto
MiscObject Property DragonScales Auto
MiscObject ChitinPlate

ConstructibleObject Property _EDRecipeIngotStalScrap Auto
ConstructibleObject Property _EDRecipeWhetstone Auto

Ingredient Property BoneMeal Auto

Class Property VendorFletcher Auto

Sound Property _EDTemperLP Auto
Sound Property _EDTemperFletcherLP Auto
Sound Property _EDTemperArmorLP Auto
Sound Property _EDTemperWeaponLP Auto
Sound Property _EDWeaponBreakLP Auto
Sound Property _EDArmorBreakLP Auto

Weapon CurrentRWeapon

Armor CurrentHead
Armor CurrentBody
Armor CurrentHand
Armor CurrentFeet
Armor CurrentShield

_EDSkyUIConfig Property _EDSKConfigQuest Auto
_EDServicesScript Property _EDServices Auto
WICourierScript Property WICourier Auto

Float Property fModVersion Auto
Float Property TemperCostMult = 1.0 Auto
Float Property PlayerBreakChance = 0.0 Auto
Float Property FollowerBreakChance = 0.0 Auto
Float Property ClothDura = 1.000001 Auto
Float Property LeatherWoodDura = 1.300001 Auto
Float Property IronDura = 1.200001 Auto
Float Property SteelDura = 1.100001 Auto
Float Property ElvenDura = 1.050001 Auto
Float Property FalmerDura = 0.900001 Auto
Float Property DwarvenDura = 0.850001 Auto
Float Property GlassDura = 0.800001 Auto
Float Property OrcishDura = 0.700001 Auto
Float Property DragonDura = 0.600001 Auto
Float Property DaedricEbonyDura = 0.550001 Auto
Float Property PlayerDegMult = 1.0 Auto
Float Property FollowerDegMult = 1.0 Auto
Float Property WidgetAlpha = 100.0 Auto

Int[] Property EquipHealth Auto
Int[] Property TemperExp Auto
Int Property EnchantWeaponListSize Auto
Int Property EnchantArmorListSize Auto
Int Property EnchantHeadListSize Auto
Int Property EnchantBodyListSize Auto
Int Property EnchantHandListSize Auto
Int Property EnchantFeetListSize Auto
Int Property EnchantShieldListSize Auto
Int Property EnchantRarity = 50 Auto
Int Property TemperRarity = 12500000 Auto
Int Property LevelIncrementMult = 8 Auto
Int Property FollowerDecayChance = 0 Auto
Int Property DecayChance = 6667 Auto
Int Property TemperDelay = 0 Auto
Int Property LootFilter = 25 Auto
Int Property CurrentLVL1Exp = 0 Auto
Int Property BreakType = 0 Auto
Int Property BreakableItems = 0 Auto
Int Property TemperMode Auto
Int Property DegradeText Auto
Int Property MHWeapType Auto
Int Property OHWeapType Auto
Int Property WidgetPos = 0 Auto
Int Property WidgetXOffset Auto
Int Property WidgetYOffset Auto
Int Property WidgetStyle = 1 Auto
Int Property WidgetItems Auto
Int Property WidgetOrient Auto
Int CurrentGold
Int CurrentLVL2Exp = 0
Int CurrentLVL3Exp = 0
Int CurrentLVL4Exp = 0
Int CurrentLVL5Exp = 0
Int SpeechSkill

Bool Property SkyInstalled Auto
Bool Property SKSEInstalled Auto
Bool Property ModUpdated Auto
Bool Property ModRestarted Auto
Bool Property NPCsLoot = True Auto
Bool Property TemperService = True Auto
Bool Property LessLeveledLoot Auto
Bool Property HeadSlot Auto
Bool Property IsFletcher Auto
Bool Property TemperDelayRandom Auto
Bool Property WhetstonesAdded Auto
Bool Property RequiemInstalled Auto
Bool Property WidgetVisible Auto
Bool Property WidgetHide Auto
Bool FFInstalled
Bool SICInstalled
Bool DGInstalled
Bool DBInstalled

String[] Property EquipState Auto
String[] Property EnchantWeaponName Auto
String[] Property EnchantArmorName Auto
String[] Property EnchantArmorName2 Auto
String[] Property EnchantHeadName Auto
String[] Property EnchantBodyName Auto
String[] Property EnchantHandName Auto
String[] Property EnchantFeetName Auto
String[] Property EnchantShieldName Auto

String Property ItemBreak = " has broken into pieces." Auto
String Property AddImmune = " is now immune to breaking." Auto
String Property RemoveImmune = " is no longer immune to breaking." Auto
String Property DegradeLevel = " has degraded in quality." Auto
String Property DegradeUntemper = " is now vulnerable to breaking." Auto
String Property NoImmune = " is immune and cannot be changed." Auto
String Property RepairCombat = "Equipment cannot be improved while in combat." Auto
String Property RepairSneak = "Equipment cannot be improved while sneaking." Auto
String Property RepairMount = "Equipment cannot be improved while mounted." Auto
String Property RepairSwim = "Equipment cannot be improved while swimming." Auto
String Property NoEquip = "This item is not equipped." Auto
String NoDegrade = "This item cannot be degraded further."
String ofText = " of "
String UntemperedState = "Untempered"
String FineState = " Fine"
String SuperiorState = " Superior"
String ExquisiteState = " Exquisite"
String FlawlessState = " Flawless"
String EpicState = " Epic"
String LegendaryState = " Legendary"
String RequiemCompat = "Loot + Degradation: NPC tempered loot disabled in favor of Requiem's."
String SKSEWarn = "Loot + Degradation: SKSE 1.7.0+ not detected. Please uninstall this mod until the correct SKSE version has been properly installed."
String UpdateNote = "Loot + Degradation: Updated to"

ActorBase[] Property TemperPeople Auto
ActorBase Property LastVendor Auto
ActorBase Property EorlundGrayMane Auto

Actor Property PlayerRef Auto
Actor targ

;====================================================================================

Function SetUpNames()
	EnchantWeaponName = New String[128]
	EnchantWeaponName[0] = " of Absorption"
	EnchantWeaponName[1] = " of Consuming"
	EnchantWeaponName[2] = " of Devouring"
	EnchantWeaponName[3] = " of Leeching"
	EnchantWeaponName[4] = " of the Vampire"
	EnchantWeaponName[5] = " of Siphoning"
	EnchantWeaponName[6] = " of Harrowing"
	EnchantWeaponName[7] = " of Winnowing"
	EnchantWeaponName[8] = " of Evoking"
	EnchantWeaponName[9] = " of the Sorcerer"
	EnchantWeaponName[10] = " of Gleaning"
	EnchantWeaponName[11] = " of Reaping"
	EnchantWeaponName[12] = " of Harvesting"
	EnchantWeaponName[13] = " of Garnering"
	EnchantWeaponName[14] = " of Subsuming"
	EnchantWeaponName[15] = " of Banishing"
	EnchantWeaponName[16] = " of Expelling"
	EnchantWeaponName[17] = " of Annihilating"
	EnchantWeaponName[18] = " of Dismay"
	EnchantWeaponName[19] = " of Cowardice"
	EnchantWeaponName[20] = " of Fear"
	EnchantWeaponName[21] = " of Despair"
	EnchantWeaponName[22] = " of Dread"
	EnchantWeaponName[23] = " of Terror"
	EnchantWeaponName[24] = " of Embers"
	EnchantWeaponName[25] = " of Burning"
	EnchantWeaponName[26] = " of Scorching"
	EnchantWeaponName[27] = " of Fire"
	EnchantWeaponName[28] = " of the Blaze"
	EnchantWeaponName[29] = " of the Inferno"
	EnchantWeaponName[30] = " of Cold"
	EnchantWeaponName[31] = " of Frost"
	EnchantWeaponName[32] = " of Ice"
	EnchantWeaponName[33] = " of Freezing"
	EnchantWeaponName[34] = " of Blizzards"
	EnchantWeaponName[35] = " of Winter"
	EnchantWeaponName[36] = " of Sapping"
	EnchantWeaponName[37] = " of Draining"
	EnchantWeaponName[38] = " of Diminishing"
	EnchantWeaponName[39] = " of Depleting"
	EnchantWeaponName[40] = " of Enervating"
	EnchantWeaponName[41] = " of Nullifying"
	EnchantWeaponName[42] = " of Stunning"
	EnchantWeaponName[43] = " of Immobilizing"
	EnchantWeaponName[44] = " of Petrifying"
	EnchantWeaponName[45] = " of Sparks"
	EnchantWeaponName[46] = " of Arcing"
	EnchantWeaponName[47] = " of Shocks"
	EnchantWeaponName[48] = " of Thunderbolts"
	EnchantWeaponName[49] = " of Lightning"
	EnchantWeaponName[50] = " of Storms"
	EnchantWeaponName[51] = " of Souls"
	EnchantWeaponName[52] = " of Soul Snares"
	EnchantWeaponName[53] = " of Binding"
	EnchantWeaponName[54] = " of Animus"
	EnchantWeaponName[55] = " of Malediction"
	EnchantWeaponName[56] = " of Damnation"
	EnchantWeaponName[57] = " of Fatigue"
	EnchantWeaponName[58] = " of Weariness"
	EnchantWeaponName[59] = " of Torpor"
	EnchantWeaponName[60] = " of Debilitation"
	EnchantWeaponName[61] = " of Lethargy"
	EnchantWeaponName[62] = " of Exhaustion"
	EnchantWeaponName[63] = " of the Blessed"
	EnchantWeaponName[64] = " of the Sanctified"
	EnchantWeaponName[65] = " of the Reverent"
	EnchantWeaponName[66] = " of the Hallowed"
	EnchantWeaponName[67] = " of the Virtuous"
	EnchantWeaponName[68] = " of the Holy"

	EnchantArmorName = New String[128]
	EnchantArmorName[0] = " of Minor Alchemy"
	EnchantArmorName[1] = " of Alchemy"
	EnchantArmorName[2] = " of Major Alchemy"
	EnchantArmorName[3] = " of Eminent Alchemy"
	EnchantArmorName[4] = " of Extreme Alchemy"
	EnchantArmorName[5] = " of Peerless Alchemy"
	EnchantArmorName[6] = " of Minor Alteration"
	EnchantArmorName[7] = " of Alteration"
	EnchantArmorName[8] = " of Major Alteration"
	EnchantArmorName[9] = " of Eminent Alteration"
	EnchantArmorName[10] = " of Extreme Alteration"
	EnchantArmorName[11] = " of Peerless Alteration"
	EnchantArmorName[12] = " of Minor Blocking"
	EnchantArmorName[13] = " of Blocking"
	EnchantArmorName[14] = " of Major Blocking"
	EnchantArmorName[15] = " of Eminent Blocking"
	EnchantArmorName[16] = " of Extreme Blocking"
	EnchantArmorName[17] = " of Peerless Blocking"
	EnchantArmorName[18] = " of Lifting"
	EnchantArmorName[19] = " of Hauling"
	EnchantArmorName[20] = " of Strength"
	EnchantArmorName[21] = " of Brawn"
	EnchantArmorName[22] = " of the Ox"
	EnchantArmorName[23] = " of the Mammoth"
	EnchantArmorName[24] = " of Minor Conjuration"
	EnchantArmorName[25] = " of Conjuration"
	EnchantArmorName[26] = " of Major Conjuration"
	EnchantArmorName[27] = " of Eminent Conjuration"
	EnchantArmorName[28] = " of Extreme Conjuration"
	EnchantArmorName[29] = " of Peerless Conjuration"
	EnchantArmorName[30] = " of Minor Destruction"
	EnchantArmorName[31] = " of Destruction"
	EnchantArmorName[32] = " of Major Destruction"
	EnchantArmorName[33] = " of Eminent Destruction"
	EnchantArmorName[34] = " of Extreme Destruction"
	EnchantArmorName[35] = " of Peerless Destruction"
	EnchantArmorName[36] = " of Remedy"
	EnchantArmorName[37] = " of Mending"
	EnchantArmorName[38] = " of Regeneration"
	EnchantArmorName[39] = " of Revival"
	EnchantArmorName[40] = " of Minor Health"
	EnchantArmorName[41] = " of Health"
	EnchantArmorName[42] = " of Major Health"
	EnchantArmorName[43] = " of Eminent Health"
	EnchantArmorName[44] = " of Extreme Health"
	EnchantArmorName[45] = " of Peerless Health"
	EnchantArmorName[46] = " of Minor Illusion"
	EnchantArmorName[47] = " of Illusion"
	EnchantArmorName[48] = " of Major Illusion"
	EnchantArmorName[49] = " of Eminent Illusion"
	EnchantArmorName[50] = " of Extreme Illusion"
	EnchantArmorName[51] = " of Peerless Illusion"
	EnchantArmorName[52] = " of Minor Lockpicking"
	EnchantArmorName[53] = " of Lockpicking"
	EnchantArmorName[54] = " of Major Lockpicking"
	EnchantArmorName[55] = " of Eminent Lockpicking"
	EnchantArmorName[56] = " of Extreme Lockpicking"
	EnchantArmorName[57] = " of Peerless Lockpicking"
	EnchantArmorName[58] = " of Minor Magicka"
	EnchantArmorName[59] = " of Magicka"
	EnchantArmorName[60] = " of Major Magicka"
	EnchantArmorName[61] = " of Eminent Magicka"
	EnchantArmorName[62] = " of Extreme Magicka"
	EnchantArmorName[63] = " of Peerless Magicka"
	EnchantArmorName[64] = " of Recharging"
	EnchantArmorName[65] = " of Replenishing"
	EnchantArmorName[66] = " of Resurgence"
	EnchantArmorName[67] = " of Recovery"
	EnchantArmorName[68] = " of Minor Archery"
	EnchantArmorName[69] = " of Archery"
	EnchantArmorName[70] = " of Major Archery"
	EnchantArmorName[71] = " of Eminent Archery"
	EnchantArmorName[72] = " of Extreme Archery"
	EnchantArmorName[73] = " of Peerless Archery"
	EnchantArmorName[74] = " of Minor Wielding"
	EnchantArmorName[75] = " of Wielding"
	EnchantArmorName[76] = " of Major Wielding"
	EnchantArmorName[77] = " of Eminent Wielding"
	EnchantArmorName[78] = " of Extreme Wielding"
	EnchantArmorName[79] = " of Peerless Wielding"
	EnchantArmorName[80] = " of Minor Deft Hands"
	EnchantArmorName[81] = " of Deft Hands"
	EnchantArmorName[82] = " of Major Deft Hands"
	EnchantArmorName[83] = " of Eminent Deft Hands"
	EnchantArmorName[84] = " of Extreme Deft Hands"
	EnchantArmorName[85] = " of Peerless Deft Hands"
	EnchantArmorName[86] = " of Minor Restoration"
	EnchantArmorName[87] = " of Restoration"
	EnchantArmorName[88] = " of Major Restoration"
	EnchantArmorName[89] = " of Eminent Restoration"
	EnchantArmorName[90] = " of Extreme Restoration"
	EnchantArmorName[91] = " of Peerless Restoration"
	EnchantArmorName[92] = " of Minor Smithing"
	EnchantArmorName[93] = " of Smithing"
	EnchantArmorName[94] = " of Major Smithing"
	EnchantArmorName[95] = " of Eminent Smithing"
	EnchantArmorName[96] = " of Extreme Smithing"
	EnchantArmorName[97] = " of Peerless Smithing"
	EnchantArmorName[98] = " of Minor Sneaking"
	EnchantArmorName[99] = " of Sneaking"
	EnchantArmorName[100] = " of Major Sneaking"
	EnchantArmorName[101] = " of Eminent Sneaking"
	EnchantArmorName[102] = " of Extreme Sneaking"
	EnchantArmorName[103] = " of Peerless Sneaking"
	EnchantArmorName[104] = " of Minor Stamina"
	EnchantArmorName[105] = " of Stamina"
	EnchantArmorName[106] = " of Major Stamina"
	EnchantArmorName[107] = " of Eminent Stamina"
	EnchantArmorName[108] = " of Extreme Stamina"
	EnchantArmorName[109] = " of Peerless Stamina"
	EnchantArmorName[110] = " of Recuperation"
	EnchantArmorName[111] = " of Rejuvenation"
	EnchantArmorName[112] = " of Invigoration"
	EnchantArmorName[113] = " of Renewal"
	EnchantArmorName[114] = " of Minor Striking"
	EnchantArmorName[115] = " of Striking"
	EnchantArmorName[116] = " of Major Striking"
	EnchantArmorName[117] = " of Extreme Striking"
	EnchantArmorName[118] = " of Sure Grip"
	EnchantArmorName[119] = " of Peerless Sure Grip"
	EnchantArmorName[120] = " of Muffling"
	EnchantArmorName[121] = " of Resist Fire"
	EnchantArmorName[122] = " of Waning Fire"
	EnchantArmorName[123] = " of Dwindling Flames"
	EnchantArmorName[124] = " of Flame Suppression"
	EnchantArmorName[125] = " of Fire Abatement"
	EnchantArmorName[126] = " of the Firewalker"
	EnchantArmorName[127] = " of Resist Frost"

	EnchantArmorName2 = New String[128]
	EnchantArmorName2[0] = " of Waning Frost"			;128
	EnchantArmorName2[1] = " of Dwindling Frost"		;129
	EnchantArmorName2[2] = " of Frost Suppression"		;130
	EnchantArmorName2[3] = " of Frost Abatement"		;131
	EnchantArmorName2[4] = " of Warmth"					;132
	EnchantArmorName2[5] = " of Resist Magic"			;133
	EnchantArmorName2[6] = " of Dwindling Magic"		;134
	EnchantArmorName2[7] = " of Magic Suppression"		;135
	EnchantArmorName2[8] = " of Magic Abatement"		;136
	EnchantArmorName2[9] = " of Nullification"			;137
	EnchantArmorName2[10] = " of the Spellbreaker"		;138
	EnchantArmorName2[11] = " of Resist Shock"			;139
	EnchantArmorName2[12] = " of Waning Shock"			;140
	EnchantArmorName2[13] = " of Dwindling Shock"		;141
	EnchantArmorName2[14] = " of Shock Suppression"		;142
	EnchantArmorName2[15] = " of Shock Abatement"		;143
	EnchantArmorName2[16] = " of Grounding"				;144
	EnchantArmorName2[17] = " of Waterbreathing"		;145
	EnchantArmorName2[18] = " of Minor Brawling"		;146
	EnchantArmorName2[19] = " of Brawling"				;147
	EnchantArmorName2[20] = " of Major Brawling"		;148
	EnchantArmorName2[21] = " of Eminent Brawling"		;149
	EnchantArmorName2[22] = " of Extreme Brawling"		;150
	EnchantArmorName2[23] = " of Peerless Brawling"		;151
	EnchantArmorName2[24] = " of the Minor Squire"		;152
	EnchantArmorName2[25] = " of the Squire"			;153
	EnchantArmorName2[26] = " of the Major Squire"		;154
	EnchantArmorName2[27] = " of the Eminent Squire"	;155
	EnchantArmorName2[28] = " of the Extreme Squire"	;156
	EnchantArmorName2[29] = " of the Peerless Squire"	;157
	EnchantArmorName2[30] = " of the Minor Knight"		;158
	EnchantArmorName2[31] = " of the Knight"			;159
	EnchantArmorName2[32] = " of the Major Knight"		;160
	EnchantArmorName2[33] = " of the Eminent Knight"	;161
	EnchantArmorName2[34] = " of the Extreme Knight"	;162
	EnchantArmorName2[35] = " of the Peerless Knight"	;163

	EnchantHeadName = New String[128]
	EnchantHeadName[0] = EnchantArmorName[0]
	EnchantHeadName[1] = EnchantArmorName[1]
	EnchantHeadName[2] = EnchantArmorName[2]
	EnchantHeadName[3] = EnchantArmorName[3]
	EnchantHeadName[4] = EnchantArmorName[4]
	EnchantHeadName[5] = EnchantArmorName[5]
	EnchantHeadName[6] = EnchantArmorName[6]
	EnchantHeadName[7] = EnchantArmorName[7]
	EnchantHeadName[8] = EnchantArmorName[8]
	EnchantHeadName[9] = EnchantArmorName[9]
	EnchantHeadName[10] = EnchantArmorName[10]
	EnchantHeadName[11] = EnchantArmorName[11]
	EnchantHeadName[12] = EnchantArmorName[24]
	EnchantHeadName[13] = EnchantArmorName[25]
	EnchantHeadName[14] = EnchantArmorName[26]
	EnchantHeadName[15] = EnchantArmorName[27]
	EnchantHeadName[16] = EnchantArmorName[28]
	EnchantHeadName[17] = EnchantArmorName[29]
	EnchantHeadName[18] = EnchantArmorName[30]
	EnchantHeadName[19] = EnchantArmorName[31]
	EnchantHeadName[20] = EnchantArmorName[32]
	EnchantHeadName[21] = EnchantArmorName[33]
	EnchantHeadName[22] = EnchantArmorName[34]
	EnchantHeadName[23] = EnchantArmorName[35]
	EnchantHeadName[24] = EnchantArmorName[46]
	EnchantHeadName[25] = EnchantArmorName[47]
	EnchantHeadName[26] = EnchantArmorName[48]
	EnchantHeadName[27] = EnchantArmorName[49]
	EnchantHeadName[28] = EnchantArmorName[50]
	EnchantHeadName[29] = EnchantArmorName[51]
	EnchantHeadName[30] = EnchantArmorName[52]
	EnchantHeadName[31] = EnchantArmorName[53]
	EnchantHeadName[32] = EnchantArmorName[54]
	EnchantHeadName[33] = EnchantArmorName[55]
	EnchantHeadName[34] = EnchantArmorName[56]
	EnchantHeadName[35] = EnchantArmorName[57]
	EnchantHeadName[36] = EnchantArmorName[58]
	EnchantHeadName[37] = EnchantArmorName[59]
	EnchantHeadName[38] = EnchantArmorName[60]
	EnchantHeadName[39] = EnchantArmorName[61]
	EnchantHeadName[40] = EnchantArmorName[62]
	EnchantHeadName[41] = EnchantArmorName[63]
	EnchantHeadName[42] = EnchantArmorName[64]
	EnchantHeadName[43] = EnchantArmorName[65]
	EnchantHeadName[44] = EnchantArmorName[66]
	EnchantHeadName[45] = EnchantArmorName[67]
	EnchantHeadName[46] = EnchantArmorName[68]
	EnchantHeadName[47] = EnchantArmorName[69]
	EnchantHeadName[48] = EnchantArmorName[70]
	EnchantHeadName[49] = EnchantArmorName[71]
	EnchantHeadName[50] = EnchantArmorName[72]
	EnchantHeadName[51] = EnchantArmorName[73]
	EnchantHeadName[52] = EnchantArmorName[86]
	EnchantHeadName[53] = EnchantArmorName[87]
	EnchantHeadName[54] = EnchantArmorName[88]
	EnchantHeadName[55] = EnchantArmorName[89]
	EnchantHeadName[56] = EnchantArmorName[90]
	EnchantHeadName[57] = EnchantArmorName[91]
	EnchantHeadName[58] = EnchantArmorName2[17]

	EnchantBodyName = New String[128]
	EnchantBodyName[0] = EnchantArmorName[6]
	EnchantBodyName[1] = EnchantArmorName[7]
	EnchantBodyName[2] = EnchantArmorName[8]
	EnchantBodyName[3] = EnchantArmorName[9]
	EnchantBodyName[4] = EnchantArmorName[10]
	EnchantBodyName[5] = EnchantArmorName[11]
	EnchantBodyName[6] = EnchantArmorName[24]
	EnchantBodyName[7] = EnchantArmorName[25]
	EnchantBodyName[8] = EnchantArmorName[26]
	EnchantBodyName[9] = EnchantArmorName[27]
	EnchantBodyName[10] = EnchantArmorName[28]
	EnchantBodyName[11] = EnchantArmorName[29]
	EnchantBodyName[12] = EnchantArmorName[30]
	EnchantBodyName[13] = EnchantArmorName[31]
	EnchantBodyName[14] = EnchantArmorName[32]
	EnchantBodyName[15] = EnchantArmorName[33]
	EnchantBodyName[16] = EnchantArmorName[34]
	EnchantBodyName[17] = EnchantArmorName[35]
	EnchantBodyName[18] = EnchantArmorName[36]
	EnchantBodyName[19] = EnchantArmorName[37]
	EnchantBodyName[20] = EnchantArmorName[38]
	EnchantBodyName[21] = EnchantArmorName[39]
	EnchantBodyName[22] = EnchantArmorName[40]
	EnchantBodyName[23] = EnchantArmorName[41]
	EnchantBodyName[24] = EnchantArmorName[42]
	EnchantBodyName[25] = EnchantArmorName[43]
	EnchantBodyName[26] = EnchantArmorName[44]
	EnchantBodyName[27] = EnchantArmorName[45]
	EnchantBodyName[28] = EnchantArmorName[46]
	EnchantBodyName[29] = EnchantArmorName[47]
	EnchantBodyName[30] = EnchantArmorName[48]
	EnchantBodyName[31] = EnchantArmorName[49]
	EnchantBodyName[32] = EnchantArmorName[50]
	EnchantBodyName[33] = EnchantArmorName[51]
	EnchantBodyName[34] = EnchantArmorName[64]
	EnchantBodyName[35] = EnchantArmorName[65]
	EnchantBodyName[36] = EnchantArmorName[66]
	EnchantBodyName[37] = EnchantArmorName[67]
	EnchantBodyName[38] = EnchantArmorName[86]
	EnchantBodyName[39] = EnchantArmorName[87]
	EnchantBodyName[40] = EnchantArmorName[88]
	EnchantBodyName[41] = EnchantArmorName[89]
	EnchantBodyName[42] = EnchantArmorName[90]
	EnchantBodyName[43] = EnchantArmorName[91]
	EnchantBodyName[44] = EnchantArmorName[92]
	EnchantBodyName[45] = EnchantArmorName[93]
	EnchantBodyName[46] = EnchantArmorName[94]
	EnchantBodyName[47] = EnchantArmorName[95]
	EnchantBodyName[48] = EnchantArmorName[96]
	EnchantBodyName[49] = EnchantArmorName[97]
	EnchantBodyName[50] = EnchantArmorName[104]
	EnchantBodyName[51] = EnchantArmorName[105]
	EnchantBodyName[52] = EnchantArmorName[106]
	EnchantBodyName[53] = EnchantArmorName[107]
	EnchantBodyName[54] = EnchantArmorName[108]
	EnchantBodyName[55] = EnchantArmorName[109]
	EnchantBodyName[56] = EnchantArmorName[110]
	EnchantBodyName[57] = EnchantArmorName[111]
	EnchantBodyName[58] = EnchantArmorName[112]
	EnchantBodyName[59] = EnchantArmorName[113]
	EnchantBodyName[60] = EnchantArmorName2[24]
	EnchantBodyName[61] = EnchantArmorName2[25]
	EnchantBodyName[62] = EnchantArmorName2[26]
	EnchantBodyName[63] = EnchantArmorName2[27]
	EnchantBodyName[64] = EnchantArmorName2[28]
	EnchantBodyName[65] = EnchantArmorName2[29]
	EnchantBodyName[66] = EnchantArmorName2[30]
	EnchantBodyName[67] = EnchantArmorName2[31]
	EnchantBodyName[68] = EnchantArmorName2[32]
	EnchantBodyName[69] = EnchantArmorName2[33]
	EnchantBodyName[70] = EnchantArmorName2[34]
	EnchantBodyName[71] = EnchantArmorName2[35]

	EnchantHandName = New String[128]
	EnchantHandName[0] = EnchantArmorName[0]
	EnchantHandName[1] = EnchantArmorName[1]
	EnchantHandName[2] = EnchantArmorName[2]
	EnchantHandName[3] = EnchantArmorName[3]
	EnchantHandName[4] = EnchantArmorName[4]
	EnchantHandName[5] = EnchantArmorName[5]
	EnchantHandName[6] = EnchantArmorName[12]
	EnchantHandName[7] = EnchantArmorName[13]
	EnchantHandName[8] = EnchantArmorName[14]
	EnchantHandName[9] = EnchantArmorName[15]
	EnchantHandName[10] = EnchantArmorName[16]
	EnchantHandName[11] = EnchantArmorName[17]
	EnchantHandName[12] = EnchantArmorName[18]
	EnchantHandName[13] = EnchantArmorName[19]
	EnchantHandName[14] = EnchantArmorName[20]
	EnchantHandName[15] = EnchantArmorName[21]
	EnchantHandName[16] = EnchantArmorName[22]
	EnchantHandName[17] = EnchantArmorName[23]
	EnchantHandName[18] = EnchantArmorName[52]
	EnchantHandName[19] = EnchantArmorName[53]
	EnchantHandName[20] = EnchantArmorName[54]
	EnchantHandName[21] = EnchantArmorName[55]
	EnchantHandName[22] = EnchantArmorName[56]
	EnchantHandName[23] = EnchantArmorName[57]
	EnchantHandName[24] = EnchantArmorName[58]
	EnchantHandName[25] = EnchantArmorName[59]
	EnchantHandName[26] = EnchantArmorName[60]
	EnchantHandName[27] = EnchantArmorName[61]
	EnchantHandName[28] = EnchantArmorName[62]
	EnchantHandName[29] = EnchantArmorName[63]
	EnchantHandName[30] = EnchantArmorName[68]
	EnchantHandName[31] = EnchantArmorName[69]
	EnchantHandName[32] = EnchantArmorName[70]
	EnchantHandName[33] = EnchantArmorName[71]
	EnchantHandName[34] = EnchantArmorName[72]
	EnchantHandName[35] = EnchantArmorName[73]
	EnchantHandName[36] = EnchantArmorName[74]
	EnchantHandName[37] = EnchantArmorName[75]
	EnchantHandName[38] = EnchantArmorName[76]
	EnchantHandName[39] = EnchantArmorName[77]
	EnchantHandName[40] = EnchantArmorName[78]
	EnchantHandName[41] = EnchantArmorName[79]
	EnchantHandName[42] = EnchantArmorName[80]
	EnchantHandName[43] = EnchantArmorName[81]
	EnchantHandName[44] = EnchantArmorName[82]
	EnchantHandName[45] = EnchantArmorName[83]
	EnchantHandName[46] = EnchantArmorName[84]
	EnchantHandName[47] = EnchantArmorName[85]
	EnchantHandName[48] = EnchantArmorName[92]
	EnchantHandName[49] = EnchantArmorName[93]
	EnchantHandName[50] = EnchantArmorName[94]
	EnchantHandName[51] = EnchantArmorName[95]
	EnchantHandName[52] = EnchantArmorName[96]
	EnchantHandName[53] = EnchantArmorName[97]
	EnchantHandName[54] = EnchantArmorName[98]
	EnchantHandName[55] = EnchantArmorName[99]
	EnchantHandName[56] = EnchantArmorName[100]
	EnchantHandName[57] = EnchantArmorName[101]
	EnchantHandName[58] = EnchantArmorName[102]
	EnchantHandName[59] = EnchantArmorName[103]
	EnchantHandName[60] = EnchantArmorName[114]
	EnchantHandName[61] = EnchantArmorName[115]
	EnchantHandName[62] = EnchantArmorName[116]
	EnchantHandName[63] = EnchantArmorName[117]
	EnchantHandName[64] = EnchantArmorName[118]
	EnchantHandName[65] = EnchantArmorName[119]
	EnchantHandName[66] = EnchantArmorName2[18]
	EnchantHandName[67] = EnchantArmorName2[19]
	EnchantHandName[68] = EnchantArmorName2[20]
	EnchantHandName[69] = EnchantArmorName2[21]
	EnchantHandName[70] = EnchantArmorName2[22]
	EnchantHandName[71] = EnchantArmorName2[23]
	EnchantHandName[72] = EnchantArmorName2[24]
	EnchantHandName[73] = EnchantArmorName2[25]
	EnchantHandName[74] = EnchantArmorName2[26]
	EnchantHandName[75] = EnchantArmorName2[27]
	EnchantHandName[76] = EnchantArmorName2[28]
	EnchantHandName[77] = EnchantArmorName2[29]
	EnchantHandName[78] = EnchantArmorName2[30]
	EnchantHandName[79] = EnchantArmorName2[31]
	EnchantHandName[80] = EnchantArmorName2[32]
	EnchantHandName[81] = EnchantArmorName2[33]
	EnchantHandName[82] = EnchantArmorName2[34]
	EnchantHandName[83] = EnchantArmorName2[35]

	EnchantFeetName = New String[128]
	EnchantFeetName[0] = EnchantArmorName[18]
	EnchantFeetName[1] = EnchantArmorName[19]
	EnchantFeetName[2] = EnchantArmorName[20]
	EnchantFeetName[3] = EnchantArmorName[21]
	EnchantFeetName[4] = EnchantArmorName[22]
	EnchantFeetName[5] = EnchantArmorName[23]
	EnchantFeetName[6] = EnchantArmorName[74]
	EnchantFeetName[7] = EnchantArmorName[75]
	EnchantFeetName[8] = EnchantArmorName[76]
	EnchantFeetName[9] = EnchantArmorName[77]
	EnchantFeetName[10] = EnchantArmorName[78]
	EnchantFeetName[11] = EnchantArmorName[79]
	EnchantFeetName[12] = EnchantArmorName[80]
	EnchantFeetName[13] = EnchantArmorName[81]
	EnchantFeetName[14] = EnchantArmorName[82]
	EnchantFeetName[15] = EnchantArmorName[83]
	EnchantFeetName[16] = EnchantArmorName[84]
	EnchantFeetName[17] = EnchantArmorName[85]
	EnchantFeetName[18] = EnchantArmorName[98]
	EnchantFeetName[19] = EnchantArmorName[99]
	EnchantFeetName[20] = EnchantArmorName[100]
	EnchantFeetName[21] = EnchantArmorName[101]
	EnchantFeetName[22] = EnchantArmorName[102]
	EnchantFeetName[23] = EnchantArmorName[103]
	EnchantFeetName[24] = EnchantArmorName[104]
	EnchantFeetName[25] = EnchantArmorName[105]
	EnchantFeetName[26] = EnchantArmorName[106]
	EnchantFeetName[27] = EnchantArmorName[107]
	EnchantFeetName[28] = EnchantArmorName[108]
	EnchantFeetName[29] = EnchantArmorName[109]
	EnchantFeetName[30] = EnchantArmorName[110]
	EnchantFeetName[31] = EnchantArmorName[111]
	EnchantFeetName[32] = EnchantArmorName[112]
	EnchantFeetName[33] = EnchantArmorName[113]
	EnchantFeetName[34] = EnchantArmorName[114]
	EnchantFeetName[35] = EnchantArmorName[115]
	EnchantFeetName[36] = EnchantArmorName[116]
	EnchantFeetName[37] = EnchantArmorName[117]
	EnchantFeetName[38] = EnchantArmorName[118]
	EnchantFeetName[39] = EnchantArmorName[119]
	EnchantFeetName[40] = EnchantArmorName[120]
	EnchantFeetName[41] = EnchantArmorName[121]
	EnchantFeetName[42] = EnchantArmorName[122]
	EnchantFeetName[43] = EnchantArmorName[123]
	EnchantFeetName[44] = EnchantArmorName[124]
	EnchantFeetName[45] = EnchantArmorName[125]
	EnchantFeetName[46] = EnchantArmorName[126]
	EnchantFeetName[47] = EnchantArmorName[127]
	EnchantFeetName[48] = EnchantArmorName2[0]
	EnchantFeetName[49] = EnchantArmorName2[1]
	EnchantFeetName[50] = EnchantArmorName2[2]
	EnchantFeetName[51] = EnchantArmorName2[3]
	EnchantFeetName[52] = EnchantArmorName2[4]
	EnchantFeetName[53] = EnchantArmorName2[11]
	EnchantFeetName[54] = EnchantArmorName2[12]
	EnchantFeetName[55] = EnchantArmorName2[13]
	EnchantFeetName[56] = EnchantArmorName2[14]
	EnchantFeetName[57] = EnchantArmorName2[15]
	EnchantFeetName[58] = EnchantArmorName2[16]

	EnchantShieldName = New String[128]
	EnchantShieldName[0] = EnchantArmorName[12]
	EnchantShieldName[1] = EnchantArmorName[13]
	EnchantShieldName[2] = EnchantArmorName[14]
	EnchantShieldName[3] = EnchantArmorName[15]
	EnchantShieldName[4] = EnchantArmorName[16]
	EnchantShieldName[5] = EnchantArmorName[17]
	EnchantShieldName[6] = EnchantArmorName[40]
	EnchantShieldName[7] = EnchantArmorName[41]
	EnchantShieldName[8] = EnchantArmorName[42]
	EnchantShieldName[9] = EnchantArmorName[43]
	EnchantShieldName[10] = EnchantArmorName[44]
	EnchantShieldName[11] = EnchantArmorName[45]
	EnchantShieldName[12] = EnchantArmorName[121]
	EnchantShieldName[13] = EnchantArmorName[122]
	EnchantShieldName[14] = EnchantArmorName[123]
	EnchantShieldName[15] = EnchantArmorName[124]
	EnchantShieldName[16] = EnchantArmorName[125]
	EnchantShieldName[17] = EnchantArmorName[126]
	EnchantShieldName[18] = EnchantArmorName[127]
	EnchantShieldName[19] = EnchantArmorName2[0]
	EnchantShieldName[20] = EnchantArmorName2[1]
	EnchantShieldName[21] = EnchantArmorName2[2]
	EnchantShieldName[22] = EnchantArmorName2[3]
	EnchantShieldName[23] = EnchantArmorName2[4]
	EnchantShieldName[24] = EnchantArmorName2[5]
	EnchantShieldName[25] = EnchantArmorName2[6]
	EnchantShieldName[26] = EnchantArmorName2[7]
	EnchantShieldName[27] = EnchantArmorName2[8]
	EnchantShieldName[28] = EnchantArmorName2[9]
	EnchantShieldName[29] = EnchantArmorName2[10]
	EnchantShieldName[30] = EnchantArmorName2[11]
	EnchantShieldName[31] = EnchantArmorName2[12]
	EnchantShieldName[32] = EnchantArmorName2[13]
	EnchantShieldName[33] = EnchantArmorName2[14]
	EnchantShieldName[34] = EnchantArmorName2[15]
	EnchantShieldName[35] = EnchantArmorName2[16]
EndFunction

Function SetUpTemper()
	TemperPeople = New ActorBase[128]
	TemperExp = New Int[128]
EndFunction

;====================================================================================

Function UpdateStatus()
	If SkyInstalled
		SendModEvent("_ED_StatusUpdated")
	EndIf
EndFunction

Int Function WeapType(Int Type)
	Int NewType
	If Type < 5
		NewType = Type - 1
	ElseIf Type == 5
		NewType = 0
	ElseIf Type == 6
		NewType = 2
	ElseIf Type == 7
		NewType = 4
	ElseIf Type == 8
		NewType = 6
	ElseIf Type == 9
		NewType = 5
	ElseIf Type == 10
		NewType = 7
	EndIf
	Return NewType
EndFunction

String Function WidgetState(Float Health)
	String TemperedState
	If Health == 0.0
		TemperedState = "-1"
	ElseIf Health < 1.1
		TemperedState = ""
	Else
		If RequiemInstalled
			TemperedState = ((RoundToTens(Health) * 100) as Int) as String + "%"
		Else
			If Health < 1.2
				TemperedState = FineState
			ElseIf Health < 1.3
				TemperedState = SuperiorState
			ElseIf Health < 1.4
				TemperedState = ExquisiteState
			ElseIf Health < 1.5
				TemperedState = FlawlessState
			ElseIf Health < 1.6
				TemperedState = EpicState
			ElseIf Health < 1.7
				TemperedState = LegendaryState
			Else
				TemperedState = LegendaryState + "+"
			EndIf
		EndIf
	EndIf
	Return TemperedState
EndFunction

Function SetWidgetValues(Int WeaponSlot = 1, Int ArmorSlot = 0, Float Health)
	If SkyInstalled
		Int HealthPerc = Round((Health - ((Health * 10.0) as Int / 10.0)) / 0.00099 * 100.0)
		If ArmorSlot == 0
			If WeaponSlot == 1
				EquipHealth[4] = HealthPerc
				EquipState[4] = WidgetState(Health)
			Else
				EquipHealth[5] = HealthPerc
				EquipState[5] = WidgetState(Health)
			EndIf
		ElseIf ArmorSlot == 0x00000200
			EquipHealth[5] = HealthPerc
			EquipState[5] = WidgetState(Health)
		ElseIf ArmorSlot == 0x00000001 || ArmorSlot == 0x00000002
			EquipHealth[0] = HealthPerc
			EquipState[0] = WidgetState(Health)
		ElseIf ArmorSlot == 0x00000004
			EquipHealth[1] = HealthPerc
			EquipState[1] = WidgetState(Health)
		ElseIf ArmorSlot == 0x00000008
			EquipHealth[2] = HealthPerc
			EquipState[2] = WidgetState(Health)
		Else
			EquipHealth[3] = HealthPerc
			EquipState[3] = WidgetState(Health)
		EndIf
	EndIf
EndFunction

Bool Function DegradeItem(Int WeaponSlot = 1, Int ArmorSlot = 0)
	Form CurrentItem
	If ArmorSlot == 0
		CurrentItem = targ.GetEquippedObject(WeaponSlot)
	Else
		CurrentItem = targ.GetWornForm(ArmorSlot)
	EndIf
	If CurrentItem
		Float NewHealth
		Float CurrentHealth = WornObject.GetItemHealthPercent(targ, WeaponSlot, ArmorSlot)
		If CurrentHealth >= 1.1
			Int BreakSound
			NewHealth = (((CurrentHealth - 0.1) * 10.0) as Int / 10.0) + 0.00099
			WornObject.SetItemHealthPercent(targ, WeaponSlot, ArmorSlot, NewHealth)
			SetWidgetValues(WeaponSlot, ArmorSlot, NewHealth)
			UpdateStatus()
			Utility.Wait(0.1)
			If ArmorSlot == 0
				BreakSound = _EDWeaponBreakLP.Play(targ)
				Sound.SetInstanceVolume(BreakSound, 0.4)
			Else
				BreakSound = _EDArmorBreakLP.Play(targ)
				Sound.SetInstanceVolume(BreakSound, 0.5)
			EndIf
		Else
			Debug.Notification(NoDegrade)
		EndIf
		Return True
	EndIf
	Return False
EndFunction

Bool Function ExamineItem(Int WeaponSlot = 1, Int ArmorSlot = 0)
	Float CurrentHealth = WornObject.GetItemHealthPercent(targ, WeaponSlot, ArmorSlot)
	Form CurrentItem
	If ArmorSlot == 0
		CurrentItem = targ.GetEquippedObject(WeaponSlot)
	Else
		CurrentItem = targ.GetWornForm(ArmorSlot)
	EndIf
	If CurrentItem
		If CurrentHealth < 1.1
			Debug.Notification(CurrentItem.GetName() + ": " + UntemperedState)
		Else
			If RequiemInstalled
				Debug.Notification(CurrentItem.GetName() + ": " + Round((CurrentHealth - ((CurrentHealth * 10.0) as Int / 10.0)) / 0.00099 * 100.0) + "%" + ofText + (RoundToTens(CurrentHealth) * 100) as Int + "%")
			Else
				String TemperedState
				If CurrentHealth < 1.2
					TemperedState = FineState
				ElseIf CurrentHealth < 1.3
					TemperedState = SuperiorState
				ElseIf CurrentHealth < 1.4
					TemperedState = ExquisiteState
				ElseIf CurrentHealth < 1.5
					TemperedState = FlawlessState
				ElseIf CurrentHealth < 1.6
					TemperedState = EpicState
				ElseIf CurrentHealth < 1.7
					TemperedState = LegendaryState
				Else
					TemperedState = LegendaryState + "+"
				EndIf
				Debug.Notification(CurrentItem.GetName() + ": " + Round((CurrentHealth - ((CurrentHealth * 10.0) as Int / 10.0)) / 0.00099 * 100.0) + "%" + TemperedState)
			EndIf
		EndIf
		Return True
	EndIf
	Return False
EndFunction

Function Examine()
	If WidgetItems == 0 || WidgetItems == 1
		ExamineItem(1)
		Weapon Offhand = targ.GetEquippedObject(0) as Weapon
		If Offhand && Offhand.GetWeaponType() as Int < 5
			ExamineItem(0)
		EndIf
		ExamineItem(1, 0x00000200)
	EndIf
	If WidgetItems == 0 || WidgetItems == 2
		If ExamineItem(1, 0x00000001)
		ElseIf ExamineItem(1, 0x00000002)
		EndIf
		ExamineItem(1, 0x00000004)
		ExamineItem(1, 0x00000008)
		ExamineItem(1, 0x00000080)
	EndIf
EndFunction

Function SearchNPCs()
	_EDNPCLootQuest.Stop()
	_EDNPCLootQuest.Start()
	RegisterForSingleUpdate(10.0)
EndFunction

;====================================================================================

Int Function Round(Float i)
	If (i - (i as Int)) < 0.5
		Return (i as Int)
	Else
		Return (Math.Ceiling(i) as Int)
	EndIf
EndFunction

Float Function RoundToTens(Float Value)
	Float Rounded = ((Value * 10.0) as Int / 10.0)
	If Rounded < 1.0
		Rounded = 1.0
	EndIf
	Return Rounded
EndFunction

Function CheckItemSlot(Weapon CurrentWeapon = None, Int WeaponSlot = 1, Armor CurrentArmor = None, Int ArmorSlot = 0, GlobalVariable Cost, GlobalVariable Discount, ActorBase Person, Int Level = 0)
	Bool CheckHealth = False
	Int WeaponType
	If CurrentArmor && !CurrentArmor.HasKeyword(VendorItemClothing) && !_EDIgnoreArmorList.HasForm(CurrentArmor) && ((!CurrentArmor.HasKeyword(MagicDisallowEnchanting) && !_EDNoBreakList.HasForm(CurrentArmor)) || Person == EorlundGraymane) && StringUtil.Find(CurrentArmor.GetName(), "Bound") as Int == -1
		If IsFletcher
			If CurrentArmor.IsLightArmor() && !CurrentArmor.IsShield()
				CheckHealth = True
			EndIf
		Else
			CheckHealth = True
		EndIf
	ElseIf CurrentWeapon && !CurrentWeapon.IsStaff() && !_EDIgnoreWeaponList.HasForm(CurrentWeapon) && ((!CurrentWeapon.HasKeyword(MagicDisallowEnchanting) && !_EDNoBreakList.HasForm(CurrentWeapon)) || Person == EorlundGraymane) && StringUtil.Find(CurrentWeapon.GetName(), "Bound") as Int == -1
		If IsFletcher
			WeaponType = CurrentWeapon.GetWeaponType() as Int
			If WeaponType == 7 || WeaponType == 9 || (WeaponType > 0 && WeaponType < 5)
				CheckHealth = True
			EndIf
		Else
			CheckHealth = True
		EndIf
	EndIf
	If CheckHealth
		Float CurrentHealth = RoundToTens(WornObject.GetItemHealthPercent(targ, WeaponSlot, ArmorSlot))
		Float MaxHealth
		Int SpeechDiscount = 0
		Int FletcherDiscount = 0
		If RequiemInstalled
			MaxHealth = 3.1				;6	Master
		Else
			MaxHealth = 1.6
		EndIf
		If Person
			If RequiemInstalled
				If Level < 1000			;1	Apprentice
					MaxHealth = 0.5			;2000
				ElseIf Level < 3000		;2	Journeyman
					MaxHealth = 1.0			;4000
				ElseIf Level < 7000		;3	Adept
					MaxHealth = 1.5			;8000
				ElseIf Level < 15000	;4	Expert
					MaxHealth = 2.0			;16000
				ElseIf Level < 31000	;5	Artisan
					MaxHealth = 2.5
				EndIf
				If CurrentArmor
					MaxHealth = MaxHealth / 2.0
					If CurrentArmor.HasKeywordString("ArmorMaterialDaedric") || CurrentArmor.HasKeywordString("ArmorMaterialDragonplate") || CurrentArmor.HasKeywordString("ArmorMaterialDragonScale")
					ElseIf CurrentArmor.HasKeywordString("ArmorMaterialEbony") || CurrentArmor.HasKeywordString("ArmorMaterialGlass") || CurrentArmor.HasKeywordString("DLC2ArmorMaterialStalhrimLight") || CurrentArmor.HasKeywordString("DLC2ArmorMaterialStalhrimHeavy")
						MaxHealth = MaxHealth * 0.95
					ElseIf CurrentArmor.HasKeywordString("ArmorMaterialElven") || CurrentArmor.HasKeywordString("ArmorMaterialElvenGilded") || CurrentArmor.HasKeywordString("ArmorMaterialOrcish") || CurrentArmor.HasKeywordString("DLC2ArmorMaterialChitinLight") || CurrentArmor.HasKeywordString("DLC2ArmorMaterialChitinHeavy")
						MaxHealth = MaxHealth * 0.85
					ElseIf CurrentArmor.HasKeywordString("ArmorMaterialDwarven")
						MaxHealth = MaxHealth * 0.8
					Else
						MaxHealth = MaxHealth * 0.75
					EndIf
				Else
					If WeaponType == 2
						MaxHealth = MaxHealth / 4.0
					ElseIf WeaponType < 5
						MaxHealth = MaxHealth / 2.0
					EndIf
					If CurrentWeapon.HasKeywordString("WeapMaterialDaedric") || CurrentWeapon.HasKeywordString("DLC1WeapMaterialDragonbone")
					ElseIf CurrentWeapon.HasKeywordString("WeapMaterialEbony") || CurrentWeapon.HasKeywordString("WeapMaterialGlass") || CurrentWeapon.HasKeywordString("DLC2WeaponMaterialStalhrim")
						MaxHealth = MaxHealth * 0.95
					ElseIf CurrentWeapon.HasKeywordString("WeapMaterialElven") || CurrentWeapon.HasKeywordString("WeapMaterialOrcish")
						MaxHealth = MaxHealth * 0.85
					ElseIf CurrentWeapon.HasKeywordString("WeapMaterialDwarven")
						MaxHealth = MaxHealth * 0.8
					Else
						MaxHealth = MaxHealth * 0.75
					EndIf
				EndIf
				MaxHealth = (Round(MaxHealth * 10.0) / 10.0) + 1.0
			Else
				If Level < 1000			;1	Apprentice
					MaxHealth = 1.1			;2000
				ElseIf Level < 3000		;2	Journeyman
					MaxHealth = 1.2			;4000
				ElseIf Level < 7000		;3	Adept
					MaxHealth = 1.3			;8000
				ElseIf Level < 15000	;4	Expert
					MaxHealth = 1.4			;16000
				ElseIf Level < 31000	;5	Artisan
					MaxHealth = 1.5
				EndIf
			EndIf
			If Person.GetRace() == OrcRace && ((CurrentWeapon && CurrentWeapon.HasKeywordString("WeapMaterialOrcish")) || (CurrentArmor && CurrentArmor.HasKeywordString("ArmorMaterialOrcish")))
				MaxHealth += 0.1
			ElseIf DBInstalled && Person == Baldor as ActorBase && ((CurrentWeapon && CurrentWeapon.HasKeywordString("DLC2WeaponMaterialStalhrim")) || (CurrentArmor && (CurrentArmor.HasKeywordString("DLC2ArmorMaterialStalhrimLight") || CurrentArmor.HasKeywordString("DLC2ArmorMaterialStalhrimHeavy"))))
				MaxHealth += 0.1
			EndIf
		EndIf
		If CurrentHealth < MaxHealth
			Int TemperCost
			Int CurrentValue
			Float CostExponent = 3.0
			If RequiemInstalled
				CostExponent = 1.5
			EndIf
			If CurrentArmor
				CurrentValue = Round(CurrentArmor.GetGoldValue() as Int / 2)
			Else
				CurrentValue = Round(CurrentWeapon.GetGoldValue() as Int / 2)
			EndIf
			If _EDTemperType.GetValue() as Int == 2
				TemperCost = Round(CurrentValue * Math.pow(CurrentHealth + 0.1, CostExponent))
			Else
				While CurrentHealth < MaxHealth
					TemperCost += Round(CurrentValue * Math.pow(CurrentHealth + 0.1, CostExponent))
					CurrentHealth += 0.1
				EndWhile
			EndIf
			SpeechDiscount = Round((TemperCost / 2.0) * (SpeechSkill / 100.0))
			If WornObject.GetEnchantment(targ, WeaponSlot, ArmorSlot) || (CurrentArmor && CurrentArmor.GetEnchantment()) || (CurrentWeapon && CurrentWeapon.GetEnchantment())
				TemperCost = TemperCost * 2
			EndIf
			If IsFletcher
				FletcherDiscount = Round((TemperCost * 1.15) - TemperCost)
			EndIf
			TemperCost = Round((TemperCost - FletcherDiscount - SpeechDiscount) * TemperCostMult) + 20
			If TemperCost == 0
				TemperCost = 1
			EndIf
			If CurrentGold >= TemperCost
				Cost.SetValue(TemperCost)
				Discount.SetValue(FletcherDiscount + SpeechDiscount)
			Else
				Cost.SetValue(0)
				_EDNotEnoughGold.SetValue(1)
			EndIf
		Else
			Cost.SetValue(0)
		EndIf
	Else
		Cost.SetValue(0)
	EndIf
EndFunction

Function CalcTemperCosts(ActorBase Person = None)
	_EDDoneCalc.SetValue(0)
	SpeechSkill = targ.GetActorValue("Speechcraft") as Int
	If SpeechSkill < 0
		SpeechSkill = 0
	ElseIf SpeechSkill > 100
		SpeechSkill = 100
	EndIf
	Int TemperLevel
	If Person
		TemperLevel = GetArrayIndex(Person)
		_EDTemperLevel.SetValue(TemperLevel)
	EndIf
	CurrentGold = targ.GetItemCount(Gold001) as Int
	CurrentRWeapon = targ.GetEquippedObject(1) as Weapon
	CheckItemSlot(CurrentRWeapon, 1, None, 0, _EDHasEquippedRWeapon, _EDRWeaponDiscount, Person, TemperLevel)

	CurrentHead = targ.GetWornForm(0x00000001) as Armor
	CheckItemSlot(None, 1, CurrentHead, 0x00000001, _EDHasEquippedHead, _EDHeadDiscount, Person, TemperLevel)
	If !CurrentHead
		CurrentHead = targ.GetWornForm(0x00000002) as Armor
		CheckItemSlot(None, 1, CurrentHead, 0x00000002, _EDHasEquippedHead, _EDHeadDiscount, Person, TemperLevel)
		HeadSlot = False
	Else
		HeadSlot = True
	EndIf

	CurrentBody = targ.GetWornForm(0x00000004) as Armor
	CheckItemSlot(None, 1, CurrentBody, 0x00000004, _EDHasEquippedBody, _EDBodyDiscount, Person, TemperLevel)

	CurrentHand = targ.GetWornForm(0x00000008) as Armor
	CheckItemSlot(None, 1, CurrentHand, 0x00000008, _EDHasEquippedHand, _EDHandDiscount, Person, TemperLevel)

	CurrentFeet = targ.GetWornForm(0x00000080) as Armor
	CheckItemSlot(None, 1, CurrentFeet, 0x00000080, _EDHasEquippedFeet, _EDFeetDiscount, Person, TemperLevel)

	CurrentShield = targ.GetWornForm(0x00000200) as Armor
	CheckItemSlot(None, 1, CurrentShield, 0x00000200, _EDHasEquippedShield, _EDShieldDiscount, Person, TemperLevel)
	_EDServices.UpdateGlobals()
	_EDDoneCalc.SetValue(1)
EndFunction

Function TemperItem(Actor akSpeaker, Int WeaponSlot, Int ArmorSlot, GlobalVariable Cost, GlobalVariable Discount)
	Float CurrentHealth
	If _EDTemperType.GetValue() as Int == 2
		CurrentHealth = RoundToTens(WornObject.GetItemHealthPercent(targ, WeaponSlot, ArmorSlot))
	Else
		Weapon CurrentWeapon = targ.GetEquippedObject(WeaponSlot) as Weapon
		Armor CurrentArmor = targ.GetWornForm(ArmorSlot) as Armor
		Int Level = _EDTemperLevel.GetValue() as Int
		If RequiemInstalled
			If Level < 1000			;1	Apprentice
				CurrentHealth = 0.5			;2000
			ElseIf Level < 3000		;2	Journeyman
				CurrentHealth = 1.0			;4000
			ElseIf Level < 7000		;3	Adept
				CurrentHealth = 1.5			;8000
			ElseIf Level < 15000	;4	Expert
				CurrentHealth = 2.0			;16000
			ElseIf Level < 31000	;5	Artisan
				CurrentHealth = 2.5
			Else					;6	Master
				CurrentHealth = 3.1
			EndIf
			If CurrentArmor
				CurrentHealth = CurrentHealth / 2.0
				If CurrentArmor.HasKeywordString("ArmorMaterialDaedric") || CurrentArmor.HasKeywordString("ArmorMaterialDragonplate") || CurrentArmor.HasKeywordString("ArmorMaterialDragonScale")
				ElseIf CurrentArmor.HasKeywordString("ArmorMaterialEbony") || CurrentArmor.HasKeywordString("ArmorMaterialGlass") || CurrentArmor.HasKeywordString("DLC2ArmorMaterialStalhrimLight") || CurrentArmor.HasKeywordString("DLC2ArmorMaterialStalhrimHeavy")
					CurrentHealth = CurrentHealth * 0.95
				ElseIf CurrentArmor.HasKeywordString("ArmorMaterialElven") || CurrentArmor.HasKeywordString("ArmorMaterialElvenGilded") || CurrentArmor.HasKeywordString("ArmorMaterialOrcish") || CurrentArmor.HasKeywordString("DLC2ArmorMaterialChitinLight") || CurrentArmor.HasKeywordString("DLC2ArmorMaterialChitinHeavy")
					CurrentHealth = CurrentHealth * 0.85
				ElseIf CurrentArmor.HasKeywordString("ArmorMaterialDwarven")
					CurrentHealth = CurrentHealth * 0.8
				Else
					CurrentHealth = CurrentHealth * 0.75
				EndIf
			Else
				Int WeaponType = CurrentWeapon.GetWeaponType() as Int
				If WeaponType == 2
					CurrentHealth = CurrentHealth / 4.0
				ElseIf WeaponType < 5
					CurrentHealth = CurrentHealth / 2.0
				EndIf
				If CurrentWeapon.HasKeywordString("WeapMaterialDaedric") || CurrentWeapon.HasKeywordString("DLC1WeapMaterialDragonbone")
				ElseIf CurrentWeapon.HasKeywordString("WeapMaterialEbony") || CurrentWeapon.HasKeywordString("WeapMaterialGlass") || CurrentWeapon.HasKeywordString("DLC2WeaponMaterialStalhrim")
					CurrentHealth = CurrentHealth * 0.95
				ElseIf CurrentWeapon.HasKeywordString("WeapMaterialElven") || CurrentWeapon.HasKeywordString("WeapMaterialOrcish")
					CurrentHealth = CurrentHealth * 0.85
				ElseIf CurrentWeapon.HasKeywordString("WeapMaterialDwarven")
					CurrentHealth = CurrentHealth * 0.8
				Else
					CurrentHealth = CurrentHealth * 0.75
				EndIf
			EndIf
			CurrentHealth = (Round(CurrentHealth * 10.0) / 10.0) + 0.9
		Else
			If Level < 1000			;1	Apprentice
				CurrentHealth = 1.0			;2000
			ElseIf Level < 3000		;2	Journeyman
				CurrentHealth = 1.1			;4000
			ElseIf Level < 7000		;3	Adept
				CurrentHealth = 1.2			;8000
			ElseIf Level < 15000	;4	Expert
				CurrentHealth = 1.3			;16000
			ElseIf Level < 31000	;5	Artisan
				CurrentHealth = 1.4
			Else					;6	Master
				CurrentHealth = 1.5
			EndIf
		EndIf
		If akSpeaker.GetRace() == OrcRace && ((CurrentWeapon && CurrentWeapon.HasKeywordString("WeapMaterialOrcish")) || (CurrentArmor && CurrentArmor.HasKeywordString("ArmorMaterialOrcish")))
			CurrentHealth += 0.1
		ElseIf DBInstalled && akSpeaker.GetActorBase() == Baldor as ActorBase && ((CurrentWeapon && CurrentWeapon.HasKeywordString("DLC2WeaponMaterialStalhrim")) || (CurrentArmor && (CurrentArmor.HasKeywordString("DLC2ArmorMaterialStalhrimLight") || CurrentArmor.HasKeywordString("DLC2ArmorMaterialStalhrimHeavy"))))
			CurrentHealth += 0.1
		EndIf
	EndIf
	If TemperDelay == 0
		Sound GenericRepair
		If IsFletcher
			GenericRepair = _EDTemperFletcherLP
		Else
			GenericRepair = _EDTemperLP
		EndIf
		GenericRepair.PlayandWait(akSpeaker)
		GenericRepair.PlayandWait(akSpeaker)
		If ArmorSlot == 0
			_EDTemperWeaponLP.Play(targ)
		Else
			_EDTemperArmorLP.Play(targ)
		EndIf
		SetWidgetValues(WeaponSlot, ArmorSlot, CurrentHealth + 0.10099)
		_EDSKConfigQuest.SetContextual()
		Utility.Wait(0.5)
		WornObject.SetItemHealthPercent(targ, WeaponSlot, ArmorSlot, CurrentHealth + 0.10099)
		targ.RemoveItem(Gold001, Cost.GetValue() as Int, false)
	Else
		WornObject.SetItemHealthPercent(targ, WeaponSlot, ArmorSlot, CurrentHealth + 0.10099)
		If EmptyContainer
			If ArmorSlot == 0
				targ.RemoveItem(targ.GetEquippedObject(1), 1, false, EmptyContainer)
			Else
				targ.RemoveItem(targ.GetWornForm(ArmorSlot), 1, false, EmptyContainer)
			EndIf
		EndIf
		targ.RemoveItem(Gold001, Cost.GetValue() as Int, false)
		If !TemperDelayRandom
			RegisterForSingleUpdateGameTime(TemperDelay)
		Else
			RegisterForSingleUpdateGameTime(Utility.RandomFloat(TemperDelay / 2.0, TemperDelay))
		EndIf
	EndIf
	AddTemperExp(akSpeaker.GetActorBase(), Round((Cost.GetValue() as Int + Discount.GetValue() as Int) / TemperCostMult))
	Cost.SetValue(0)
	_EDNotEnoughGold.SetValue(0)
	UpdateStatus()
EndFunction

Function AddToArray(ActorBase Person)
	If GetArrayIndex(Person) == 0
		Int i = 0
		While i < TemperPeople.Length
			If TemperPeople[i] == None
				TemperPeople[i] = Person
				If Person == EorlundGrayMane
					TemperExp[i] = 3000 + CurrentLVL3Exp
				ElseIf (DGInstalled && (Person == Gunmar as ActorBase || Person == Hestla as ActorBase)) || (DBInstalled && Person == Baldor as ActorBase)
					TemperExp[i] = 1000 + CurrentLVL2Exp
				Else
					Int RandomLevel = Utility.RandomInt(0, 1)
					If RandomLevel == 1
						TemperExp[i] = RandomLevel + CurrentLVL1Exp
					Else
						TemperExp[i] = 1000 + CurrentLVL2Exp
					EndIf
				EndIf
				;Debug.Notification(TemperExp[i])											;DEBUG
				Return
			EndIf
			i += 1
		EndWhile
	EndIf
EndFunction

Int Function GetArrayIndex(ActorBase Person)
	Int i = 0
	While i < TemperPeople.Length
		If TemperPeople[i] == Person
			;Debug.Notification(TemperExp[i])												;DEBUG
			Return TemperExp[i]
		EndIf
		i += 1
	EndWhile
	Return 0
EndFunction

Function AddTemperExp(ActorBase Person, Int Exp)
	Int i = 0
	While i < TemperPeople.Length
		If TemperPeople[i] == Person
			TemperExp[i] = TemperExp[i] + Exp
			Return
		EndIf
		i += 1
	EndWhile
EndFunction

Function LevelTemper()
	Int i = 0
	While i < TemperPeople.Length
		If TemperPeople[i] != None
			If TemperExp[i] < 1000
				CurrentLVL1Exp += 12
				TemperExp[i] = TemperExp[i] + 12
			ElseIf TemperExp[i] < 3000
				CurrentLVL2Exp += 23
				TemperExp[i] = TemperExp[i] + 23
			ElseIf TemperExp[i] < 7000
				CurrentLVL3Exp += 45
				TemperExp[i] = TemperExp[i] + 45
			ElseIf TemperExp[i] < 15000
				CurrentLVL4Exp += 89
				TemperExp[i] = TemperExp[i] + 89
			ElseIf TemperExp[i] < 31000
				CurrentLVL5Exp += 178
				TemperExp[i] = TemperExp[i] + 178
			EndIf
		EndIf
		i += 1
	EndWhile
EndFunction

;====================================================================================

Float Function CheckMaterial(Actor Target, Form BrokeItem, Bool Break = False)
	Float Durability = 0.0
	If BrokeItem
		Form Scraps
		If Break
			Target.RemoveItem(BrokeItem, 1, true)
		EndIf
		If BrokeItem as Armor
			If BrokeItem.HasKeywordString("ArmorMaterialDaedric") || BrokeItem.HasKeywordString("ArmorMaterialEbony")
				Scraps = _EDEbonyScrap
				Durability = DaedricEbonyDura
			ElseIf BrokeItem.HasKeywordString("ArmorMaterialDragonplate") || BrokeItem.HasKeywordString("ArmorMaterialDragonScale")
				If Break
					Target.AddItem(DragonScales, 1, true)
				EndIf
				Return DragonDura
			ElseIf BrokeItem.HasKeywordString("ArmorMaterialDwarven")
				Scraps = _EDDwemerScrap
				Durability = DwarvenDura
			ElseIf BrokeItem.HasKeywordString("ArmorMaterialElven") || BrokeItem.HasKeywordString("ArmorMaterialElvenGilded")
				Scraps = _EDMoonScrap
				Durability = ElvenDura
			ElseIf BrokeItem.HasKeywordString("DLC2ArmorMaterialBonemoldHeavy")
				Scraps = BoneMeal
				Durability = ElvenDura
			ElseIf BrokeItem.HasKeywordString("ArmorMaterialGlass")
				Scraps = _EDMalaScrap
				Durability = GlassDura
			ElseIf BrokeItem.HasKeywordString("ArmorMaterialOrcish")
				Scraps = _EDOrichScrap
				Durability = OrcishDura
			ElseIf BrokeItem.HasKeywordString("DLC2ArmorMaterialChitinLight") || BrokeItem.HasKeywordString("DLC2ArmorMaterialChitinHeavy")
				Scraps = ChitinPlate
				Durability = OrcishDura
			ElseIf BrokeItem.HasKeywordString("DLC2ArmorMaterialStalhrimLight") || BrokeItem.HasKeywordString("DLC2ArmorMaterialStalhrimHeavy")
				Scraps = _EDStalScrap
				Durability = DaedricEbonyDura
			ElseIf BrokeItem.HasKeywordString("ArmorMaterialFalmer") || BrokeItem.HasKeywordString("DLC1ArmorMaterielFalmerHeavyOriginal")
				Scraps = _EDChaurusScrap
				Durability = FalmerDura
			ElseIf BrokeItem.HasKeywordString("ArmorMaterialIron") || BrokeItem.HasKeywordString("ArmorMaterialIronBanded")
				Scraps = _EDIronScrap
				Durability = IronDura
			ElseIf BrokeItem.HasKeywordString("ArmorMaterialSteel") || BrokeItem.HasKeywordString("ArmorMaterialScaled") || BrokeItem.HasKeywordString("ArmorMaterialBlades") || BrokeItem.HasKeywordString("ArmorMaterialImperialHeavy") || BrokeItem.HasKeywordString("ArmorMaterialImperialLight") || BrokeItem.HasKeywordString("ArmorMaterialImperialStudded") || BrokeItem.HasKeywordString("ArmorMaterialPenitus") || BrokeItem.HasKeywordString("DLC1ArmorMaterialDawnguard") || BrokeItem.HasKeywordString("DLC2ArmorMaterialNordicHeavy")
				Scraps = _EDSteelScrap
				Durability = SteelDura
			ElseIf BrokeItem.HasKeyword(VendorItemClothing)
				Durability = ClothDura
			Else
				If Break
					Target.AddItem(LeatherStrips, Utility.RandomInt(3, 13), true)
				EndIf
				Return LeatherWoodDura
			EndIf
			If Break && Scraps
				Target.AddItem(Scraps, Utility.RandomInt(4, 6), true)
			EndIf
		ElseIf BrokeItem as Weapon && (BrokeItem as Weapon).GetWeaponType() as Int > 0
			If BrokeItem.HasKeywordString("WeapMaterialDaedric") || BrokeItem.HasKeywordString("WeapMaterialEbony")
				Scraps = _EDEbonyScrap
				Durability = DaedricEbonyDura
			ElseIf BrokeItem.HasKeywordString("DLC1WeapMaterialDragonbone")
				Scraps = _EDEbonyScrap
				Durability = DragonDura
			ElseIf BrokeItem.HasKeywordString("WeapMaterialDwarven")
				Scraps = _EDDwemerScrap
				Durability = DwarvenDura
			ElseIf BrokeItem.HasKeywordString("WeapMaterialElven")
				Scraps = _EDMoonScrap
				Durability = ElvenDura
			ElseIf BrokeItem.HasKeywordString("WeapMaterialFalmer") || BrokeItem.HasKeywordString("WeapMaterialFalmerHoned")
				Scraps = _EDChaurusScrap
				Durability = FalmerDura
			ElseIf BrokeItem.HasKeywordString("WeapMaterialGlass")
				Scraps = _EDMalaScrap
				Durability = GlassDura
			ElseIf BrokeItem.HasKeywordString("WeapMaterialOrcish")
				Scraps = _EDOrichScrap
				Durability = OrcishDura
			ElseIf BrokeItem.HasKeywordString("DLC2WeaponMaterialStalhrim")
				Scraps = _EDStalScrap
				Durability = DaedricEbonyDura
			ElseIf !(BrokeItem as Weapon).IsBow()
				If BrokeItem.HasKeywordString("WeapMaterialIron")
					Scraps = _EDIronScrap
					Durability = IronDura
				Else
					Scraps = _EDSteelScrap
					Durability = SteelDura
				EndIf
			Else
				Durability = LeatherWoodDura
			EndIf
			If Break && Scraps
				Target.AddItem(Scraps, Utility.RandomInt(2, 4), true)
			EndIf
		EndIf
	EndIf
	Return Durability
EndFunction

;====================================================================================

Function FindEquip(Int ArmorType = 0, Int WeaponType = 1, Int WeaponSlot = 1)
	Int iFormIndex = targ.GetNumItems() as Int
	Form OffWeapon = targ.GetEquippedObject(0)
	Armor Shield = targ.GetEquippedShield()
	While iFormIndex > 0
		iFormIndex -= 1
		Form kForm = targ.GetNthForm(iFormIndex)
		If ArmorType == 0
			If kForm as Weapon
				Int CurrentType = (kForm as Weapon).GetWeaponType() as Int
				Bool Equip = False
				If kForm.GetName() != ""
					If WeaponType == 0
						If CurrentType > 0 && CurrentType < 5
							Equip = True
						EndIf
					ElseIf WeaponType == 1
						If CurrentType == 5 || CurrentType == 6
							Equip = True
						EndIf
					ElseIf CurrentType == 7 || CurrentType == 9
						Equip = True
					EndIf
					If Equip
						Form MainWeapon = targ.GetEquippedObject(1)
						If WeaponSlot == 1 && MainWeapon != kForm && OffWeapon != kForm
							If MainWeapon
								targ.UnequipItemEx(MainWeapon, 1)
							EndIf
							targ.EquipItemEx(kForm, 1)
							Return
						ElseIf MainWeapon != kForm && OffWeapon != kForm
							Int MainType = (MainWeapon as Weapon).GetWeaponType() as Int
							If MainType > 0 && MainType < 5 && !Shield
								If OffWeapon
									targ.UnequipItemEx(OffWeapon, WeaponSlot)
								EndIf
								targ.EquipItemEx(kForm, WeaponSlot)
							Else
								If OffWeapon
									targ.UnequipItemEx(OffWeapon, 1)
								EndIf
								targ.EquipItemEx(kForm, 1)
							EndIf
							Return
						EndIf
					EndIf
				EndIf
			EndIf
		ElseIf (kForm as Armor) && (kForm as Armor).IsShield()
			If OffWeapon
				targ.UnequipItemEx(OffWeapon, 2)
			EndIf
			targ.EquipItem(kForm, false, true)
			Return
		EndIf
	EndWhile
EndFunction

;====================================================================================

Function Maintenance()
	targ = PlayerRef
	Debug.Trace("")
	Debug.Trace("=====Loot and Degradation is refreshing itself and searching for addons. Any errors below are harmless.=====")
	Debug.Trace("")

	If (SKSE.GetVersion() + SKSE.GetVersionMinor() * 0.01 + SKSE.GetVersionBeta() * 0.0001) >= 1.0700
		SKSEInstalled = True
	Else
		Debug.MessageBox(SKSEWarn)
		SKSEInstalled = False
	EndIf

	If Game.GetFormFromFile(0x00000802, "SkyUI.esp")		;SkyUI
		SkyInstalled = True
	Else
		SkyInstalled = False
	EndIf

	Gunmar = Game.GetFormFromFile(0x0000336C, "Dawnguard.esm")		;Dawnguard
	If Gunmar
		If !DGInstalled
			_EDExtraBSList.AddForm(Gunmar)
			Hestla = Game.GetFormFromFile(0x00003365, "Dawnguard.esm")
			_EDExtraBSList.AddForm(Hestla)
		EndIf
		DGInstalled = True
	Else
		DGInstalled = False
	EndIf

	Form QStone = Game.GetFormFromFile(0x0000306C, "Hearthfires.esm")				;Hearthfire
	If QStone
		_EDRecipeWhetstone.SetNthIngredient(QStone, 0)
	EndIf

	ChitinPlate = Game.GetFormFromFile(0x0002B04E, "Dragonborn.esm") as MiscObject		;Dragonborn
	If ChitinPlate
		_EDRecipeIngotStalScrap.SetResult(Game.GetFormFromFile(0x0002B06B, "Dragonborn.esm"))
		If !DBInstalled
			Baldor = Game.GetFormFromFile(0x00018FB5, "Dragonborn.esm")
			_EDNoBreakList.AddForm(Game.GetFormFromFile(0x00026490, "Dragonborn.esm"))	;horksbane
			_EDNoBreakList.AddForm(Game.GetFormFromFile(0x0001A578, "Dragonborn.esm"))	;champions
			_EDNoBreakList.AddForm(Game.GetFormFromFile(0x00026B0B, "Dragonborn.esm"))	;stormfang
		EndIf
		DBInstalled = True
	Else
		DBInstalled = False
	EndIf

	Form Version = Game.GetFormFromFile(0x00973D69, "Requiem.esp")						;Requiem
	If Version
		TemperRarity = 0
		If !RequiemInstalled
			_EDTemperType.SetValue(1)
			Debug.Notification(RequiemCompat)
		EndIf
		_EDRequiemInstalled.SetValue(1)
		RequiemInstalled = True
	Else
		_EDRequiemInstalled.SetValue(0)
		RequiemInstalled = False
	EndIf

	Form Axe = Game.GetFormFromFile(0x0002A743, "Chesko_Frostfall.esp")
	If Axe
		_EDRecipeWhetstone.SetNthIngredient(Game.GetFormFromFile(0x0004103E, "Chesko_Frostfall.esp"), 0)
		If !FFInstalled
			_EDIgnoreWeaponList.AddForm(Axe)
			_EDIgnoreWeaponList.AddForm(Game.GetFormFromFile(0x0002A74C, "Chesko_Frostfall.esp"))	;Axes
			_EDIgnoreWeaponList.AddForm(Game.GetFormFromFile(0x0002A74D, "Chesko_Frostfall.esp"))
			_EDIgnoreWeaponList.AddForm(Game.GetFormFromFile(0x0002A74E, "Chesko_Frostfall.esp"))
			_EDIgnoreWeaponList.AddForm(Game.GetFormFromFile(0x0002A74F, "Chesko_Frostfall.esp"))
			_EDIgnoreWeaponList.AddForm(Game.GetFormFromFile(0x0002A750, "Chesko_Frostfall.esp"))
			_EDIgnoreWeaponList.AddForm(Game.GetFormFromFile(0x0002A744, "Chesko_Frostfall.esp"))
			_EDIgnoreWeaponList.AddForm(Game.GetFormFromFile(0x0002A745, "Chesko_Frostfall.esp"))
			_EDIgnoreWeaponList.AddForm(Game.GetFormFromFile(0x0002A746, "Chesko_Frostfall.esp"))
			_EDIgnoreWeaponList.AddForm(Game.GetFormFromFile(0x0002A747, "Chesko_Frostfall.esp"))
			_EDIgnoreWeaponList.AddForm(Game.GetFormFromFile(0x0002A748, "Chesko_Frostfall.esp"))
			_EDIgnoreWeaponList.AddForm(Game.GetFormFromFile(0x0002A749, "Chesko_Frostfall.esp"))
			_EDIgnoreWeaponList.AddForm(Game.GetFormFromFile(0x0002A74A, "Chesko_Frostfall.esp"))
			_EDIgnoreWeaponList.AddForm(Game.GetFormFromFile(0x0002A74B, "Chesko_Frostfall.esp"))
			_EDIgnoreWeaponList.AddForm(Game.GetFormFromFile(0x0003C96B, "Chesko_Frostfall.esp"))	;Walking stick
			_EDIgnoreWeaponList.AddForm(Game.GetFormFromFile(0x0004103D, "Chesko_Frostfall.esp"))	;Stone hatchet
		EndIf
		FFInstalled = True
	Else
		FFInstalled = False
	EndIf

	Form OldNordHelm = Game.GetFormFromFile(0x032602E6, "Skyrim Immersive Creatures.esp")
	If OldNordHelm
		If !SICInstalled
			_EDIgnoreArmorList.AddForm(OldNordHelm)
			_EDIgnoreArmorList.AddForm(Game.GetFormFromFile(0x03262A86, "Skyrim Immersive Creatures.esp"))	;OldNordArm
			_EDIgnoreArmorList.AddForm(Game.GetFormFromFile(0x03265224, "Skyrim Immersive Creatures.esp"))	;OldNordBoots
			_EDIgnoreArmorList.AddForm(Game.GetFormFromFile(0x03265226, "Skyrim Immersive Creatures.esp"))	;OldNordGaunt
			_EDIgnoreArmorList.AddForm(Game.GetFormFromFile(0x032BE7E3, "Skyrim Immersive Creatures.esp"))	;WornAncientOld
			_EDIgnoreArmorList.AddForm(Game.GetFormFromFile(0x032BE7E4, "Skyrim Immersive Creatures.esp"))	;RaddledAncientOld
			_EDIgnoreArmorList.AddForm(Game.GetFormFromFile(0x032BE7E5, "Skyrim Immersive Creatures.esp"))	;BrokenAncientOld
			_EDIgnoreArmorList.AddForm(Game.GetFormFromFile(0x032BE7E6, "Skyrim Immersive Creatures.esp"))	;AncientOldRag
			_EDIgnoreArmorList.AddForm(Game.GetFormFromFile(0x032BE7E7, "Skyrim Immersive Creatures.esp"))	;AncientLightGaunt
			_EDIgnoreArmorList.AddForm(Game.GetFormFromFile(0x0337D3A1, "Skyrim Immersive Creatures.esp"))	;AncientHornedHelm
			_EDIgnoreArmorList.AddForm(Game.GetFormFromFile(0x0337D3A2, "Skyrim Immersive Creatures.esp"))	;AncientLordHelm
		EndIf
		SICInstalled = True
	Else
		SICInstalled = False
	EndIf

	EnchantWeaponListSize = _EDEnchantWeaponList.GetSize() as Int
	EnchantArmorListSize = _EDEnchantArmorList.GetSize() as Int
	EnchantHeadListSize = _EDEnchantHeadList.GetSize() as Int
	EnchantBodyListSize = _EDEnchantBodyList.GetSize() as Int
	EnchantHandListSize = _EDEnchantHandList.GetSize() as Int
	EnchantFeetListSize = _EDEnchantFeetList.GetSize() as Int
	EnchantShieldListSize = _EDEnchantShieldList.GetSize() as Int

	If fModVersion
		If fModVersion < 1.31			;CHANGE VERSION NUMBER WHEN UPDATING
			ModUpdated = True
			Debug.Notification(UpdateNote + " v1.31")	;CHANGE VERSION NUMBER WHEN UPDATING
			SetUpNames()
			If fModVersion < 1.30
				EquipHealth = New Int[6]
				EquipState = New String[6]
				If DecayChance > 0
					WidgetVisible = True
					DecayChance = 6667
				EndIf
				If FollowerDecayChance > 0
					FollowerDecayChance = 6667
				EndIf
				If EnchantRarity > 0
					EnchantRarity = 50
				EndIf
				If TemperRarity > 0
					TemperRarity = 12500000
				EndIf
			EndIf
		EndIf
		Restart()
		If SkyInstalled && SKSEInstalled
			_EDSKConfigQuest.OnConfigInit()
		EndIf
	Else
		If SkyInstalled && SKSEInstalled
			targ.AddSpell(_EDPlayerSpell, false)
			targ.AddSpell(_EDNPCSpell, false)
			SearchNPCs()
		EndIf
		SetUpNames()
		SetUpTemper()
		_EDServicesQuest.Start()
		Int DaysPassed = Utility.GetCurrentGameTime() as Int
		If DaysPassed > 180
			DaysPassed = 180
		EndIf
		CurrentLVL1Exp = 12 * DaysPassed
		CurrentLVL2Exp = 23 * DaysPassed
		CurrentLVL3Exp = 45 * DaysPassed
		CurrentLVL4Exp = 89 * DaysPassed
		CurrentLVL5Exp = 178 * DaysPassed
		EquipHealth = New Int[6]
		EquipState = New String[6]
		WidgetVisible = True
		If SkyInstalled && SKSEInstalled
			_EDSKConfigQuest.OnConfigInit()
		EndIf
		;targ.AddItem(_EDWhetstoneRepair)
	EndIf
	fModVersion = 1.31			;CHANGE VERSION NUMBER WHEN UPDATING
	ModUpdated = False
	Debug.Trace("")
	Debug.Trace("=====Loot and Degradation is finished refreshing itself and searching for addons!=====")
	Debug.Trace("")
EndFunction

;====================================================================================

Function Restart()
	ModRestarted = True
	targ = PlayerRef
	targ.RemoveSpell(_EDPlayerSpell)
	targ.RemoveSpell(_EDNPCSpell)
	If ModUpdated && _EDFollowerToggle.GetValue() as Int == 1
		_EDFollowerToggle.SetValue(0)
		Utility.Wait(1.0)
		_EDFollowerToggle.SetValue(1)
	Else
		Utility.Wait(0.5)
	EndIf
	targ.AddSpell(_EDPlayerSpell, false)
	targ.AddSpell(_EDNPCSpell, false)
	Utility.Wait(1.0)
	ModRestarted = False
EndFunction

;====================================================================================

Event OnInit()
	Maintenance()
EndEvent

Event OnUpdate()
	SearchNPCs()
EndEvent

Event OnUpdateGameTime()
	WICourier.AddItemToContainer(_EDEmptyItem)
EndEvent