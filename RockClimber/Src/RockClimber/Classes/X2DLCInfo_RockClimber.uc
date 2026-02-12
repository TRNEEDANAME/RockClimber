//---------------------------------------------------------------------------------------
//  FILE:    X2DLCInfo_RockClimber.uc
//  AUTHOR:  TRNEEDANAME
//  PURPOSE: OnLoad, OnSave all that cool stuff
//---------------------------------------------------------------------------------------

class X2DLCInfo_RockClimber extends X2DownloadableContentInfo;

var config array<name> RockClimb_Items;
var config array<name> RockClimb_Armours;
var config array<name> RockClimber_CharacterGroups;
var config array<name> RockClimber_UnitNames;
var config array<name> RockClimber_Classes;

var localized string RockClimbAbility_HasCharge, RockClimbAbility_NoCharge;
var localized string RockClimbItem_HasCharge, RockClimbItem_NoCharge;
var localized string RockClimb_Item_Armour_HasCharge, RockClimb_Item_Armour_NoCharge;

static event OnLoadedSavedGame()
{
	OnPostTemplatesCreated();
}

static event InstallNewCampaign(XComGameState StartState)
{
	OnPostTemplatesCreated();
}

static event OnPostTemplatesCreated()
{
	local X2ItemTemplateManager             ItemMgr;
	local X2EquipmentTemplate               ItemTemplate;
	local X2ArmorTemplate                   ArmoursTemplate;
	local name                              Object;
	local X2CharacterTemplateManager        CharMgr;
	local name                              TemplateName, ClassName;
	local X2CharacterTemplate               CharTemplate;
	local X2SoldierClassTemplate			SoldierClassTemplate;
	local X2SoldierClassTemplateManager     ClassMgr;
	local SoldierClassAbilitySlot           NewAbilitySlot;
	local int                               SlotIndex, idx, Index;
	local array<X2DataTemplate>				DifficultyVariants;

	ItemMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	CharMgr = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();
	ClassMgr = class'X2SoldierClassTemplateManager'.static.GetSoldierClassTemplateManager();

	// Items
	foreach default.RockClimb_Items(Object)
	{
		ItemMgr.FindDataTemplateAllDifficulties(Object, DifficultyVariants);
		for (idx = 0; idx < DifficultyVariants.Length; ++idx)
		{
			ItemTemplate = X2EquipmentTemplate(DifficultyVariants[idx]);
			if (ItemTemplate == none)
				continue;

			if (ItemTemplate.Abilities.Find('TR_RockClimb_Item') == INDEX_NONE)
			{
				ItemTemplate.Abilities.AddItem('TR_RockClimb_Item');
			}
		}
	}

	// Armours
	foreach default.RockClimb_Armours(Object)
	{
		ItemMgr.FindDataTemplateAllDifficulties(Object, DifficultyVariants);
		for (idx = 0; idx < DifficultyVariants.Length; ++idx)
		{
			ArmoursTemplate = X2ArmorTemplate(DifficultyVariants[idx]);
			if (ArmoursTemplate == none)
				continue;

			if (ArmoursTemplate.Abilities.Find('TR_RockClimb_Item_Armour') == INDEX_NONE)
			{
				ArmoursTemplate.Abilities.AddItem('TR_RockClimb_Item_Armour');
			}
		}
	}

	// Character Groups
	foreach default.RockClimber_CharacterGroups(TemplateName)
	{
		CharMgr.FindDataTemplateAllDifficulties(TemplateName, DifficultyVariants);
		for (idx = 0; idx < DifficultyVariants.Length; ++idx)
		{
			CharTemplate = X2CharacterTemplate(DifficultyVariants[idx]);
			if (CharTemplate == none)
				continue;

			if (default.RockClimber_CharacterGroups.Find(CharTemplate.CharacterGroupName) == INDEX_NONE)
				continue;

			if (CharTemplate.Abilities.Find('TR_RockClimb_Ability_Passive') == INDEX_NONE)
			{
				CharTemplate.Abilities.AddItem('TR_RockClimb_Ability_Passive');
			}
		}
	}

	// Units
	foreach default.RockClimber_UnitNames(TemplateName)
	{
		CharMgr.FindDataTemplateAllDifficulties(TemplateName, DifficultyVariants);
		for (idx = 0; idx < DifficultyVariants.Length; ++idx)
		{
			CharTemplate = X2CharacterTemplate(DifficultyVariants[idx]);
			if (CharTemplate == none)
				continue;

			if (default.RockClimber_UnitNames.Find(CharTemplate.CharacterGroupName) == INDEX_NONE)
				continue;

			if (CharTemplate.Abilities.Find('TR_RockClimb_Ability_Passive') == INDEX_NONE)
			{
				CharTemplate.Abilities.AddItem('TR_RockClimb_Ability_Passive');
			}
		}
	}

	// Soldier Classes
	ClassMgr.FindDataTemplateAllDifficulties(ClassName, DifficultyVariants);
	for (idx = 0; idx < DifficultyVariants.Length; idx++)
	{
		SoldierClassTemplate = X2SoldierClassTemplate(DifficultyVariants[idx]);
		if (SoldierClassTemplate != none)
		{
			SoldierClassTemplate = ClassMgr.FindSoldierClassTemplate(ClassName);
			for (SlotIndex = 0; SlotIndex < SoldierClassTemplate.SoldierRanks[1].AbilitySlots.Length; ++SlotIndex)
			{
				if (SoldierClassTemplate.SoldierRanks[1].AbilitySlots[SlotIndex].AbilityType.AbilityName == 'TR_RockClimb_Ability')
				{
					break;
				}
			}
			if (SlotIndex == SoldierClassTemplate.SoldierRanks[1].AbilitySlots.Length)
			{
				NewAbilitySlot.AbilityType.AbilityName = 'TR_RockClimb_Ability';
				SoldierClassTemplate.SoldierRanks[1].AbilitySlots.AddItem(NewAbilitySlot);
			}
		}
	}
}

