NepHook:Post(CopDamage, "damage_bullet", function(self)
    if CopDamage.is_civilian(self._unit:base()._tweak_table) then
        managers.hud._hud_assault_corner:UpdateCivKilled()
    end
end)