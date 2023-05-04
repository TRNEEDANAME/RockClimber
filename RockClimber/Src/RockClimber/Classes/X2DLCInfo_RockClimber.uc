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
	local X2CharacterTemplateManager    CharacterMgr;
	
    local X2EquipmentTemplate ItemTemplate;
    local X2ArmorTemplate     ArmoursTemplate;
    local name Object;

    ItemMgr			= class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	CharacterMgr	= class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();

    foreach default.RockClimb_Items (Object)
    {
        ItemTemplate = X2EquipmentTemplate(ItemMgr.FindItemTemplate(Object));
        if (ItemTemplate != none)
        {
            ItemTemplate.Abilities.AddItem('TR_RockClimb_Item_Armor');
        }
    }
    foreach default.RockClimb_Armours (Object)
    {
        ArmoursTemplate = X2ArmorTemplate(ItemMgr.FindItemTemplate(Object));
        if (ArmoursTemplate != none)
        {
            ArmoursTemplate.Abilities.AddItem('TR_RockClimb_Item_Armor');
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
		case 'Climb_Ab_NumTurn':	OutString = string(class'ClassName'.default.TR_RockClimb_NumTurns_Ability);	return true;
		//NOT SOMEObject MATCHED HERE .. KEEP LOOKING
		default:	return false;		break;
    }  
}