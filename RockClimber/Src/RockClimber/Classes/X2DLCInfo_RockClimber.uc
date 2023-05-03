//---------------------------------------------------------------------------------------
//  FILE:    X2DLCInfo_RockClimber.uc
//  AUTHOR:  TRNEEDANAME
//  PURPOSE: OnLoad, OnSave all that cool stuff
//---------------------------------------------------------------------------------------

class X2DLCInfo_RockClimber extends X2DownloadableContentInfo;

var config array<name> TR_Climb, TR_Climb_Consumable;

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
    local X2CharacterTemplate CharacterTemplate;
    local name Thing;

    ItemMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

    foreach default.TR_Climb_Consumable (Thing)
    {
        ItemTemplate = X2EquipmentTemplate(ItemMgr.FindItemTemplate(Thing));
        if (ItemTemplate != none)
        {
            ItemTemplate.Abilities.AddItem('TR_Climb_Consume');
        }
    }

    foreach default.TR_Climb (Thing)
    {
        ItemTemplate = X2EquipmentTemplate(ItemMgr.FindItemTemplate(Thing));
        if (ItemTemplate != none)
        {
            ItemTemplate.Abilities.AddItem('TR_Climb');
        }
    }
}

static function bool AbilityTagExpandHandler(string InString, out string OutString)
{
	local name TagText;
	
	TagText = name(InString);

	switch (TagText)
	{
		case 'LocName':	OutString = string(class'ClassName'.default.ConfigName);	return true;
		//NOT SOMETHING MATCHED HERE .. KEEP LOOKING
		default:	return false;		break;
    }  
}