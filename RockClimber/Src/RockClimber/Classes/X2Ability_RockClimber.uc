//---------------------------------------------------------------------------------------
//  FILE:    X2Ability_RockClimber.uc
//  AUTHOR:  TRNEEDANAME
//  PURPOSE: Create the Rock climb ability
//---------------------------------------------------------------------------------------

class X2Ability_RockClimber extends X2Ability config (RockClimb);

// ABILITY

var config int TR_RockClimb_AP_Cost_Ability;
var config int TR_RockClimb_Cooldown_Ability;
var config int TR_RockClimb_InitialCharge_Ability;
var config int TR_RockClimb_NumCharge_Ability;
var config int TR_RockClimb_NumTurns_Ability;

var config bool TR_RockClimb_IsFree_Ability;
var config bool TR_RockClimb_IsCrossClass_Ability;
var config bool TR_RockClimb_HasCharge_Ability;
var config bool TR_RockClimb_IsPassive_Ability;

// ITEM

var config int TR_RockClimb_AP_Cost_Item;
var config int TR_RockClimb_Cooldown_Item;
var config int TR_RockClimb_InitialCharge_Item;
var config int TR_RockClimb_NumCharge_Item;
var config int TR_RockClimb_NumTurns_Item;

var config bool TR_RockClimb_IsFree_Item;
var config bool TR_RockClimb_ItemConsume;
var config bool TR_RockClimb_IsPassive_Item;
var config bool TR_RockClimb_HasCharge_Item;

// ARMOUR

var config int TR_RockClimb_AP_Cost_Item_Armour;
var config int  TR_RockClimb_Cooldown_Item_Armour;
var config int TR_RockClimb_InitialCharge_Item_Armour;
var config int TR_RockClimb_NumCharge_Item_Armour;
var config int TR_RockClimb_NumTurns_Item_Armour;

var config bool TR_RockClimb_IsFree_Item_Armour;
var config bool TR_RockClimb_IsPassive_Item_Armour;
var config bool TR_RockClimb_HasCharge_Item_Armour;

var config int RockClimbingVest_HealthBonus, RockClimbingVest_MobilityBonus;

// VEST
var config int TR_RockClimb_AP_Cost_Item_Armour;
var config int  TR_RockClimb_Cooldown_Item_Armour;
var config int TR_RockClimb_InitialCharge_Item_Armour;
var config int TR_RockClimb_NumCharge_Item_Armour;
var config int TR_RockClimb_NumTurns_Item_Armour;

var config bool TR_RockClimb_IsFree_Item_Armour;
var config bool TR_RockClimb_IsPassive_Item_Armour;
var config bool TR_RockClimb_HasCharge_Item_Armour;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	Templates.AddItem(TR_RockClimb_Ability());
    Templates.AddItem(TR_RockClimb_AbilityPassive());

	Templates.AddItem(TR_RockClimb_Item());
    Templates.AddItem(TR_RockClimb_Item_Vest());
	Templates.AddItem(TR_RockClimb_Item_Armour());

	return Templates;
}

// ===================================================================
// ============================ ABILITIES ============================
// ===================================================================

static function X2AbilityTemplate TR_RockClimb_Ability()
{
	local X2AbilityTemplate						Template;
	local X2Effect_PersistentTraversalChange    Climb;
	local X2AbilityCost_ActionPoints    	ActionPointCost;
	local X2AbilityCooldown             	Cooldown;
	local X2AbilityCharges              	Charges;
	local X2AbilityCost_Charges         	ChargeCost;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'TR_RockClimb_Ability');

	//setup
	Template.IconImage = "img:///TR_RockClimb.RockClimb_abilityIcon";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_UnitIsNotImpaired');
	Template.HideErrors.AddItem('AA_AbilityUnavailable');
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	Template.AbilitySourceName = 'eAbilitySource_Commander';
	Template.Hostility = eHostility_Neutral;
	Template.ShotHUDPriority = 9999;
	
	Template.bDisplayInUITacticalText = true;
	Template.bDontDisplayInAbilitySummary = true;

	Template.bDisplayInUITooltip = true;

	Template.bUniqueSource = true;
	Template.bCrossClassEligible = default.TR_RockClimb_Ability_IsCrossClass;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = default.TR_RockClimb_AP_Cost_Ability;
	ActionPointCost.bFreeCost = default.TR_RockClimb_IsFree_Ability;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';   
	Cooldown.iNumTurns = default.TR_RockClimb_Cooldown_Ability; 
	Template.AbilityCooldown = Cooldown;

	if (default.TR_RockClimbAbility_HasCharge)
	{
		Charges = new class'X2AbilityCharges';
		Charges.InitialCharges = default.TR_RockClimb_InitialCharge_Ability;
		Template.AbilityCharges = Charges;

		ChargeCost = new class'X2AbilityCost_Charges';
		ChargeCost.NumCharges = default.TR_RockClimb_NumCharge_Ability;
		Template.AbilityCosts.AddItem(ChargeCost);
	}

	//targeting
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	//Conditional
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	Climb = new class'X2Effect_PersistentTraversalChange';
	Climb.AddTraversalChange(eTraversal_WallClimb, true);
	Climb.EffectName = 'WreckingBallTraversal';
	Climb.DuplicateResponse = eDupe_Ignore;
	Climb.BuildPersistentEffect(default.TR_RockClimb_NumTurns_Ability, default.TR_RockClimb_IsPassive_Ability, true, false, eGameRule_PlayerTurnEnd);
	Template.AddTargetEffect(Climb);

	//ability visualization
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	
	Template.bStationaryWeapon = true;

	return Template;
}

