NepHook:Post(StatisticsManager, "killed", function()
    managers.hud._hud_assault_corner.totalKilledSession = managers.hud._hud_assault_corner.totalKilledSession + 1

    local total_killed = managers.hud._hud_assault_corner.totalKilledSession
    managers.hud._hud_assault_corner.killTrackerAmount:set_text(tostring(total_killed))

    if NepgearsyHUDReborn:GetOption("DiscordRichPresenceType") == 2 then
        NepgearsyHUDReborn:SetDiscordPresence("/// Killing in Progress ///", total_killed .. " kills", true, false)
    end
end)