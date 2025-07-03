local CreateParty = game:GetService("ReplicatedStorage").Shared.Network.RemoteEvent.CreateParty
local HRP = game.Players.LocalPlayer.Character.HumanoidRootPart
local TeleportService = game:GetService("TeleportService")
local FoundLobby = false
local PlaceId = game.PlaceId

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

            -- Проверка создания лобби
            local elapsedTime = 0
            local lobbyCreated = false
            while elapsedTime < 20 do
                task.wait(1)
                elapsedTime = elapsedTime + 1
                -- Проверяем, изменился ли статус (предполагаем, что статус меняется при создании лобби)
                if v.BillboardGui and v.BillboardGui:FindFirstChild("StatusLabel") then
                    local status = v.BillboardGui.StatusLabel.Text
                    if status ~= "Waiting for players..." then
                        print("Lobby created! Status: " .. status)
                        lobbyCreated = true
                        break
                    end
                else
                    print("BillboardGui or StatusLabel missing, assuming lobby creation failed.")
                    break
                end
            end

            -- Если лобби не создалось через 20 секунд, хопаем сервер
            if not lobbyCreated then
                print("Lobby not created after 20 seconds, initiating server hop...")
                TeleportService:Teleport(PlaceId, game.Players.LocalPlayer)
            else
                print("Lobby successfully created, no server hop needed.")
            end
            break
        end
    end
    task.wait()
end
