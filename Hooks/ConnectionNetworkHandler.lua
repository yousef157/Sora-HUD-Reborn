NepHook:Post(ConnectionNetworkHandler, "sync_outfit", function()
    LuaNetworking:SendToPeers("nephud_teammate_bg", tostring(NepgearsyHUDReborn:GetOption("TeammateSkin")))
end)