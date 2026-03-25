local change_health_orig = PlayerDamage.change_health
function PlayerDamage:change_health(change_of_health)
    managers.hud:change_health(math.max(0, change_of_health or 0))
    return change_health_orig(self, change_of_health)
end
