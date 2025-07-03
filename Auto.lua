--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
local CreateParty = game:GetService("ReplicatedStorage").Shared.Network.RemoteEvent.CreateParty
local HRP = game.Players.LocalPlayer.Character.HumanoidRootPart

while true do
    print("Finding Lobby...")
    for _, v in pairs(game:GetService("Workspace").PartyZones:GetChildren()) do
        if v.Name:match("PartyZone") and v:FindFirstChild("BillboardGui") and v.BillboardGui:FindFirstChild("StatusLabel") and v.BillboardGui.StatusLabel.Text == "Waiting for players..." then
            print("Lobby Found!")
            -- Телепортация к лобби
            HRP.CFrame = v:FindFirstChild("Hitbox").CFrame
            task.wait(0.1)
            -- Попытка создать приватное лобби
            local args = {
                {
                    isPrivate = true,
                    maxMembers = 1,
                    trainId = "default",
                    gameMode = "Normal"
                }
            }
            local success, result = pcall(function()
                CreateParty:FireServer(unpack(args))
            end)
            
            if success then
                print("Party Created Successfully!")
            else
                print("Failed to create party, continuing search...")
            end
        end
    end
    task.wait(0.5) -- Задержка между проверками лобби
end
