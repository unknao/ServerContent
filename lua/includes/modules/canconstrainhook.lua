local tag = "CanConstrain"
CanConstrain_Detours = CanConstrain_Detours or {
    AdvBallsocket = constraint.AdvBallsocket,
    Axis = constraint.Axis,
    Ballsocket = constraint.Ballsocket,
    Elastic = constraint.Elastic,
    Hydraulic = constraint.Hydraulic,
    Keepupright = constraint.Keepupright,
    Motor = constraint.Motor,
    Muscle = constraint.Muscle,
    NoCollide = constraint.NoCollide,
    Pulley = constraint.Pulley,
    Rope = constraint.Rope,
    Slider = constraint.Slider,
    Weld = constraint.Weld,
    Winch = constraint.Winch
}

function constraint.AdvBallsocket(Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, forcelimit, torquelimit, xmin, ymin, zmin, xmax, ymax, zmax, xfric, yfric, zfric, onlyrotation, nocollide)
    local data = {
        Type = "AdvBallsocket",
        Ent1 = Ent1,
        Ent2 = Ent2,
        Bone1 = Bone1,
        Bone2 = Bone2,
        LPos1 = LPos1,
        LPos2 = LPos2,
        forcelimit = forcelimit,
        torquelimit = torquelimit,
        xmin = xmin,
        ymin = ymin,
        zmin = zmin,
        xmax = xmax,
        ymax = ymax,
        zmax = zmax,
        xfric = xfric,
        yfric = yfric,
        zfric = zfric,
        onlyrotation = onlyrotation,
        nocollide = nocollide
    }
    if hook.Run(tag, data) == false then return end

    return CanConstrain_Detours.AdvBallsocket(Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, forcelimit, torquelimit, xmin, ymin, zmin, xmax, ymax, zmax, xfric, yfric, zfric, onlyrotation, nocollide)
end

function constraint.Axis(Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, forcelimit, torquelimit, friction, nocollide, LocalAxis, DontAdd)
    local data = {
        Type = "Axis",
        Ent1 = Ent1,
        Ent2 = Ent2,
        Bone1 = Bone1,
        Bone2 = Bone2,
        LPos1 = LPos1,
        LPos2 = LPos2,
        forcelimit = forcelimit,
        torquelimit = torquelimit,
        friction = friction,
        nocollide = nocollide,
        LocalAxis = LocalAxis,
        DontAdd = DontAdd
    }
    if hook.Run(tag, data) == false then return end

    return CanConstrain_Detours.Axis(Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, forcelimit, torquelimit, friction, nocollide, LocalAxis, DontAdd)
end

function constraint.Ballsocket(Ent1, Ent2, Bone1, Bone2, LPos1, forcelimit, torquelimit, nocollide)
    local data = {
        Type = "Ballsocket",
        Ent1 = Ent1,
        Ent2 = Ent2,
        Bone1 = Bone1,
        Bone2 = Bone2,
        LPos1 = LPos1,
        forcelimit = forcelimit,
        torquelimit = torquelimit,
        nocollide = nocollide
    }
    if hook.Run(tag, data) == false then return end

    return CanConstrain_Detours.Ballsocket(Ent1, Ent2, Bone1, Bone2, LPos1, forcelimit, torquelimit, nocollide)
end

function constraint.Elastic(Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, constant, damping, rdamping, material, width, stretchonly, color)
    local data = {
        Type = "Elastic",
        Ent1 = Ent1,
        Ent2 = Ent2,
        Bone1 = Bone1,
        Bone2 = Bone2,
        LPos1 = LPos1,
        LPos2 = LPos2,
        constant = constant,
        damping = damping,
        rdamping = rdamping,
        material = material,
        width = width,
        stretchonly = stretchonly,
        color = color
    }
    if hook.Run(tag, data) == false then return end

    return CanConstrain_Detours.Elastic(Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, constant, damping, rdamping, material, width, stretchonly, color)
end

function constraint.Hydraulic(Ply, Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, Length1, Length2, width, key, fixed, speed, material, color)
    local data = {
        Type = "Hydraulic",
        Ply = Ply,
        Ent1 = Ent1,
        Ent2 = Ent2,
        Bone1 = Bone1,
        Bone2 = Bone2,
        LPos1 = LPos1,
        LPos2 = LPos2,
        Length1 = Length1,
        Length2 = Length2,
        width = width,
        key = key,
        fixed = fixed,
        speed = speed,
        material = material,
        color = color
    }
    if hook.Run(tag, data) == false then return end

    return CanConstrain_Detours.Hydraulic(Ply, Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, Length1, Length2, width, key, fixed, speed, material, color)
end

function constraint.Keepupright(Ent, Ang, Bone, angularLimit)
    local data = {
        Type = "Keepupright",
        Ent = Ent,
        Ang = Ang,
        Bone = Bone,
        angularLimit = angularLimit
    }

    if hook.Run(tag, data) == false then return end
end

