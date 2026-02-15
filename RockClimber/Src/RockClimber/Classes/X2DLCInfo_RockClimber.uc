//---------------------------------------------------------------------------------------
//  FILE:    X2DLCInfo_RockClimber.uc
//  AUTHOR:  TRNEEDANAME
//  PURPOSE: OnLoad, OnSave all that cool stuff
//---------------------------------------------------------------------------------------

class X2DLCInfo_RockClimber extends X2DownloadableContentInfo config (RockClimb_AddingAbility);

var config array<name> RockClimb_Items;
var config array<name> RockClimb_Armours;
var config array<name> RockClimber_UnitNames;
var config array<name> RockClimber_CharacterGroups;
var config array<name> RockClimber_Classes;

var config(RockClimb) bool bLog;

delegate ModifyTemplate(X2DataTemplate DataTemplate);

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
    IterateTemplatesAllDiff(class'X2EquipmentTemplate', PatchEquipmentTemplates);
    IterateTemplatesAllDiff(class'X2EquipmentTemplate', PatchArmourTemplates);
	IterateTemplatesAllDiff(class'X2CharacterTemplate', PatchCharacterTemplates);
	IterateTemplatesAllDiff(class'X2CharacterTemplate', PatchCharacterGroupsTemplates);
	IterateTemplatesAllDiff(class'X2SoldierClassTemplate', PatchSoldierClassTemplates);
}

static function PatchEquipmentTemplates(X2DataTemplate DataTemplate)
{
	local X2EquipmentTemplate 	Template;
	local int 					ConfigIndex;

	Template = X2EquipmentTemplate(DataTemplate);
	if (Template == none)
	{
		return;
	}

	ConfigIndex = default.RockClimb_Items.Find(Template.DataName);
	if (ConfigIndex == INDEX_NONE)
	{
		return;
	}

	`LOG("Checking equipment template: " @ Template.DataName @ " for Rock Climb item ability.", default.bLog);
	if (Template.Abilities.Find('TR_RockClimb_Item') != INDEX_NONE)
	{
		`LOG("Rock Climb item ability already exists in equipment template: " @ Template.DataName, default.bLog);
		return;
	}

	`LOG("Adding Rock Climb item ability to equipment template: " @ Template.DataName, default.bLog);
	Template.Abilities.AddItem('TR_RockClimb_Item');
}

static function PatchArmourTemplates(X2DataTemplate DataTemplate)
{
	local X2ArmorTemplate		ArmourTemplate;
	local int 					ConfigIndex;

	ArmourTemplate = X2ArmorTemplate(DataTemplate);
	if (ArmourTemplate == none)
	{
		return;
	}

	ConfigIndex = default.RockClimb_Armours.Find(ArmourTemplate.DataName);
	if (ConfigIndex == INDEX_NONE)
	{
		return;
	}

	`LOG("Checking armour template: " @ ArmourTemplate.DataName @ " for Rock Climb armour ability.", default.bLog);
	if (ArmourTemplate.Abilities.Find('TR_RockClimb_Item_Armour') != INDEX_NONE)
	{
		`LOG("Rock Climb armour ability already exists in armour template: " @ ArmourTemplate.DataName, default.bLog);
		return;
	}

	`LOG("Adding Rock Climb armour ability to armour template: " @ ArmourTemplate.DataName, default.bLog);
	ArmourTemplate.Abilities.AddItem('TR_RockClimb_Item_Armour');
}