static function X2AbilityTemplate TR_RockClimb_AbilityPassive()
{
	local X2AbilityTemplate						Template;
	local X2Effect_PersistentTraversalChange    Climb;
	local X2AbilityCost_ActionPoints    	    ActionPointCost;
	local X2AbilityCooldown             	    Cooldown;
	local X2AbilityCharges              	    Charges;
	local X2AbilityCost_Charges         	    ChargeCost;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'TR_RockClimb_Ability_Passive');

	//setup
	Template.IconImage = "img:///TR_RockClimb.RockClimb_abilityIcon";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_UnitIsNotImpaired');
	Template.HideErrors.AddItem('AA_AbilityUnavailable');
	Template.AbilitySourceName = 'eAbilitySource_Commander';
	Template.Hostility = eHostility_Neutral;
	Template.ShotHUDPriority = 9999;
	
	Template.bDisplayInUITacticalText = true;
	Template.bDontDisplayInAbilitySummary = true;

	Template.bDisplayInUITooltip = true;
	Template.bUniqueSource = true;

	//targeting
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	//Conditional
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	Climb = new class'X2Effect_PersistentTraversalChange';
	Climb.AddTraversalChange(eTraversal_WallClimb, true);
	Climb.EffectName = 'WreckingBallTraversal';
	Climb.DuplicateResponse = eDupe_Ignore;
	Climb.BuildPersistentEffect(5, true, true, false, eGameRule_PlayerTurnEnd);
	Template.AddTargetEffect(Climb);

	//ability visualization
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}

// ===================================================================
// ============================== ITEMS ==============================
// ===================================================================


static function X2AbilityTemplate TR_RockClimb_Item()
{
	local X2AbilityTemplate						Template;
	local X2Effect_PersistentTraversalChange    Climb;
	local X2AbilityCost_ActionPoints    	    ActionPointCost;
	local X2AbilityCooldown             	    Cooldown;
	local X2AbilityCharges              	    Charges;
	local X2AbilityCost_Charges ChargeCost;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'TR_RockClimb_Item');

	if (default.TR_RockClimb_Consume_Item)
	{
		Template.AbilityCosts.AddItem(new class'X2AbilityCost_ConsumeItem');
	}

	//setup
	Template.IconImage = "img:///TR_RockClimb.RockClimb_abilityIcon";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_UnitIsNotImpaired');
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	Template.AbilitySourceName = 'eAbilitySource_Commander';
	Template.Hostility = eHostility_Neutral;
	Template.ShotHUDPriority = 9999;
	
	Template.bDisplayInUITacticalText = true;
	Template.bDontDisplayInAbilitySummary = true;
	Template.bDisplayInUITooltip = true;

	Template.bUniqueSource = true;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = default.TR_RockClimb_AP_Cost_Item;
	ActionPointCost.bFreeCost = default.TR_RockClimb_IsFree_Item;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';   
	Cooldown.iNumTurns = default.TR_RockClimb_Cooldown_Item; 
	Template.AbilityCooldown = Cooldown;
	if (default.TR_RockClimbItem_HasCharge)
	{
		Charges = new class'X2AbilityCharges';
		Charges.InitialCharges = default.TR_RockClimb_InitialCharge_Item;
		Template.AbilityCharges = Charges;
	
		ChargeCost = new class'X2AbilityCost_Charges';
		ChargeCost.NumCharges = default.TR_RockClimb_NumCharge_Item;
		Template.AbilityCosts.AddItem(ChargeCost);
	}

	//targeting
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	//Conditional
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	
	Climb = new class'X2Effect_PersistentTraversalChange';
	Climb.AddTraversalChange(eTraversal_WallClimb, true);
	Climb.EffectName = 'WreckingBallTraversal';
	Climb.DuplicateResponse = eDupe_Ignore;
	Climb.BuildPersistentEffect(default.TR_RockClimb_NumTurns_Item, default.TR_RockClimb_IsPassive_Item, true, false, eGameRule_PlayerTurnEnd);
	Template.AddTargetEffect(Climb);


	//ability visualization
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}

