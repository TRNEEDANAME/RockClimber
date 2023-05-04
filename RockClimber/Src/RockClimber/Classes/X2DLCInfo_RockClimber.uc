//---------------------------------------------------------------------------------------
//  FILE:    X2DLCInfo_RockClimber.uc
//  AUTHOR:  TRNEEDANAME
//  PURPOSE: OnLoad, OnSave all that cool stuff
//---------------------------------------------------------------------------------------

class X2DLCInfo_RockClimber extends X2DownloadableContentInfo;


static event OnLoadedSavedGame()
{

}

static event InstallNewCampaign(XComGameState StartState)
{

}


static function bool AbilityTagExpandHandler(string InString, out string OutString)
{
	local name TagText;
	
	TagText = name(InString);

	switch (TagText)
	{
		case 'LocName':	OutString = string(class'ClassName'.default.ConfigName);	return true;
		case 'Climb_Ab_NumTurn':	OutString = string(class'ClassName'.default.TR_RockClimb_NumTurns_Ability);	return true;
		//NOT SOMETHING MATCHED HERE .. KEEP LOOKING
		default:	return false;		break;
    }  
}