static function PatchCharacterTemplates(X2DataTemplate DataTemplate)
{
	local X2CharacterTemplate	CharacterTemplate;
	local name 					CharName;
	local bool					bIsTargetUnit;

	CharacterTemplate = X2CharacterTemplate(DataTemplate);
	if (CharacterTemplate == none)
	{
		return;
	}

	foreach default.RockClimber_UnitNames(CharName)
	{
		if (CharacterTemplate.DataName == CharName)
		{
			bIsTargetUnit = true;
			break;
		}
	}

	if (!bIsTargetUnit)
	{
		return;
	}

	`LOG("Checking character template: " @ CharacterTemplate.DataName @ " for existing Rock Climb passive ability.", default.bLog);
	if (CharacterTemplate.Abilities.Find('TR_RockClimb_Ability_Passive') != INDEX_NONE)
	{
		`LOG("Rock Climb passive ability already exists in character template: " @ CharacterTemplate.DataName, default.bLog);
		return;
	}

	`LOG("Adding Rock Climb passive ability to character template: " @ CharacterTemplate.DataName, default.bLog);
	CharacterTemplate.Abilities.AddItem('TR_RockClimb_Ability_Passive');
}


static function PatchCharacterGroupsTemplates(X2DataTemplate DataTemplate)
{
	local X2CharacterTemplate	CharacterTemplate;
	local name 					CharGroupName;
	local bool					bIsTargetUnit;

	CharacterTemplate = X2CharacterTemplate(DataTemplate);
	if (CharacterTemplate == none)
	{
		return;
	}

	foreach default.RockClimber_CharacterGroups(CharGroupName)
	{
		if (CharacterTemplate.CharacterGroupName == CharGroupName)
		{
			bIsTargetUnit = true;
			break;
		}
	}

	if (!bIsTargetUnit)
	{
		return;
	}

	`LOG("Checking character group template: " @ CharacterTemplate.DataName @ " for existing Rock Climb passive ability.", default.bLog);
	if (CharacterTemplate.Abilities.Find('TR_RockClimb_Ability_Passive') != INDEX_NONE)
	{
		`LOG("Rock Climb passive ability already exists in character group template: " @ CharacterTemplate.DataName, default.bLog);
		return;
	}

	`LOG("Adding Rock Climb passive ability to character group template: " @ CharacterTemplate.DataName, default.bLog);
	CharacterTemplate.Abilities.AddItem('TR_RockClimb_Ability_Passive');
}

