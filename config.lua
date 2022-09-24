Config = {}

-- The possible items that can be slung (must be in the inventory)
Config.slingable_guns = {"weapon_bat", "weapon_carbinerifle", "weapon_carbineriflemk2", "weapon_assaultrifle",
                         "weapon_specialcarbine", "weapon_bullpuprifle", "weapon_advancedrifle", "weapon_microsmg",
                         "weapon_assaultsmg", "weapon_smg", "weapon_smgmk2", "weapon_gusenberg", "weapon_sniperrifle",
                         "weapon_assaultshotgun", "weapon_bullpupshotgun", "weapon_pumpshotgun", "weapon_musket",
                         "weapon_heavyshotgun"}

-- the hashes and prop names of the weapons that can be slung
Config.compatable_weapon_hashes = {
    -- melee:
    -- ["prop_golf_iron_01"] = 1141786504, -- positioning still needs work
    ["w_me_bat"] = -1786099057,
    -- ["prop_ld_jerrycan_01"] = 883325847,
    -- assault rifles:
    ["w_ar_carbinerifle"] = -2084633992,
    ["w_ar_carbineriflemk2"] = GetHashKey("WEAPON_CARBINERIFLE_MK2"),
    ["w_ar_assaultrifle"] = -1074790547,
    ["w_ar_specialcarbine"] = -1063057011,
    ["w_ar_bullpuprifle"] = 2132975508,
    ["w_ar_advancedrifle"] = -1357824103,
    -- sub machine guns:
    ["w_sb_microsmg"] = 324215364,
    ["w_sb_assaultsmg"] = -270015777,
    ["w_sb_smg"] = 736523883,
    ["w_sb_smgmk2"] = GetHashKey("WEAPON_SMG_MK2"),
    ["w_sb_gusenberg"] = 1627465347,
    -- sniper rifles:
    ["w_sr_sniperrifle"] = 100416529,
    -- shotguns:
    ["w_sg_assaultshotgun"] = -494615257,
    ["w_sg_bullpupshotgun"] = -1654528753,
    ["w_sg_pumpshotgun"] = 487013001,
    ["w_ar_musket"] = -1466123874,
    ["w_sg_heavyshotgun"] = GetHashKey("WEAPON_HEAVYSHOTGUN"),
    -- ["w_sg_sawnoff"] = 2017895192 don't show, maybe too small?
    -- launchers:
    ["w_lr_firework"] = 2138347493,
    ["w_ar_famas"] = GetHashKey("WEAPON_FAMAS")
}
-- the backbone where the weapon is attached to
Config.backbone = 24816
