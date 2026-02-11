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
	local array<name>                       TemplateNames;
	local name                              TemplateName, RockClimber_UnitName;
	local X2CharacterTemplate               CharTemplate;
	local X2SoldierClassTemplate			SoldierClassTemplate;
	local X2SoldierClassTemplateManager     ClassMgr;

	ItemMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	CharMgr = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();
	ClassMgr = class'X2SoldierClassTemplateManager'.static.GetSoldierClassTemplateManager();

	// Items
	foreach default.RockClimb_Items (Object)
	{
		ItemTemplate = X2EquipmentTemplate(ItemMgr.FindItemTemplate(Object));
		if (ItemTemplate != none)
		{
			ItemTemplate.Abilities.AddItem('TR_RockClimb_Item');
		}
	}

	// Armours
	foreach default.RockClimb_Armours (Object)
	{
		ArmoursTemplate = X2ArmorTemplate(ItemMgr.FindItemTemplate(Object));
		if (ArmoursTemplate != none)
		{
			ArmoursTemplate.Abilities.AddItem('TR_RockClimb_Item_Armour');
		}
	}

	// Character Groups
	foreach RockClimber_CharacterGroups(TemplateName)
	{
		CharTemplate = CharMgr.FindCharacterTemplate(TemplateName);
		if (CharTemplate == none)
			continue;

		if (default.RockClimber_CharacterGroups.Find(CharTemplate.CharacterGroupName) != INDEX_NONE)
		{
			CharTemplate.Abilities.AddItem('TR_RockClimb_AbilityPassive');
		}
	}

    // Units
	foreach RockClimber_UnitName(TemplateName)
	{
		CharTemplate = CharMgr.FindCharacterTemplate(TemplateName);
		if (CharTemplate == none)
			continue;

		if (default.RockClimber_UnitName.Find(CharTemplate.CharacterGroupName) != INDEX_NONE)
		{
			CharTemplate.Abilities.AddItem('TR_RockClimb_Ability');
		}
	}

	// Soldier Classes
	foreach default.RockClimber_Classes(ClassName)
	{
		SoldierClassTemplate = ClassMgr.FindSoldierClassTemplate(ClassName);
		if (SoldierClassTemplate == none)
			continue;

		if (default.RockClimber_Classes.Find(SoldierClassTemplate.DataName) != INDEX_NONE)
		{
			SoldierClassTemplate.Abilities.AddItem('TR_RockClimb_Ability');
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
			if (class'X2Ability_RockClimber'.default.TR_RockClimbAbility_HasCharge)
			{
				OutString = default.RockClimbAbility_HasCharge;
			}
			else 
			{
				OutString = default.RockClimbAbility_NoCharge;
			}
			return true;
			
		case 'RockClimb_NumCharge_Ability':	
			OutString = string(class'X2Ability_RockClimber'.default.TR_RockClimb_NumCharge_Ability);	
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
			if (class'X2Ability_RockClimber'.default.TR_RockClimbItem_HasCharge)
			{
				OutString = default.RockClimbItem_HasCharge;
			}
			else 
			{
				OutString = default.RockClimbItem_NoCharge;
			}
			return true;
			
		case 'RockClimb_NumCharge_Item':	
			OutString = string(class'X2Ability_RockClimber'.default.TR_RockClimb_NumCharge_Item);	
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
			if (class'X2Ability_RockClimber'.default.TR_RockClimb_Item_Armour_HasCharge)
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
			OutString = string(class'X2Ability_RockClimber'.default.RockClimbingVest_HealthBonus);	
			return true;
			
		case 'TR_RockClimb_Vest_MobilityBuff':	
			OutString = string(class'X2Ability_RockClimber'.default.RockClimbingVest_MobilityBonus);	
			return true;

		default:	
			return false;
	}
}
