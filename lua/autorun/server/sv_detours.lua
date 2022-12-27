hook.Add("PostGamemodeLoaded","sv_gamemode",function()
    function GAMEMODE:PlayerDeath( ply, inflictor, attacker )
        
        -- Don't spawn for at least 2 seconds
        ply.NextSpawnTime = CurTime()+2
        ply.DeathTime = CurTime()
        
        if ( IsValid( attacker ) && attacker:GetClass() == "trigger_hurt" ) then attacker = ply end
        if ( IsValid( attacker ) && attacker:IsVehicle() && IsValid( attacker:GetDriver() ) ) then
            attacker = attacker:GetDriver()
        end
        if ( !IsValid( inflictor ) && IsValid( attacker ) ) then
            inflictor = attacker
        end
        if ( IsValid( inflictor ) && inflictor == attacker && ( inflictor:IsPlayer() || inflictor:IsNPC() ) ) then
            inflictor = inflictor:GetActiveWeapon()
            if ( !IsValid( inflictor ) ) then inflictor = attacker end
            
        end
    end
end)