local star = function()
    local blackscreen = managers.hud and managers.hud._hud_blackscreen
    return blackscreen and blackscreen._blackscreen_panel and blackscreen._blackscreen_panel:child("starring_panel")
end

if NepgearsyHUDReborn:GetOption("EnableStarring") then
    NepHook:Post(HUDMissionBriefing, "init", function(self)
        self._player = {}
        self._custom_starring = {}

        for i = 1, 4 do
            self._player[i],         -- Steam ID for avatars
            self._custom_starring[i] -- Stock the starring in a string then modify the panel if it's not empty
            = "0", ""
        end
        -- FUCK YOU OVERKILL
        -- Especially about the part of calling set_player_slot up to 6 times for the same player
    end)

    NepHook:Post(HUDMissionBriefing, "set_player_slot", function(self, nr, params)
        local current_name = params.name
        local peer_id = params.peer_id

        local starring_panel = star()
        if not starring_panel then
            NepgearsyHUDReborn:Error("Failed to load starring screen.")
            return
        end
        local player_slot = starring_panel:child("player_" .. nr)

        self:_update_avatar_slot(peer_id)
        self:_update_name(current_name, peer_id)

        if NepgearsyHUDReborn:GetOption("StarringColor") ~= 1 then
            LuaNetworking:SendToPeers("StarringColor", tostring(NepgearsyHUDReborn:GetOption("StarringColor")))
        end

        if tostring(NepgearsyHUDReborn:GetOption("StarringText")) ~= "" then
            LuaNetworking:SendToPeers("StarringText", tostring(NepgearsyHUDReborn:GetOption("StarringText")))
        end

        if current_name == managers.network.account:username_id() then
            player_slot:set_color(NepgearsyHUDReborn:StringToColor(NepgearsyHUDReborn:GetOption("StarringColor")))

            if tostring(NepgearsyHUDReborn:GetOption("StarringText")) ~= "" then
                player_slot:set_text(player_slot:text() .. ", " .. tostring(NepgearsyHUDReborn:GetOption("StarringText")))
            end
        end
    end)

    NepHook:Post(HUDMissionBriefing, "remove_player_slot_by_peer_id", function(self, peer)
        local peer_id = peer:id()
        local starring_panel = star()
        local name_slot = starring_panel:child("player_" .. peer_id)
        local avatar_slot = starring_panel:child("avatar_player_" .. peer_id)

        if name_slot then
            name_slot:set_text("")
            name_slot:set_visible(false)
        end

        if avatar_slot then
            avatar_slot:set_image("guis/textures/pd2/none_icon")
            avatar_slot:set_visible(false)
        end

        self._player[peer_id] = "0"
        self._custom_starring[peer_id] = ""
    end)

    function HUDMissionBriefing:_update_avatar_slot(peer_id)
        local peer = managers.network and managers.network:session() and managers.network:session():peer(peer_id)
        if peer then
            local steam_id = peer:account_id()
            if steam_id then
                NepgearsyHUDReborn:SteamAvatar(steam_id, function(texture)
                    local starring_panel = star()
                    local player_slot = starring_panel:child("avatar_player_" .. peer_id)
                    if player_slot then
                        if texture then
                            player_slot:set_image(texture)
                            player_slot:set_visible(true)
                        end
                    end
                end)
            end
        end
    end

    function HUDMissionBriefing:_update_name(name, peer_id)
        local starring_panel = star()
        local player_slot = starring_panel:child("player_" .. peer_id)

        if player_slot then
            player_slot:set_text(name)

            if self._custom_starring[peer_id] ~= "" then
                player_slot:set_text(name .. self._custom_starring[peer_id])
            end

            player_slot:set_visible(true)
        end
    end
end

NepHook:Add("NetworkReceivedData", function(sender, id, data)
    if id == "nephud_teammate_bg" then
        managers.player._player_teammate_bgs[sender] = data
    end

    if NepgearsyHUDReborn:GetOption("EnableStarring") then
        local starring_panel = star()
        if starring_panel then
            local player_slot = starring_panel:child("player_" .. sender)

            if id == "StarringColor" then
                player_slot:set_color(NepgearsyHUDReborn:StringToColor(tonumber(data)))
            end

            if id == "StarringText" then
                local briefing = managers.hud and managers.hud._hud_mission_briefing

                if briefing then
                    briefing._custom_starring[sender] = ", " .. tostring(data)

                    local peer = managers.network:session() and managers.network:session():peer(sender)
                    if peer then
                        briefing:_update_name(peer:name(), sender)
                    end
                end
            end
        end
    end
end)