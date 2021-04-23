btc_custom_loc = [
/*
    DESCRIPTION: [POS(Array),TYPE(String),NAME(String),RADIUS (Number),IS OCCUPIED(Bool)]
    Possible types: "NameVillage","NameCity","NameCityCapital","NameLocal","Hill","Airport","NameMarine", "StrongpointArea", "BorderCrossing", "VegetationFir"
    EXAMPLE: [[13132.8,3315.07,0.00128174],"NameVillage","Mountain 1",800,true]
*/
];

/*
    Here you can specify which equipment should be added or removed from the arsenal.
    Please take care that there are different categories (weapons, magazines, items, backpacks) for different pieces of equipment into which you have to classify the classnames.
    In all cases, you need the classname of an object.

    Attention: The function of these lists depends on the setting in the mission parameter (Restrict arsenal).
        - "Full": here you have only the registered items in the arsenal available.
        - "Remove only": here all registered items are removed from the arsenal. This only works for the ACE3 arsenal!

    Example(s):
        private _weapons = [
            "arifle_MX_F",          //Classname for the rifle MX
            "arifle_MX_SW_F",       //Classname for the rifle MX LSW
            "arifle_MXC_F"          //Classname for the rifle MXC
        ];

        private _items = [
            "G_Shades_Black",
            "G_Shades_Blue",
            "G_Shades_Green"
        ];
*/

private _weapons = [
    "SMG_03C_TR_black",
    "arifle_G36C_F",
    "arifle_G36_F",
    "hgun_G17_black_F",
    "launch_NLAW_F",
    "srifle_GM6_F",
    "sgun_M4_F",
    "ACE_Flashlight_Maglite_ML300L",
    "ACE_VMM3",
    "ACE_VMH3"
    ];
private _magazines = [
    "ACE_Flashlight_XL50",
    "ACE_EntrenchingTool",
    "DemoCharge_Remote_Mag",
    "SatchelCharge_Remote_Mag",
    "ACE_M14",
    "B_IR_Grenade",
    "ACE_HandFlare_Green",
    "ACE_Chemlight_HiBlue",
    "ACE_CTS9"
    ];
private _items = [
    "ACE_epinephrine",
    "ACE_tourniquet",
    "ACE_splint",
    "ACE_surgicalKit",
    "ACE_morphine",
    "ACE_salineIV",
    "ACE_packingBandage",
    "ACE_elasticBandage",
    "NVGoggles_OPFOR"
    ];
private _backpacks = [
    "B_LegStrapBag_black_F",
    "B_CivilianBackpack_01_Sport_Red_F",
    "Police_I_P_UGV_02_Demining_backpack_F",
    "B_AssaultPack_Blk",
    "B_Respawn_Sleeping_bag_blue_F",
    "B_Carryall_blk",
    "B_CivilianBackpack_01_Everyday_Black_F",
    "ace_gunbag",
    "B_Kitbag_blk",
    "B_RadioBag_001_black_F",
    "I_E_UAV_01_backpack_F",
    "I_E_UAV_06_backpack_F",
    "I_E_UAV_06_medical_backpack_F"
];

// Add faction-specific stuff because I'm lazy
_cfgHash = [['Police_IND_P_F'], ['C_Man_Paramedic_01_F','C_Story_EOD_01_F']] call compile preprocessFileLineNumbers "core\fnc\arsenal\fn_getFactionData.sqf";
_weapons append (_cfgHash get "weapons");
_magazines append (_cfgHash get "magazines");
_items append (_cfgHash get "items");
_backpacks append (_cfgHash get "backpacks");
_items append (_cfgHash get "attachments");
_items append (_cfgHash get "uniforms");

// Add magazines for weapons defined in this file
{
    _magazines append getArray (configfile >> "CfgWeapons" >> _x >> 'magazines');
} forEach _weapons;

btc_custom_arsenal = [_weapons, _magazines, _items, _backpacks];

