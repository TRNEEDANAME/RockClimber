//---------------------------------------------------------------------------------------
//  FILE:    X2Ability_RockClimber.uc
//  AUTHOR:  TRNEEDANAME
//  PURPOSE: Create the Rock climb ability
//---------------------------------------------------------------------------------------

class X2Ability_RockClimber extends X2Ability config (RockClimb);

var config int TR_RockClimb_AP_Cost_Ability, TR_RockClimb_Cooldown_Ability, TR_RockClimb_InitialCharge_Ability, TR_RockClimb_NumCharge_Ability;
var config bool TR_RockClimb_IsFree_Ability, TR_RockClimb_IsCrossClass, TR_RockClimbAbility_HasCharge;

var config int TR_RockClimb_AP_Cost_Item, TR_RockClimb_Cooldown_Item, TR_RockClimb_InitialCharge_Item, TR_RockClimb_NumCharge_Item;
var config bool TR_RockClimb_IsFree_Item, TR_RockClimb_ItemConsume;


//add the new abilities
static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	Templates.AddItem(TR_RockClimb_Ability('TR_RockClimb_Ability'));

	Templates.AddItem(TR_RockClimb_Item('TR_RockClimb_Item'));

	return Templates;
}

// ===================================================================
// ============================ ABILITIES ============================
// ===================================================================

static function X2AbilityTemplate TR_RockClimb_Ability(name TemplateName)
{
	local X2AbilityTemplate						Template;
	local X2Effect_PersistentTraversalChange    Climb;
	local X2AbilityCost_ActionPoints    	ActionPointCost;
	local X2AbilityCooldown             	Cooldown;
	local X2AbilityCharges              	Charges;
	local X2AbilityCost_Charges         	ChargeCost;
	local X2AbilityCost_Ammo				AmmoCost;

	local array<name>							SkipExclusions;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	//setup
	Template.IconImage = "img:///ToDo";
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
	Template.bCrossClassEligible = default.TR_RockClimb_IsCrossClass;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = default.TR_RockClimb_AP_Cost_Ability;
	ActionPointCost.bFreeCost = default.TR_RockClimb_IsFree_Ability;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';   
	Cooldown.iNumTurns = default.TR_RockClimb_Cooldown_Ability; 
	Template.AbilityCooldown = Cooldown;

	if (default.TR_RockClimbAbility_HasCharge == true)
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
	Climb.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnEnd);
	Climb.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(Climb);

	//ability visualization
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bShowActivation = true;
	Template.bStationaryWeapon = true;

	return Template;
}

// ===================================================================
// ============================== ITEMS ==============================
// ===================================================================


static function X2AbilityTemplate TR_RockClimb_Item(name TemplateName)
{
	local X2AbilityTemplate						Template;
	local X2Effect_PersistentTraversalChange    Climb;
	local X2AbilityCost_ActionPoints    	ActionPointCost;
	local X2AbilityCooldown             	Cooldown;
	local X2AbilityCharges              	Charges;
	local X2AbilityCost_Ammo				AmmoCost;

	local array<name>							SkipExclusions;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	if (default.TR_RockClimb_ItemConsume == true)
	{
		Template.AbilityCosts.AddItem(new class'X2AbilityCost_ConsumeItem');
	}

	else
	{
		return;
	}

	//setup
	Template.IconImage = "img:///ToDo";
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

	Charges = new class'X2AbilityCharges';
	Charges.InitialCharges = default.TR_RockClimb_InitialCharge_Item;
	Template.AbilityCharges = Charges;

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = default.TR_RockClimb_NumCharge_Item;
	Template.AbilityCosts.AddItem(ChargeCost);

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
	Climb.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnEnd);
	Climb.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(Climb);


	//ability visualization
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bShowActivation = true;
	Template.bStationaryWeapon = true;

	return Template;
}