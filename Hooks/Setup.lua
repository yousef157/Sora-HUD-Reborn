NepHook:Pre(Setup, "init_managers", function()
    local peer_colors = {
        NepgearsyHUDReborn:GetOption("SoraPeerOneColor"),
        NepgearsyHUDReborn:GetOption("SoraPeerTwoColor"),
        NepgearsyHUDReborn:GetOption("SoraPeerThreeColor"),
        NepgearsyHUDReborn:GetOption("SoraPeerFourColor"),
        NepgearsyHUDReborn:GetOption("SoraAIColor")
    }

    for i, c in ipairs(peer_colors) do
        tweak_data.chat_colors[i] = c
        tweak_data.preplanning_peer_colors[i] = c
    end

    if NepgearsyHUDReborn:GetOption("UseDiscordRichPresence") then
        Discord:init("597345010656215041")
    end
end)