function constraint.Motor(Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, friction, torque, forcetime, nocollide, toggle, Ply, forcelimit, numpadkey_fwd, numpadkey_bwd, direction, LocalAxis)
    local data = {
        Type = "Motor",
        Ent1 = Ent1,
        Ent2 = Ent2,
        Bone1 = Bone1,
        Bone2 = Bone2,
        LPos1 = LPos1,
        LPos2 = LPos2,
        friction = friction,
        torque = torque,
        forcetime = forcetime,
        nocollide = nocollide,
        toggle = toggle,
        Ply = Ply,
        forcelimit = forcelimit,
        numpadkey_fwd = numpadkey_fwd,
        numpadkey_bwd = numpadkey_bwd,
        direction = direction,
        LocalAxis = LocalAxis
    }
    if hook.Run(tag, data) == false then return end

    return CanConstrain_Detours.Motor(Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, friction, torque, forcetime, nocollide, toggle, Ply, forcelimit, numpadkey_fwd, numpadkey_bwd, direction, LocalAxis)
end

function constraint.Muscle(Ply, Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, Length1, Length2, width, key, fixed, period, amplitude, starton, material, color)
    local data = {
        Type = "Muscle",
        Ply = Ply,
        Ent1 = Ent1,
        Ent2 = Ent2,
        Bone1 = Bone1,
        Bone2 = Bone2,
        LPos1 = LPos1,
        LPos2 = LPos2,
        Length1 = Length1,
        Length2 = Length2,
        width = width,
        key = key,
        fixed = fixed,
        period = period,
        amplitude = amplitude,
        starton = starton,
        material = material,
        color = color
    }
    if hook.Run(tag, data) == false then return end

    return CanConstrain_Detours.Muscle(Ply, Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, Length1, Length2, width, key, fixed, period, amplitude, starton, material, color)
end

function constraint.NoCollide(Ent1, Ent2, Bone1, Bone2)
    local data = {
        Type = "NoCollide",
        Ent1 = Ent1,
        Ent2 = Ent2,
        Bone1 = Bone1,
        Bone2 = Bone2
    }
    if hook.Run(tag, data) == false then return end

    return CanConstrain_Detours.NoCollide(Ent1, Ent2, Bone1, Bone2)
end

function constraint.Pulley(Ent1, Ent4, Bone1, Bone4, LPos1, LPos4, WPos2, WPos3, forcelimit, rigid, width, material, color)
    local data = {
        Type = "Pulley",
        Ent1 = Ent1,
        Ent4 = Ent4,
        Bone1 = Bone1,
        Bone4 = Bone4,
        LPos1 = LPos1,
        LPos4 = LPos4,
        WPos2 = WPos2,
        WPos3 = WPos3,
        forcelimit = forcelimit,
        rigid = rigid,
        width = width,
        material = material,
        color = color
    }
    if hook.Run(tag, data) == false then return end

    return CanConstrain_Detours.Pulley(Ent1, Ent4, Bone1, Bone4, LPos1, LPos4, WPos2, WPos3, forcelimit, rigid, width, material, color)
end
function constraint.Rope(Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, length, addlength, forcelimit, width, material, rigid, color)
    local data = {
        Type = "Rope",
        Ent1 = Ent1,
        Ent2 = Ent2,
        Bone1 = Bone1,
        Bone2 = Bone2,
        LPos1 = LPos1,
        LPos2 = LPos2,
        length = length,
        addlength = addlength,
        forcelimit = forcelimit,
        width = width,
        material = material,
        rigid = rigid,
        color = color
    }
    if hook.Run(tag, data) == false then return end

    return CanConstrain_Detours.Rope(Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, length, addlength, forcelimit, width, material, rigid, color)
end
function constraint.Slider(Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, width, material, color)
    local data = {
        Type = "Slider",
        Ent1 = Ent1,
        Ent2 = Ent2,
        Bone1 = Bone1,
        Bone2 = Bone2,
        LPos1 = LPos1,
        LPos2 = LPos2,
        width = width,
        material = material,
        color = color
    }
    if hook.Run(tag, data) == false then return end

    return CanConstrain_Detours.Slider(Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, width, material, color)
end
function constraint.Weld(Ent1, Ent2, Bone1, Bone2, forcelimit, nocollide, deleteent1onbreak)
    local data = {
        Type = "Weld",
        Ent1 = Ent1,
        Ent2 = Ent2,
        Bone1 = Bone1,
        Bone2 = Bone2,
        forcelimit = forcelimit,
        nocollide = nocollide,
        deleteent1onbreak = deleteent1onbreak
    }
    if hook.Run(tag, data) == false then return end

    return CanConstrain_Detours.Weld(Ent1, Ent2, Bone1, Bone2, forcelimit, nocollide, deleteent1onbreak)
end
function constraint.Winch(Ply, Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, width, fwd_bind, bwd_bind, fwd_speed, bwd_speed, material, toggle, color)
    local data = {
        Type = "Winch",
        Ply = Ply,
        Ent1 = Ent1,
        Ent2 = Ent2,
        Bone1 = Bone1,
        Bone2 = Bone2,
        LPos1 = LPos1,
        LPos2 = LPos2,
        width = width,
        fwd_bind = fwd_bind,
        bwd_bind = bwd_bind,
        fwd_speed = fwd_speed,
        bwd_speed = bwd_speed,
        material = material,
        toggle = toggle,
        color = color
    }
    if hook.Run(tag, data) == false then return end

    return CanConstrain_Detours.Winch(Ply, Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, width, fwd_bind, bwd_bind, fwd_speed, bwd_speed, material, toggle, color)
end
