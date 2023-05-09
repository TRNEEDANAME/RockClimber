//---------------------------------------------------------------------------------------
//  FILE:    X2DLCInfo_RockClimber.uc
//  AUTHOR:  TRNEEDANAME
//  PURPOSE: OnLoad, OnSave all that cool stuff
//---------------------------------------------------------------------------------------

class X2DLCInfo_RockClimber extends X2DownloadableContentInfo;

var config array<name> RockClimb_Items, RockClimb_Armours;


static event OnLoadedSavedGame()
{

}

static event InstallNewCampaign(XComGameState StartState)
{

}

static event OnPostTemplatesCreated()
{
	local X2ItemTemplateManager			ItemMgr;
	
    local X2EquipmentTemplate ItemTemplate;
    local X2ArmorTemplate     ArmoursTemplate;
    local name Object;

    ItemMgr			= class'X2ItemTemplateManager'.static.GetItemTemplateManager();

    foreach default.RockClimb_Items (Object)
    {
        ItemTemplate = X2EquipmentTemplate(ItemMgr.FindItemTemplate(Object));
        if (ItemTemplate != none)
        {
            ItemTemplate.Abilities.AddItem('TR_RockClimb_Item');
        }
    }
    foreach default.RockClimb_Armours (Object)
    {
        ArmoursTemplate = X2ArmorTemplate(ItemMgr.FindItemTemplate(Object));
        if (ArmoursTemplate != none)
        {
            ArmoursTemplate.Abilities.AddItem('TR_RockClimb_Item_Armour');
        }
    }
}

static function bool AbilityTagExpandHandler(string InString, out string OutString)
{
	local name TagText;
	
	TagText = name(InString);

	switch (TagText)
	{
		case 'TR_RockClimb_NumCharge_Ability':	OutString = string(class'X2Ability_RockClimber'.default.TR_RockClimb_NumCharge_Ability);	return true;
		case 'TR_RockClimb_Cooldown_Ability':	OutString = string(class'X2Ability_RockClimber'.default.TR_RockClimb_Cooldown_Ability);	return true;
		case 'TR_RockClimb_AP_Cost_Ability':	OutString = string(class'X2Ability_RockClimber'.default.TR_RockClimb_AP_Cost_Ability);	return true;

		case 'TR_RockClimb_NumCharge_Item':	OutString = string(class'X2Ability_RockClimber'.default.TR_RockClimb_NumCharge_Item);	return true;
		case 'TR_RockClimb_Cooldown_Item':	OutString = string(class'X2Ability_RockClimber'.default.TR_RockClimb_Cooldown_Item);	return true;
		case 'TR_RockClimb_AP_Cost_Item':	OutString = string(class'X2Ability_RockClimber'.default.TR_RockClimb_AP_Cost_Item);	return true;

        case 'TR_RockClimb_NumCharge_Item_Armour':	OutString = string(class'X2Ability_RockClimber'.default.TR_RockClimb_InitialCharge_Item_Armour);	return true;
		case 'TR_RockClimb_Cooldown_Item_Armour':	OutString = string(class'X2Ability_RockClimber'.default.TR_RockClimb_Cooldown_Item_Armour);	return true;
		case 'TR_RockClimb_AP_Cost_Item_Armour':	OutString = string(class'X2Ability_RockClimber'.default.TR_RockClimb_AP_Cost_Item_Armour);	return true;

        case 'TR_RockClimb_Vest_HealthBuff':	OutString = string(class'X2Ability_RockClimber'.default.RockClimbingVest_HealthBonus);	return true;
		case 'TR_RockClimb_Vest_MobilityBuff':	OutString = string(class'X2Ability_RockClimber'.default.RockClimbingVest_MobilityBonus);	return true;

		default:	return false;		break;
    }  
}