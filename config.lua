Config = {}

-- the hashes and prop names of the weapons that can be slung
Config.prop_hashes = {
    -- melee:
    -- ["prop_golf_iron_01"] = 1141786504, -- positioning still needs work
    ["w_me_bat"] = GetHashKey("WEAPON_BAT"),
    ["prop_ld_w_me_machette"] = GetHashKey("WEAPON_MACHETE"),
    -- ["prop_ld_jerrycan_01"] = 883325847,
    -- assault rifles:
    ["w_ar_carbinerifle"] = GetHashKey("WEAPON_CARBINERIFLE"),
    ["w_ar_carbineriflemk2"] = GetHashKey("WEAPON_CARBINERIFLE_MK2"),
    ["w_ar_assaultrifle"] = GetHashKey("WEAPON_ASSAULTRIFLE"),
    ["w_ar_specialcarbine"] = GetHashKey("WEAPON_SPECIALCARBINE"),
    ["w_ar_bullpuprifle"] = GetHashKey("WEAPON_BULLPUPRIFLE"),
    ["w_ar_advancedrifle"] = GetHashKey("WEAPON_ADVANCEDRIFLE"),
    -- sub machine guns:
    ["w_sb_microsmg"] = GetHashKey("WEAPON_MICROSMG"),
    ["w_sb_assaultsmg"] = GetHashKey("WEAPON_ASSAULTSMG"),
    ["w_sb_smg"] = GetHashKey("WEAPON_SMG"),
    ["w_sb_smgmk2"] = GetHashKey("WEAPON_SMG_MK2"),
    ["w_sb_gusenberg"] = GetHashKey("WEAPON_GUSENBERG"),
    -- sniper rifles:
    ["w_sr_sniperrifle"] = GetHashKey("WEAPON_SNIPERRIFLE"),
    -- shotguns:
    ["w_sg_assaultshotgun"] = GetHashKey("WEAPON_ASSAULTSHOTGUN"),
    ["w_sg_bullpupshotgun"] = GetHashKey("WEAPON_BULLPUPSHOTGUN"),
    ["w_sg_pumpshotgun"] = GetHashKey("WEAPON_PUMPSHOTGUN"),
    ["w_ar_musket"] = GetHashKey("WEAPON_MUSKET"),
    ["w_sg_heavyshotgun"] = GetHashKey("WEAPON_HEAVYSHOTGUN"),
    -- ["w_sg_sawnoff"] = 2017895192 don't show, maybe too small?
    -- launchers:
    ["w_lr_firework"] = GetHashKey("WEAPON_FIREWORK"),
    ["w_ar_famas"] = GetHashKey("WEAPON_FAMAS"),

    -- OBJECT -- 
    ["bkr_prop_weed_drying_01a"] = GetHashKey("marijuana")
}
-- the backbone where the weapon is attached to
Config.backbone = 24816
