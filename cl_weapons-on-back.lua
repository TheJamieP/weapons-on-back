ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end
end)

local SETTINGS = {
    back_bone = 24816,
    slots = {{
        x = 0.075,
        y = -0.149,
        z = 0.14,
        x_rotation = 0.0,
        y_rotation = 0,
        z_rotation = 0.0,
        occupied = false,
        current_weapon = nil,
        current_handle = ""
    }, {
        x = 0.075,
        y = -0.15,
        z = 0.04,
        x_rotation = 0.0,
        y_rotation = 0,
        z_rotation = 0.0,
        occupied = false,
        current_weapon = nil,
        current_handle = ""
    }, {
        x = 0.075,
        y = -0.15,
        z = -0.04,
        x_rotation = 0.0,
        y_rotation = 0,
        z_rotation = -0.04,
        occupied = false,
        current_weapon = nil,
        current_handle = ""
    }, {
        x = 0.075,
        y = -0.15,
        z = -0.14,
        x_rotation = 0.0,
        y_rotation = 0,
        z_rotation = 0.0,
        occupied = false,
        current_weapon = nil,
        current_handle = ""
    }},

    compatable_weapon_hashes = {
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
}
local carried_guns = {}
local attached_weapons = {}
local ox_inventory = exports.ox_inventory
local slingable_guns = {"weapon_bat", "weapon_carbinerifle", "weapon_carbineriflemk2", "weapon_assaultrifle",
                        "weapon_specialcarbine", "weapon_bullpuprifle", "weapon_advancedrifle", "weapon_microsmg",
                        "weapon_assaultsmg", "weapon_smg", "weapon_smgmk2", "weapon_gusenberg", "weapon_sniperrifle",
                        "weapon_assaultshotgun", "weapon_bullpupshotgun", "weapon_pumpshotgun", "weapon_musket",
                        "weapon_heavyshotgun"}
Citizen.CreateThread(function()
    Wait(1500)
    while true do
        local me = GetPlayerPed(-1)
        local gunBool = hasGun()

        ---------------------------------------
        -- attach if player has large weapon --
        ---------------------------------------

        for wep_name, wep_hash in pairs(SETTINGS.compatable_weapon_hashes) do

            for i = 1, #(SETTINGS.slots) do
                if not SETTINGS.slots[i].occupied then
                    Wait(1)
                    for i = 1, 4 do
                        if (gunBool and
                            (carried_guns[i] == wep_hash and carried_guns[i] ~= SETTINGS.slots[i].current_weapon)) then

                            if not attached_weapons[wep_name] and GetSelectedPedWeapon(me) ~= wep_hash then
                                SETTINGS.slots[i].current_handle =
                                    AttachWeapon(wep_name, wep_hash, SETTINGS.back_bone, SETTINGS.slots[i].x,
                                        SETTINGS.slots[i].y, SETTINGS.slots[i].z, SETTINGS.slots[i].x_rotation,
                                        SETTINGS.slots[i].y_rotation, SETTINGS.slots[i].z_rotation,
                                        isMeleeWeapon(wep_name))
                                SETTINGS.slots[i].occupied = true
                                SETTINGS.slots[i].current_weapon = wep_hash

                            end
                        end
                    end
                end
            end
        end

        --------------------------------------------
        -- remove from back if equipped / dropped --
        --------------------------------------------
        for key, attached_object in pairs(attached_weapons) do
            if (GetSelectedPedWeapon(me) == attached_object.hash) or (not checkTable(attached_object.hash)) then
                DeleteObject(attached_object.handle)
                attached_weapons[key] = nil
                for i = 1, #(SETTINGS.slots) do
                    if SETTINGS.slots[i].current_handle == attached_object.handle then
                        SETTINGS.slots[i].occupied = false
                        SETTINGS.slots[i].current_weapon = nil
                        SETTINGS.slots[i].current_handle = ""

                    end
                end

            end
        end

    end

    Wait(1000)
end)
function checkTable(hash)
    for int, carried_gunsHash in pairs(carried_guns) do
        if carried_gunsHash == hash then
            return true
        end
    end
    return false
end

-- carried_guns
function hasGun()
    local inventory = ox_inventory:Search('count', slingable_guns)
    if inventory then
        carried_guns = {}
        for i = 1, #SETTINGS.slots do
            for name, count in pairs(inventory) do
                if count >= 1 then
                    table.insert(carried_guns, i, GetHashKey(name))
                end
            end
            return true

        end
    end

end

function AttachWeapon(attachModel, modelHash, boneNumber, x, y, z, xR, yR, zR, isMelee)
    local bone = GetPedBoneIndex(GetPlayerPed(-1), boneNumber)
    RequestModel(attachModel)
    while not HasModelLoaded(attachModel) do
        Wait(100)
    end

    attached_weapons[attachModel] = {
        hash = modelHash,
        handle = CreateObject(GetHashKey(attachModel), 1.0, 1.0, 1.0, true, true, false)
    }

    if isMelee then
        xR = -90.0
        yR = 185.0
        zR = 92.0
    end -- reposition for melee items
    if attachModel == "prop_ld_jerrycan_01" then
        x = x + 0.3
    end
    AttachEntityToEntity(attached_weapons[attachModel].handle, GetPlayerPed(-1), bone, x, y, z, xR, yR, zR, 1, 1, 0, 0,
        2, 1)
    return attached_weapons[attachModel].handle
end

function isMeleeWeapon(wep_name)
    if wep_name == "prop_golf_iron_01" then
        return true
    elseif wep_name == "w_me_bat" then
        return true
    elseif wep_name == "prop_ld_jerrycan_01" then
        return true
    else
        return false
    end
end
