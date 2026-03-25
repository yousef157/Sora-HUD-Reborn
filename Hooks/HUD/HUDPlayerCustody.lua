NepHook:Post(HUDPlayerCustody, "set_trade_delay", function(self, time)
    if time < 5 then
        managers.hud._hud_assault_corner.hostageKilledBg:set_color(Color.white)
        return
    end

    local timer_to_text = self:_get_time_text(time)
    managers.hud._hud_assault_corner.hostageKilledCounter:set_text(timer_to_text)
end)