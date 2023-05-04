//---------------------------------------------------------------------------------------
//  FILE:    X2Item_RockClimb.uc
//  AUTHOR:  TRNEEDANAME
//  PURPOSE : Create the Rock climb item
//---------------------------------------------------------------------------------------

class X2Item_RockClimb extends X2Item_DefaultUtilityItems config (RockClimb);

var config bool TR_RockClimb_CanBeBuild, TR_RockClimb_IsStratingItem, TR_RockClimb_IsInfinite;
var config int TR_RockClimb_TradeValue, TR_RockClimb_Cost;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Items;

	Items.AddItem(Create_TR_RockClimb_Item());

	return Items;
}

static function X2DataTemplate Create_TR_RockClimb_Item()
{
	local X2EquipmentTemplate	Template;
	local ArtifactCost			Resources;

	`CREATE_X2TEMPLATE(class'X2EquipmentTemplate', Template, 'BlindEyeDrops');

	Template.strImage = "img:///ToAdd";

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