/*
    Here you can specify which equipment is loaded on player connection.
*/

private _radio = ["tf_anprc152", "ACRE_PRC148"] select (isClass(configFile >> "cfgPatches" >> "acre_main"));
//Array of colored item: 0 - Desert, 1 - Tropic, 2 - Black, 3 - forest
private _uniforms = ["U_Marshal", "U_C_Journalist", "Police_U_I_P_PoliceUniform_F", "U_C_Paramedic_01_F"];
private _uniformsCBRN = ["U_C_CBRN_Suit_01_Blue_F", "U_C_CBRN_Suit_01_Blue_F", "U_C_CBRN_Suit_01_Blue_F", "U_C_CBRN_Suit_01_Blue_F"];
private _uniformsSniper = ["U_B_FullGhillie_sard", "U_B_FullGhillie_lsh", "U_B_T_FullGhillie_tna_F", "U_B_T_FullGhillie_tna_F"];
private _vests = ["V_TacVest_blk", "V_TacVest_blk", "V_CarrierRigKBT_01_light_POLICE_F", "V_TacVest_blk"];
private _helmets = ["H_Beret_blk_POLICE", "H_Cap_police", "H_HelmetSpecter_black_headset_F", "H_Cap_red"];
private _hoods = ["G_WirelessEarpiece_F", "G_WirelessEarpiece_F", "G_Combat_Goggles_blk_F", "G_WirelessEarpiece_F"];
private _hoodCBRN = "G_AirPurifyingRespirator_01_F";
private _laserdesignators = ["Laserdesignator", "Laserdesignator_03", "Laserdesignator_01_khk_F", "Laserdesignator_01_khk_F"];
private _night_visions = ["NVGoggles", "NVGoggles_INDEP", "NVGoggles_OPFOR", "NVGoggles_INDEP"];
private _weapons = ["SMG_03C_TR_black", "SMG_03C_TR_black", "arifle_G36C_F", "SMG_03C_TR_black"];
private _weapons_machineGunner = ["arifle_G36C_F", "arifle_G36C_F", "arifle_G36C_F", "arifle_G36C_F"];
private _weapons_sniper = ["arifle_G36C_F", "arifle_G36C_F", "arifle_G36C_F", "arifle_G36C_F"];
private _bipods = ["bipod_01_F_snd", "bipod_01_F_khk", "bipod_01_F_blk", "bipod_01_F_blk"];
private _pistols = ["hgun_G17_black_F", "hgun_G17_black_F", "hgun_G17_black_F", "hgun_G17_black_F"];
private _launcher_AT = ["launch_B_Titan_short_F", "launch_B_Titan_short_tna_F", "launch_O_Titan_short_F", "launch_B_Titan_short_tna_F"];
private _launcher_AA = ["launch_B_Titan_F", "launch_B_Titan_tna_F", "launch_O_Titan_F", "launch_B_Titan_tna_F"];
private _backpacks = ["B_LegStrapBag_black_F", "B_LegStrapBag_black_F", "B_LegStrapBag_black_F", "B_LegStrapBag_black_F"];
private _backpacks_big = ["B_LegStrapBag_black_F", "B_LegStrapBag_black_F", "B_LegStrapBag_black_F", "B_LegStrapBag_black_F"];
private _backpackCBRN = "B_CombinationUnitRespirator_01_F";

btc_arsenal_loadout = [_uniforms, _uniformsCBRN, _uniformsSniper, _vests, _helmets, _hoods, [_hoodCBRN, _hoodCBRN, _hoodCBRN, _hoodCBRN], _laserdesignators, _night_visions, _weapons, _weapons_sniper, _weapons_machineGunner, _bipods, _pistols, _launcher_AT, _launcher_AA, _backpacks, _backpacks_big, [_backpackCBRN, _backpackCBRN, _backpackCBRN, _backpackCBRN], [_radio, _radio, _radio, _radio]];