static function bool AbilityTagExpandHandler(string InString, out string OutString)
{
	local name TagText;
	
	TagText = name(InString);

	switch (TagText)
	{
		case 'RockClimbAbility_HasCharge': 
			if (class'X2Ability_RockClimber'.default.TR_RockClimb_HasCharge_Ability)
			{
				OutString = default.RockClimbAbility_HasCharge;
			}
			else 
			{
				OutString = default.RockClimbAbility_NoCharge;
			}
			return true;
			
		case 'RockClimb_NumCharge_Ability':	
			OutString = string(class'X2Ability_RockClimber'.default.TR_RockClimb_InitialCharge_Ability);	
			return true;
			
		case 'TR_RockClimb_Cooldown_Ability':	
			OutString = string(class'X2Ability_RockClimber'.default.TR_RockClimb_Cooldown_Ability);	
			return true;
			
		case 'TR_RockClimb_AP_Cost_Ability':	
			OutString = string(class'X2Ability_RockClimber'.default.TR_RockClimb_AP_Cost_Ability);	
			return true;
			
		case 'TR_RockClimb_NumTurns_Ability':	
			OutString = string(class'X2Ability_RockClimber'.default.TR_RockClimb_NumTurns_Ability);	
			return true;

		case 'RockClimbItem_HasCharge': 
			if (class'X2Ability_RockClimber'.default.TR_RockClimb_HasCharge_Item)
			{
				OutString = default.RockClimbItem_HasCharge;
			}
			else 
			{
				OutString = default.RockClimbItem_NoCharge;
			}
			return true;
			
		case 'RockClimb_NumCharge_Item':	
			OutString = string(class'X2Ability_RockClimber'.default.TR_RockClimb_InitialCharge_Item);	
			return true;
			
		case 'TR_RockClimb_Cooldown_Item':	
			OutString = string(class'X2Ability_RockClimber'.default.TR_RockClimb_Cooldown_Item);	
			return true;
			
		case 'TR_RockClimb_AP_Cost_Item':	
			OutString = string(class'X2Ability_RockClimber'.default.TR_RockClimb_AP_Cost_Item);	
			return true;
			
		case 'TR_RockClimb_NumTurns_Item':	
			OutString = string(class'X2Ability_RockClimber'.default.TR_RockClimb_NumTurns_Item);	
			return true;

		case 'RockClimb_Item_Armour_HasCharge': 
			if (class'X2Ability_RockClimber'.default.TR_RockClimb_HasCharge_Item_Armour)
			{
				OutString = default.RockClimb_Item_Armour_HasCharge;
			}
			else 
			{
				OutString = default.RockClimb_Item_Armour_NoCharge;
			}
			return true;
			
		case 'RockClimb_NumCharge_Item_Armour':	
			OutString = string(class'X2Ability_RockClimber'.default.TR_RockClimb_InitialCharge_Item_Armour);	
			return true;
			
		case 'TR_RockClimb_Cooldown_Item_Armour':	
			OutString = string(class'X2Ability_RockClimber'.default.TR_RockClimb_Cooldown_Item_Armour);	
			return true;
			
		case 'TR_RockClimb_AP_Cost_Item_Armour':	
			OutString = string(class'X2Ability_RockClimber'.default.TR_RockClimb_AP_Cost_Item_Armour);	
			return true;
			
		case 'TR_RockClimb_NumTurns_Item_Armour':	
			OutString = string(class'X2Ability_RockClimber'.default.TR_RockClimb_NumTurns_Item_Armour);	
			return true;
		
		case 'TR_RockClimb_Vest_HealthBuff':	
			OutString = string(class'X2Item_RockClimb'.default.TR_RockClimbing_HealthBonus_Vest);	
			return true;
			
		case 'TR_RockClimb_Vest_MobilityBuff':	
			OutString = string(class'X2Item_RockClimb'.default.TR_RockClimbing_MobilityBonus_Vest);	
			return true;

		default:	
			return false;
	}
}
