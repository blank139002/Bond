local CreateParty = game:GetService("ReplicatedStorage").Shared.Network.RemoteEvent.CreateParty
local HRP = game.Players.LocalPlayer.Character.HumanoidRootPart
local TeleportService = game:GetService("TeleportService")
local FoundLobby = false
local CurrentPlaceId = game.PlaceId

while not FoundLobby do
    print("Finding Lobby...")
    for _, v in pairs(game:GetService("Workspace").PartyZones:GetChildren()) do
        if v.Name:match("PartyZone") and v:FindFirstChild("BillboardGui") and v.BillboardGui:FindFirstChild("StatusLabel") and v.BillboardGui.StatusLabel.Text == "Waiting for players..." then
            print("Lobby Found!")
            HRP.CFrame = v:FindFirstChild("Hitbox").CFrame
            FoundLobby = true
            task.wait(0.1)
            local args = {
                {
                    isPrivate = true,
                    maxMembers = 1,
                    trainId = "default",
                    gameMode = "Normal"
                }
            }
            CreateParty:FireServer(unpack(args))
            print("Party creation requested...")

            -- Сохраняем текущий PlaceId после создания лобби
            local initialPlaceId = game.PlaceId
            local elapsedTime = 0

            -- Ожидание 20 секунд и проверка PlaceId
            while elapsedTime < 20 do
                task.wait(1)
                elapsedTime = elapsedTime + 1
                -- Проверяем, изменился ли PlaceId
                if game.PlaceId ~= initialPlaceId then
                    print("PlaceId changed to " .. game.PlaceId .. ", no server hop needed.")
                    return -- Прерываем, если PlaceId изменился
                end
                -- Проверяем статус лобби для отладки
                if v.BillboardGui and v.BillboardGui:FindFirstChild("StatusLabel") then
                    local status = v.BillboardGui.StatusLabel.Text
                    if status ~= "Waiting for players..." then
                        print("Lobby status changed: " .. status)
                    end
                else
                    print("BillboardGui or StatusLabel missing.")
                end
            end

            -- Если PlaceId не изменился через 20 секунд, хопаем сервер
            if game.PlaceId == initialPlaceId then
                print("PlaceId did not change after 20 seconds, initiating server hop...")
                TeleportService:Teleport(CurrentPlaceId, game.Players.LocalPlayer)
            else
                print("PlaceId changed, no server hop needed.")
            end
            break
        end
    end
    task.wait()
end