static function PatchSoldierClassTemplates(X2DataTemplate DataTemplate)
{
	local X2SoldierClassTemplate	SoldierClassTemplate;
	local SoldierClassAbilitySlot	NewSlot;
	local name					ClassName;
	local bool					bIsTargetClass;
	local int					SlotIndex;

	SoldierClassTemplate = X2SoldierClassTemplate(DataTemplate);
	if (SoldierClassTemplate == none)
	{
		return;
	}

	foreach default.RockClimber_Classes(ClassName)
	{
		if (SoldierClassTemplate.DataName == ClassName)
		{
			bIsTargetClass = true;
			break;
		}
	}

	if (!bIsTargetClass)
	{
		return;
	}

	for (SlotIndex = 0; SlotIndex < SoldierClassTemplate.SoldierRanks[0].AbilitySlots.Length; ++SlotIndex)
	{
		if (SoldierClassTemplate.SoldierRanks[0].AbilitySlots[SlotIndex].AbilityType.AbilityName == 'TR_RockClimb_Ability')
		{
			`LOG("Rock Climb ability already exists in class: " @ SoldierClassTemplate.DisplayName, default.bLog);
			return;
		}
	}

	if (SoldierClassTemplate != none && SoldierClassTemplate.SoldierRanks.Length > 0)
	{
		NewSlot.AbilityType.AbilityName = 'TR_RockClimb_Ability';
		SoldierClassTemplate.SoldierRanks[0].AbilitySlots.AddItem(NewSlot);
		`LOG("Added ability " @ 'TR_RockClimb_Ability' @ " to class: " @ SoldierClassTemplate.DisplayName, default.bLog);
	}
}

// ============================================================
// ===================== LOCALISATION TAGS =====================
// ============================================================

static function bool AbilityTagExpandHandler(string InString, out string OutString)
{
	local name TagText;
	
	TagText = name(InString);

	switch (TagText)
	{
		// ============================================================================================
		// ABILITY
		// ============================================================================================

		case 'TR_RockClimb_InitialCharge_Ability':	
			OutString = string(class'X2Ability_RockClimber'.default.TR_RockClimb_InitialCharge_Ability);	
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

		// ============================================================================================
		// ITEM
		// ============================================================================================

		case 'TR_RockClimb_InitialCharge_Item':	
			OutString = string(class'X2Ability_RockClimber'.default.TR_RockClimb_InitialCharge_Item);	
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

		case 'TR_RockClimb_InitialCharge_Item_Armour':	
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

		// ============================================================================================
		// VEST
		// ============================================================================================
		case 'TR_RockClimb_InitialCharge_Item_Vest':	
			OutString = string(class'X2Ability_RockClimber'.default.TR_RockClimb_InitialCharge_Item_Vest);	
			return true;
			
		case 'TR_RockClimb_Cooldown_Item_Vest':	
			OutString = string(class'X2Ability_RockClimber'.default.TR_RockClimb_Cooldown_Item_Vest);	
			return true;
			
		case 'TR_RockClimb_AP_Cost_Item_Vest':	
			OutString = string(class'X2Ability_RockClimber'.default.TR_RockClimb_AP_Cost_Item_Vest);	
			return true;
			
		case 'TR_RockClimb_NumTurns_Item_Vest':	
			OutString = string(class'X2Ability_RockClimber'.default.TR_RockClimb_NumTurns_Item_Vest);	
			return true;

		case 'TR_RockClimb_Vest_HealthBuff':	
			OutString = string(class'X2Item_RockClimb'.default.TR_RockClimbing_HealthBonus_Vest);	
			return true;
			
		case 'TR_RockClimb_Vest_MobilityBuff':	
			OutString = string(class'X2Item_RockClimb'.default.TR_RockClimbing_MobilityBonus_Vest);	
			return true;

		default:
			return false;
	}
}

// ============================================================
// ========================= HELPER ===========================
// ============================================================

static private function IterateTemplatesAllDiff(class TemplateClass, delegate<ModifyTemplate> ModifyTemplateFn)
{
    local X2DataTemplate                                    IterateTemplate;
    local X2DataTemplate                                    DataTemplate;
    local array<X2DataTemplate>                             DataTemplates;
    local X2DLCInfo_RockClimber CDO;

    local X2ItemTemplateManager             ItemMgr;
    local X2AbilityTemplateManager          AbilityMgr;
    local X2CharacterTemplateManager        CharMgr;
    local X2StrategyElementTemplateManager  StratMgr;
    local X2SoldierClassTemplateManager     ClassMgr;

    if (ClassIsChildOf(TemplateClass, class'X2ItemTemplate'))
    {
        CDO = GetCDO();
        ItemMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

        foreach ItemMgr.IterateTemplates(IterateTemplate)
        {
            if (!ClassIsChildOf(IterateTemplate.Class, TemplateClass)) continue;

            ItemMgr.FindDataTemplateAllDifficulties(IterateTemplate.DataName, DataTemplates);
            foreach DataTemplates(DataTemplate)
            {   
                CDO.CallModifyTemplateFn(ModifyTemplateFn, DataTemplate);
            }
        }
    }
    else if (ClassIsChildOf(TemplateClass, class'X2AbilityTemplate'))
    {
        CDO = GetCDO();
        AbilityMgr = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

        foreach AbilityMgr.IterateTemplates(IterateTemplate)
        {
            if (!ClassIsChildOf(IterateTemplate.Class, TemplateClass)) continue;

            AbilityMgr.FindDataTemplateAllDifficulties(IterateTemplate.DataName, DataTemplates);
            foreach DataTemplates(DataTemplate)
            {
                CDO.CallModifyTemplateFn(ModifyTemplateFn, DataTemplate);
            }
        }
    }
    else if (ClassIsChildOf(TemplateClass, class'X2CharacterTemplate'))
    {
        CDO = GetCDO();
        CharMgr = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();
        foreach CharMgr.IterateTemplates(IterateTemplate)
        {
            if (!ClassIsChildOf(IterateTemplate.Class, TemplateClass)) continue;

            CharMgr.FindDataTemplateAllDifficulties(IterateTemplate.DataName, DataTemplates);
            foreach DataTemplates(DataTemplate)
            {
                CDO.CallModifyTemplateFn(ModifyTemplateFn, DataTemplate);
            }
        }
    }
    else if (ClassIsChildOf(TemplateClass, class'X2StrategyElementTemplate'))
    {
        CDO = GetCDO();
        StratMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
        foreach StratMgr.IterateTemplates(IterateTemplate)
        {
            if (!ClassIsChildOf(IterateTemplate.Class, TemplateClass)) continue;

            StratMgr.FindDataTemplateAllDifficulties(IterateTemplate.DataName, DataTemplates);
            foreach DataTemplates(DataTemplate)
            {
                CDO.CallModifyTemplateFn(ModifyTemplateFn, DataTemplate);
            }
        }
    }
    else if (ClassIsChildOf(TemplateClass, class'X2SoldierClassTemplate'))
    {

        CDO = GetCDO();
        ClassMgr = class'X2SoldierClassTemplateManager'.static.GetSoldierClassTemplateManager();
        foreach ClassMgr.IterateTemplates(IterateTemplate)
        {
            if (!ClassIsChildOf(IterateTemplate.Class, TemplateClass)) continue;

            ClassMgr.FindDataTemplateAllDifficulties(IterateTemplate.DataName, DataTemplates);
            foreach DataTemplates(DataTemplate)
            {
                CDO.CallModifyTemplateFn(ModifyTemplateFn, DataTemplate);
            }
        }
    }    
}

static private function ModifyTemplateAllDiff(name TemplateName, class TemplateClass, delegate<ModifyTemplate> ModifyTemplateFn)
{
    local X2DataTemplate                                    DataTemplate;
    local array<X2DataTemplate>                             DataTemplates;
    local X2DLCInfo_RockClimber    CDO;

    local X2ItemTemplateManager             ItemMgr;
    local X2AbilityTemplateManager          AbilityMgr;
    local X2CharacterTemplateManager        CharMgr;
    local X2StrategyElementTemplateManager  StratMgr;
    local X2SoldierClassTemplateManager     ClassMgr;

    if (ClassIsChildOf(TemplateClass, class'X2ItemTemplate'))
    {
        ItemMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
        ItemMgr.FindDataTemplateAllDifficulties(TemplateName, DataTemplates);
    }
    else if (ClassIsChildOf(TemplateClass, class'X2AbilityTemplate'))
    {
        AbilityMgr = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
        AbilityMgr.FindDataTemplateAllDifficulties(TemplateName, DataTemplates);
    }
    else if (ClassIsChildOf(TemplateClass, class'X2CharacterTemplate'))
    {
        CharMgr = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();
        CharMgr.FindDataTemplateAllDifficulties(TemplateName, DataTemplates);
    }
    else if (ClassIsChildOf(TemplateClass, class'X2StrategyElementTemplate'))
    {
        StratMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
        StratMgr.FindDataTemplateAllDifficulties(TemplateName, DataTemplates);
    }
    else if (ClassIsChildOf(TemplateClass, class'X2SoldierClassTemplate'))
    {
        ClassMgr = class'X2SoldierClassTemplateManager'.static.GetSoldierClassTemplateManager();
        ClassMgr.FindDataTemplateAllDifficulties(TemplateName, DataTemplates);
    }
    else return;

    CDO = GetCDO();
    foreach DataTemplates(DataTemplate)
    {
        CDO.CallModifyTemplateFn(ModifyTemplateFn, DataTemplate);
    }
}

static private function X2DLCInfo_RockClimber GetCDO()
{
    return X2DLCInfo_RockClimber(class'XComEngine'.static.GetClassDefaultObjectByName(default.Class.Name));
}

protected function CallModifyTemplateFn(delegate<ModifyTemplate> ModifyTemplateFn, X2DataTemplate DataTemplate)
{
    ModifyTemplateFn(DataTemplate);
}