local QBCore = exports['qb-core']:GetCoreObject()

local function LoadProp(model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(10)
    end
end

local function AttachProp(ped, model)
    LoadProp(model)
    local prop = CreateObject(GetHashKey(model), GetEntityCoords(ped), true, true, true)
    AttachEntityToEntity(prop, ped, GetPedBoneIndex(ped, 60309), 0.1, 0.02, -0.03, 90.0, 80.0, 0.0, true, true, false, true, 1, true)
    return prop
end

RegisterNetEvent("goldmining:client:startMining", function()
    local ped = PlayerPedId()
    ClearPedTasks(ped)
    local prop = AttachProp(ped, "prop_tool_shovel")
    TaskStartScenarioInPlace(ped, "WORLD_HUMAN_CONST_DRILL", 0, true)
    QBCore.Functions.Progressbar("mining_gold", "Đang đãi vàng...", 5000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function()
        ClearPedTasks(ped)
        DeleteEntity(prop)
        TriggerServerEvent("goldmining:server:reward")
    end, function()
        ClearPedTasks(ped)
        DeleteEntity(prop)
        QBCore.Functions.Notify("Bạn đã huỷ đãi vàng!", "error")
    end)
end)

CreateThread(function()
    exports['qb-target']:AddBoxZone("gold_melt_zone", Config.MeltLocation, 1.5, 1.5, {
        name="gold_melt_zone",
        heading=0,
        debugPoly=false,
        minZ=29.0,
        maxZ=32.0,
    }, {
        options = {
            {
                label = "Nấu vàng thô",
                icon = "fas fa-fire",
                action = function()
                    TriggerEvent("goldmining:client:meltGold")
                end,
            },
        },
        distance = 2.0
    })

    exports['qb-target']:AddBoxZone("gold_sell_zone", Config.SellLocation, 1.5, 1.5, {
        name="gold_sell_zone",
        heading=0,
        debugPoly=false,
        minZ=28.0,
        maxZ=31.0,
    }, {
        options = {
            {
                label = "Bán thỏi vàng",
                icon = "fas fa-coins",
                action = function()
                    TriggerServerEvent("goldmining:server:sellGold")
                end,
            },
        },
        distance = 2.0
    })
end)

RegisterNetEvent("goldmining:client:meltGold", function()
    local ped = PlayerPedId()
    TaskStartScenarioInPlace(ped, "PROP_HUMAN_BUM_BIN", 0, true)
    QBCore.Functions.Progressbar("melt_gold", "Đang nấu vàng...", 5000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function()
        ClearPedTasks(ped)
        TriggerServerEvent("goldmining:server:convertOre")
    end, function()
        ClearPedTasks(ped)
        QBCore.Functions.Notify("Bạn đã huỷ quá trình nấu vàng!", "error")
    end)
end)