static function X2AbilityTemplate TR_RockClimb_Item_Armour()
{
	local X2AbilityTemplate						Template;
	local X2Effect_PersistentTraversalChange    Climb;
	local X2AbilityCost_ActionPoints    	    ActionPointCost;
	local X2AbilityCooldown             	    Cooldown;
	local X2AbilityCharges              	    Charges;
	local X2AbilityCost_Charges                 ChargeCost;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'TR_RockClimb_Item_Armour');

	Template.IconImage = "img:///TR_RockClimb.RockClimb_abilityIcon";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_UnitIsNotImpaired');
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	Template.AbilitySourceName = 'eAbilitySource_Commander';
	Template.Hostility = eHostility_Neutral;
	Template.ShotHUDPriority = 9999;
	
	Template.bDisplayInUITacticalText = true;
	Template.bDontDisplayInAbilitySummary = true;
	Template.bDisplayInUITooltip = true;

	Template.bUniqueSource = true;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = default.TR_RockClimb_AP_Cost_Item_Armour;
	ActionPointCost.bFreeCost = default.TR_RockClimb_IsFree_Item_Armour;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';   
	Cooldown.iNumTurns = default.TR_RockClimb_Cooldown_Item_Armour; 
	Template.AbilityCooldown = Cooldown;

	if (default.TR_RockClimb_Item_Armour_HasCharge)
	{
		Charges = new class'X2AbilityCharges';
		Charges.InitialCharges = default.TR_RockClimb_InitialCharge_Item_Armour;
		Template.AbilityCharges = Charges;

		ChargeCost = new class'X2AbilityCost_Charges';
		ChargeCost.NumCharges = default.TR_RockClimb_NumCharge_Item_Armour;
		Template.AbilityCosts.AddItem(ChargeCost);
	}
	//targeting
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	//Conditional
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	
	Climb = new class'X2Effect_PersistentTraversalChange';
	Climb.AddTraversalChange(eTraversal_WallClimb, true);
	Climb.EffectName = 'WreckingBallTraversal';
	Climb.DuplicateResponse = eDupe_Ignore;
	Climb.BuildPersistentEffect(default.TR_RockClimb_NumTurns_Item_Armour, default.TR_RockClimb_IsPassive_Item_Armour, true, false, eGameRule_PlayerTurnEnd);
	Template.AddTargetEffect(Climb);


	//ability visualization
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}

static function X2AbilityTemplate TR_RockClimb_Item_Vest()
{
	local X2AbilityTemplate						Template;
	local X2Effect_PersistentTraversalChange    Climb;
	local X2AbilityCost_ActionPoints    	    ActionPointCost;
	local X2AbilityCooldown             	    Cooldown;
	local X2AbilityCharges              	    Charges;
	local X2AbilityCost_Charges                 ChargeCost;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'TR_RockClimb_Item_Vest');

	if (default.TR_RockClimb_Consume_Item_Vest)
	{
		Template.AbilityCosts.AddItem(new class'X2AbilityCost_ConsumeItem');
	}

	//setup
	Template.IconImage = "img:///TR_RockClimb.RockClimb_abilityIcon";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_UnitIsNotImpaired');
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	Template.AbilitySourceName = 'eAbilitySource_Commander';
	Template.Hostility = eHostility_Neutral;
	Template.ShotHUDPriority = 9999;
	
	Template.bDisplayInUITacticalText = true;
	Template.bDontDisplayInAbilitySummary = true;
	Template.bDisplayInUITooltip = true;

	Template.bUniqueSource = true;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = default.TR_RockClimb_AP_Cost_Item_Vest;
	ActionPointCost.bFreeCost = default.TR_RockClimb_IsFree_Item_Vest;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';   
	Cooldown.iNumTurns = default.TR_RockClimb_Cooldown_Item_Vest;
	Template.AbilityCooldown = Cooldown;
	if (default.TR_RockClimbItem_HasCharge)
	{
		Charges = new class'X2AbilityCharges';
		Charges.InitialCharges = default.TR_RockClimb_InitialCharge_Item_Vest;
		Template.AbilityCharges = Charges;
	
		ChargeCost = new class'X2AbilityCost_Charges';
		ChargeCost.NumCharges = default.TR_RockClimb_NumCharge_Item_Vest;
		Template.AbilityCosts.AddItem(ChargeCost);
	}

	//targeting
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	//Conditional
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	
	Climb = new class'X2Effect_PersistentTraversalChange';
	Climb.AddTraversalChange(eTraversal_WallClimb, true);
	Climb.EffectName = 'WreckingBallTraversal';
	Climb.DuplicateResponse = eDupe_Ignore;
	Climb.BuildPersistentEffect(default.TR_RockClimb_NumTurns_Item_Vest, default.TR_RockClimb_IsPassive_Item_Vest, true, false, eGameRule_PlayerTurnEnd);
	Template.AddTargetEffect(Climb);


	//ability visualization
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	
	Template.bStationaryWeapon = true;

	return Template;
}
