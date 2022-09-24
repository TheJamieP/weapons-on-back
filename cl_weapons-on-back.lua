ESX = nil
-----------------------------------------------------------------
--             888                                 888         -- 
--             888                                 888         -- 
--             888                                 888         -- 
--    .d8888b  88888b.   .d88b.   .d88b.  .d8888b  88888b.     -- 
--    88K      888 "88b d8P  Y8b d8P  Y8b 88K      888 "88b    -- 
--    "Y8888b. 888  888 88888888 88888888 "Y8888b. 888  888    -- 
--         X88 888  888 Y8b.     Y8b.          X88 888  888    -- 
--     88888P' 888  888  "Y8888   "Y8888   88888P' 888  888    --
----------------------------------------------------------------- 

Citizen.CreateThread(function()
    while ESX == nil do
        ESX = exports['es_extended']:getSharedObject()
        Citizen.Wait(0)
    end
end)

slots = {{
    x = 0.075,
    y = -0.149,
    z = 0.14,
    x_rotation = 0,
    y_rotation = 0,
    z_rotation = 0,
    occupied = false,
    current_weapon = nil,
    current_handle = ""
}, {
    x = 0.075,
    y = -0.15,
    z = 0.044,
    x_rotation = 0.0,
    y_rotation = 0,
    z_rotation = 0,
    occupied = false,
    current_weapon = nil,
    current_handle = ""
}, {
    x = 0.075,
    y = -0.15,
    z = -0.04,
    x_rotation = 0.0,
    y_rotation = 0,
    z_rotation = 0,
    occupied = false,
    current_weapon = nil,
    current_handle = ""
}, {
    x = 0.075,
    y = -0.15,
    z = -0.14,
    x_rotation = 0.0,
    y_rotation = 0,
    z_rotation = 45,
    occupied = false,
    current_weapon = nil,
    current_handle = ""
}}

local carried_guns = {}
local attached_weapons = {}

Citizen.CreateThread(function()
    Wait(500)
    -- check if player is laoded
    while not ESX.IsPlayerLoaded() do
        Wait(100)
    end
    local oldme = 0
    while true do
        local me = GetPlayerPed(-1)
        local gunBool = hasGun()

        ---------------------------------------
        -- attach if player has large weapon --
        ---------------------------------------

        for wep_name, wep_hash in pairs(Config.compatable_weapon_hashes) do

            for i = 1, #(slots) do
                if not slots[i].occupied then

                    for i = 1, #slots do
                        if (gunBool and (carried_guns[i] == wep_hash and carried_guns[i] ~= slots[i].current_weapon)) then

                            if not attached_weapons[wep_name] and GetSelectedPedWeapon(me) ~= wep_hash then
                                slots[i].current_handle = AttachWeapon(wep_name, wep_hash, Config.backbone, slots[i].x,
                                    slots[i].y, slots[i].z, slots[i].x_rotation, slots[i].y_rotation,
                                    slots[i].z_rotation, isMeleeWeapon(wep_name))
                                slots[i].occupied = true
                                slots[i].current_weapon = wep_hash

                            end
                        end
                    end
                end
            end
            Wait(10)
        end

        --------------------------------------------
        -- remove from back if equipped / dropped --
        --------------------------------------------
        for key, attached_object in pairs(attached_weapons) do
            if (GetSelectedPedWeapon(me) == attached_object.hash) or (not checkTable(attached_object.hash)) or me ~=
                oldme then
                DeleteObject(attached_object.handle)
                attached_weapons[key] = nil
                for i = 1, #(slots) do
                    if slots[i].current_handle == attached_object.handle then
                        slots[i].occupied = false
                        slots[i].current_weapon = nil
                        slots[i].current_handle = ""

                    end
                end

            end
        end
        oldme = me

    end
    Wait(100)
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

    local inventory = exports.ox_inventory:Search('count', Config.slingable_guns)
    if inventory then
        carried_guns = {}
        for i = 1, #slots do
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
