local PhysObj = FindMetaTable("PhysObj")
ac_detours.SetInertia = ac_detours.SetInertia or PhysObj.SetInertia

function PhysObj:SetInertia(vec)
    local x, y ,z = math.abs(vec[1]), math.abs(vec[2]), math.abs(vec[3])
    local min = math.min(x, y ,z)
    local max = math.max(x, y ,z)
    if max / min > 10 then
        print(Format("Tried to set unreasonable inertia (%s) on %s.", vec, self))
        return
    end

    ac_detours.SetInertia(self, vec)
end
