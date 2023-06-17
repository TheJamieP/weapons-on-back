ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        ESX = exports['es_extended']:getSharedObject()
        Citizen.Wait(0)
    end
end)

Slots = {{
    x = 0.075,
    y = -0.149,
    z = 0.14,
    x_rotation = 0,
    y_rotation = 0,
    z_rotation = 0,
    occupied = false,
    currentProp = nil,
    currentHandle = "",
}, {
    x = 0.075,
    y = -0.15,
    z = 0.044,
    x_rotation = 0.0,
    y_rotation = 0,
    z_rotation = 0,
    occupied = false,
    currentProp = nil,
    currentHandle = "",

}, {
    x = 0.075,
    y = -0.15,
    z = -0.04,
    x_rotation = 0.0,
    y_rotation = 0,
    z_rotation = 0,
    occupied = false,
    currentProp = nil,
    currentHandle = "",

}, {
    x = 0.075,
    y = -0.15,
    z = -0.14,
    x_rotation = 0.0,
    y_rotation = 0,
    z_rotation = 45,
    occupied = false,
    currentProp = nil,
    currentHandle = "",

},
{
    x = 0.075,
    y = -0.15,
    z = -0.14,
    x_rotation = 0,
    y_rotation = 0,
    z_rotation = 0,
    occupied = false,
    currentProp = nil,
    currentHandle = "",

}
}

local attachedWeapons = {}

Citizen.CreateThread(function()
    while not ESX.IsPlayerLoaded() do
        Wait(100)
    end
    local oldme = 0
    local carriedProps = {}
    while true do
        local me = GetPlayerPed(-1)
        carriedProps = HasProp()
        ---------------------------------------
        -- attach if player has large weapon --
        ---------------------------------------
        for name, hash in pairs(Config.prop_hashes) do
            for i = 1, #(Slots) do
                if not Slots[i].occupied and i <= #carriedProps then
                    if ((#carriedProps > 0) and (hash == carriedProps[i].Hash and carriedProps[i].Hash ~= Slots[i].currentProp )) then
                        if not attachedWeapons[name] and GetSelectedPedWeapon(me) ~= hash then
                            print("Creating weapon with hash: " .. carriedProps[i].Hash)
                            Slots[i].currentHandle = AttachProp(name, hash, Config.backbone, Slots[i].x,
                                Slots[i].y, Slots[i].z, Slots[i].x_rotation, Slots[i].y_rotation,
                                Slots[i].z_rotation)
                            Slots[i].occupied = true
                            Slots[i].currentProp = hash
                        end
                    end
                end
            end
            Wait(100)
        end

        --------------------------------------------
        -- remove from back if equipped / dropped --
        --------------------------------------------
        for key, attached_object in pairs(attachedWeapons) do
            if (GetSelectedPedWeapon(me) == attached_object.hash) or (TableContainsHash(carriedProps, attached_object.hash) <= 0) 
            or (me ~= oldme) then
                DeleteObject(attached_object.handle)
                attachedWeapons[key] = nil
                for i = 1, #(Slots) do
                    if Slots[i].currentHandle == attached_object.handle then
                        Slots[i].occupied = false
                        Slots[i].currentProp = nil 
                        Slots[i].currentHandle = ""
                        
                    end
                end

            end
        end
        oldme = me
        Wait(100)
    end
end)
-- carriedProps
function HasProp()
    local inventory = ESX.GetPlayerData().inventory
    if inventory then
        local props = {}
        for __,v in pairs(inventory) do
            if v.name ~= nil then
                if string.sub(v.name, 1, 6) == "WEAPON" and TableContainsHash(props, GetHashKey(v.name)) < 2 then
                    props[1 + #props] = {
                        Hash = GetHashKey(v.name),
                        Handle = nil,
                        Type = "WEAPON"
                    }  
                elseif v.name == "marijuana" then
                    props[1 + #props] = {
                        Hash = GetHashKey(v.name),
                        Handle = nil,
                        Type = "WEED"
                    }
                end    
            end         
        end
        return props
    end

end

function AttachProp(attachModel, modelHash, boneNumber, x, y, z, xR, yR, zR)
    local bone = GetPedBoneIndex(GetPlayerPed(-1), boneNumber)
    RequestModel(attachModel)
    while not HasModelLoaded(attachModel) do
        print("Waiting on model...")
        Wait(100)
    end
    attachedWeapons[attachModel] = {
        hash = modelHash,
        handle = CreateObject(GetHashKey(attachModel), 1.0, 1.0, 1.0, true, true, false)
    }

    AttachEntityToEntity(attachedWeapons[attachModel].handle, GetPlayerPed(-1), bone, x, y, z, xR, yR, zR, 1, 1, 0, 0,
        2, 1)
    return attachedWeapons[attachModel].handle
end

function TableContainsHash(table, hash)
    local counter = 0
    for __, v in pairs(table) do
        if v.Hash == hash then counter = counter + 1 end
    end
    return counter
end
    