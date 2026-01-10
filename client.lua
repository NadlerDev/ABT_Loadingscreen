local isLoadingComplete = false
local loadingProgress = 0
local loadingSteps = {
    { name = 'Connecting to server...', progress = 10 },
    { name = 'Loading game files...',   progress = 25 },
    { name = 'Loading map...',          progress = 45 },
    { name = 'Spawning player...',      progress = 65 },
    { name = 'Loading resources...',    progress = 85 },
    { name = 'Almost ready...',         progress = 95 },
}

local currentStep = 1

Citizen.CreateThread(function()
    Citizen.Wait(500)
    while not isLoadingComplete and currentStep <= #loadingSteps do
        local step = loadingSteps[currentStep]
        SendLoadingScreenMessage(json.encode({
            eventName = 'updateProgress',
            progress = step.progress,
            message = step.name
        }))
        loadingProgress = step.progress
        currentStep = currentStep + 1
        Citizen.Wait(math.random(2000, 4000))
    end

    if not isLoadingComplete then
        Citizen.Wait(1000)
        SendLoadingScreenMessage(json.encode({
            eventName = 'updateProgress',
            progress = 100,
            message = 'Ready!'
        }))
    end
end)

AddEventHandler('playerSpawned', function()
    if not isLoadingComplete then
        isLoadingComplete = true
        SendLoadingScreenMessage(json.encode({
            eventName = 'updateProgress',
            progress = 100,
            message = 'Complete!'
        }))
        TriggerEvent('multichar:client:openMultiChar')
        Citizen.Wait(1000)
        ShutdownLoadingScreen()
        ShutdownLoadingScreenNui()
    end
end)

AddEventHandler('onClientResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        print('[Loading Screen] Started')
    end
end)

RegisterNUICallback('loadingComplete', function(data, cb)
    if not isLoadingComplete then
        isLoadingComplete = true
        Citizen.Wait(500)
        ShutdownLoadingScreen()
        ShutdownLoadingScreenNui()
    end
    cb('ok')
end)

Citizen.CreateThread(function()
    Citizen.Wait(45000)
    if not isLoadingComplete then
        isLoadingComplete = true
        SendLoadingScreenMessage(json.encode({
            eventName = 'updateProgress',
            progress = 100,
            message = 'Loading complete!'
        }))
        Citizen.Wait(500)
        ShutdownLoadingScreen()
        ShutdownLoadingScreenNui()
    end
end)
