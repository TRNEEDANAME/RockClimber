//---------------------------------------------------------------------------------------
//  FILE:    X2Item_RockClimb.uc
//  AUTHOR:  TRNEEDANAME
//  PURPOSE : Create the Rock climb item & vest
//---------------------------------------------------------------------------------------

class X2Item_RockClimb extends X2Item_DefaultUtilityItems config (RockClimb);

var config bool TR_RockClimb_CanBeBuild_Item, TR_RockClimb_IsStratingItem_Item, TR_RockClimb_IsInfinite_Item;
var config bool TR_RockClimb_CanBeBuild_Vest, TR_RockClimb_IsStratingItem_Vest, TR_RockClimb_IsInfinite_Vest;

var config int TR_RockClimb_TradeValue_Item, TR_RockClimb_Cost_Item;
var config int TR_RockClimb_TradeValue_Vest;

var config bool IsRockClimbingEnabled_Item, IsRockClimbingEnabled_Vest;
var config bool RockClimb_RevImage_Item, RockClimbing_RevImage_Vest;

var config int TR_RockClimbing_HealthBonus_Vest, TR_RockClimbing_MobilityBonus_Vest;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Items;

	if(default.IsRockClimbingEnabled_Item)
	{
		Items.AddItem(Create_TR_RockClimb_Item());
	}

	if (default.IsRockClimbingEnabled_Vest)
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

	if (default.RockClimb_RevImage_Item)
	{
		Template.strImage = "img:///TR_RockClimb.WallClimb_Item_rev";
	}

	else
	{
		Template.strImage = "img:///TR_RockClimb.WallClimb_Item_norm";
	}

	Template.ItemCat = 'defense';
	Template.InventorySlot = eInvSlot_Utility;
	Template.EquipSound = "StrategyUI_Medkit_Equip";

	Template.Abilities.AddItem('TR_RockClimb_Item');

	Template.CanBeBuilt = default.TR_RockClimb_CanBeBuild_Item;
	Template.StartingItem = default.TR_RockClimb_IsStratingItem_Item;
	Template.bInfiniteItem = default.TR_RockClimb_IsInfinite_Item;

    if (!default.TR_RockClimb_IsInfinite_Item)
    {
    	Template.TradingPostValue = default.TR_RockClimb_TradeValue_Item;
      	Resources.ItemTemplateName = 'Supplies';
        Resources.Quantity = default.TR_RockClimb_Cost_Item;
	    Template.Cost.ResourceCosts.AddItem(Resources);
        Template.bShouldCreateDifficultyVariants = true;
    }

	Template.Tier = 0;

	return Template;
}

static function X2DataTemplate Create_TR_RockClimbing_Vest()
{
	local X2EquipmentTemplate  Template;
	
	`CREATE_X2TEMPLATE(class'X2EquipmentTemplate', Template, 'TR_RockClimbing_Vest');
	Template.ItemCat = 'defense';
	Template.InventorySlot = eInvSlot_Utility;

	if (default.ockClimbing_RevImage_Vest)
	{
		Template.strImage = "img:///TR_RockClimb.GeckoVest_rev";
	}

	else
	{
		Template.strImage = "img:///TR_RockClimb.GeckoVest_Norm";
	}

	Template.EquipSound = "StrategyUI_Vest_Equip";

	Template.Abilities.AddItem('TR_RockClimb_Item_Armour');
	Template.Abilities.AddItem('TR_RockClimb_Item_Armour_StatBonus');

	Template.CanBeBuilt = default.TR_RockClimb_CanBeBuild_Vest;
    Template.StartingItem = default.TR_RockClimb_IsStratingItem_Vest;
	Template.bInfiniteItem = default.TR_RockClimb_IsInfinite_Vest;

    if (!default.TR_RockClimb_IsInfinite_Vest)
    {
        Template.TradingPostValue = default.TR_RockClimb_TradeValue_Vest;

    }
	Template.PointsToComplete = 0;
	Template.Tier = 2;

	Template.RewardDecks.AddItem('ExperimentalArmorRewards');

	Template.SetUIStatMarkup(class'XLocalizedData'.default.HealthLabel, eStat_HP, default.TR_RockClimbing_HealthBonus_Vest);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, default.TR_RockClimbing_MobilityBonus_Vest);
	
	return Template;
}
