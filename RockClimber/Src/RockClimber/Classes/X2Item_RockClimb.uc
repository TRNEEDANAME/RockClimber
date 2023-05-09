//---------------------------------------------------------------------------------------
//  FILE:    X2Item_RockClimb.uc
//  AUTHOR:  TRNEEDANAME
//  PURPOSE : Create the Rock climb item
//---------------------------------------------------------------------------------------

class X2Item_RockClimb extends X2Item_DefaultUtilityItems config (RockClimb);

var config bool TR_RockClimb_CanBeBuild, TR_RockClimb_IsStratingItem, TR_RockClimb_IsInfinite;
var config int TR_RockClimb_TradeValue, TR_RockClimb_Cost;

var config bool IsRockClimbingItemEnabled, IsRockClimbingVestEnabled;

var config bool RockClimbItem_AltImage_Active, RockClimbItem_AltImage_Active; 

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Items;

	if(default.IsRockClimbingItemEnabled == true)
	{
		Items.AddItem(Create_TR_RockClimb_Item());
	}

	if (default.IsRockClimbingVestEnabled == true)
	{
		Items.AddItem(Create_TR_RockClimbing_Vest());
	}
		
	return Items;
}

static function X2DataTemplate Create_TR_RockClimb_Item()
{
	local X2EquipmentTemplate	Template;
	local ArtifactCost			Resources;

	`CREATE_X2TEMPLATE(class'X2EquipmentTemplate', Template, 'TR_RockClimb_Item');

	if (default.RockClimbItem_AltImage_Active == true)
	{
		Template.strImage = "img:///TR_RockClimb.WallClimb_Item_rev";
	}

	else
	{
		Template.strImage = "img:///TR_RockClimb.WallClimb_Item_norm";
	}

	Template.ItemCat = 'heal';
	Template.InventorySlot = eInvSlot_Utility;
	Template.EquipSound = "StrategyUI_Medkit_Equip";

	Template.Abilities.AddItem('TR_RockClimb_Item');

	Template.CanBeBuilt		= default.TR_RockClimb_CanBeBuild;
	Template.StartingItem	= default.TR_RockClimb_IsStratingItem;
	Template.bInfiniteItem	= default.TR_RockClimb_IsInfinite;

	Template.TradingPostValue = default.TR_RockClimb_TradeValue;

	Template.Tier = 0;

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = default.TR_RockClimb_Cost;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Template.bShouldCreateDifficultyVariants = false;

	return Template;
}

static function X2DataTemplate Create_TR_RockClimbing_Vest()
{
	local X2EquipmentTemplate  Template;
	
	`CREATE_X2TEMPLATE(class'X2EquipmentTemplate', Template, 'TR_RockClimbingVest');
	Template.ItemCat = 'defense';
	Template.InventorySlot = eInvSlot_Utility;

	if (default.RockClimbingVest_AltImage_Active == true)
	{
		Template.strImage = "img:///TR_RockClimb.GeckoVest_AltImage";
	}

	else
	{
		Template.strImage = "img://"
	}

	Template.EquipSound = "StrategyUI_Vest_Equip";

	Template.Abilities.AddItem('TR_RockClimb_Item_Armour');
	Template.Abilities.AddItem('TR_RockClimb_Item_Armour_StatBonus');

	Template.CanBeBuilt = false;
	Template.TradingPostValue = 25;
	Template.PointsToComplete = 0;
	Template.Tier = 2;

	Template.RewardDecks.AddItem('ExperimentalArmorRewards');

	Template.SetUIStatMarkup(class'XLocalizedData'.default.HealthLabel, eStat_HP, class'X2Ability_RockClimber'.default.RockClimbingVest_HealthBonus);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, class'X2Ability_RockClimber'.default.RockClimbingVest_MobilityBonus);
	
	return Template;
}
