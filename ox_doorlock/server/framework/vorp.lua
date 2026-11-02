local resourceName = 'vorp_core'

if not GetResourceState(resourceName):find('start') then return end

local _VORPcore = nil
local function getCore()
    if not _VORPcore then
        _VORPcore = exports['vorp_core']:GetCore()
    end
    return _VORPcore
end

GetPlayer = function(source)
    return getCore().getUser(source)
end

function GetCharacterId(user)
    return user.getUsedCharacter.charIdentifier
end

function IsPlayerInGroup(user, filter)
    local character = user.getUsedCharacter
    local job = character.job or ''
    local jobgrade = character.jobGrade or 0
    local _type = type(filter)

    if _type == 'string' then
        if job == filter then
            return job, jobgrade
        end
    else
        local tabletype = table.type(filter)

        if tabletype == 'hash' then
            local grade = filter[job]
            if grade and grade <= jobgrade then
                return job, jobgrade
            end
        elseif tabletype == 'array' then
            for i = 1, #filter do
                if filter[i] == job then
                    return job, jobgrade
                end
            end
        end
    end
end

function DoesPlayerHaveItem(user, items, removeItem)
    local source = user.source

    for i = 1, #items do
        local item = items[i]
        local itemName = item.name or item
        local count = exports['vorp_inventory']:getItemCount(source, nil, itemName)

        if count and count > 0 then
            if removeItem or item.remove then
                exports['vorp_inventory']:subItem(source, itemName, 1, nil, nil)
            end
            return itemName
        end
    end
end

function RemoveItem(source, item)
    exports['vorp_inventory']:subItem(source, item, 1, nil, nil)
end
