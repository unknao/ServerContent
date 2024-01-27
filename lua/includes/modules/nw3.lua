--Networked variable library that updates once on value being set
--[[Usage:
nw3.SetGlobalString("foo", "hello world") --Server only
str = nw3.GetGlobalString("foo")
--str = "hello world"

Entity(1):nw3SetString("bar", "foo")
str = Entity(1):nw3GetString("bar")
--str = "foo"
]]
AddCSLuaFile()
local ENTITY = FindMetaTable("Entity")
nw3 = nw3 or {
    Variables = {
        Angle = {},
        Bool = {},
        Entity = {},
        Float = {},
        Int = {},
        String = {},
        Vector = {}
    },
    Entities = {}
}

local alias = {
    Angle = isangle,
    Bool = isbool,
    Entity = isentity,
    String = isstring,
    Vector = isvector,
    Int = isnumber,
    Float = isnumber
}

if SERVER then
    util.AddNetworkString("nw3.sync")
    util.AddNetworkString("nw3.sync.entity")

    hook.Add("PlayerInitialSpawn", "nw3.sync", function(ply)
        for k,v in pairs(nw3.Variables) do
            if table.IsEmpty(v) then continue end

            net.Start("nw3.sync")
            net.WriteString(k)
            net.WriteUInt(table.Count(v), 12)
            for kk, vv in pairs(v) do
                net.WriteString(kk)
                if k == "Int" then net.WriteInt(vv, 32) continue end
                net["Write" .. k](vv)
            end
            net.Send(ply)
        end
        for i, Var1 in pairs(nw3.Entities) do
            for typ, Var2 in pairs(Var1) do
                if table.IsEmpty(Var2) then continue end

                net.Start("nw3.sync.entity")
                net.WriteUInt(i, 13)
                net.WriteString(typ)
                net.WriteUInt(table.Count(Var2), 12)
                for k, v in pairs(Var2) do
                    net.WriteString(k)
                    if typ == "Int" then net.WriteInt(v, 32) continue end
                    net["Write" .. typ](v)
                end
                net.Send(ply)
            end
        end
    end)

    --"Set" Functions
    for k, v in pairs(nw3.Variables) do
        nw3["SetGlobal" .. k] = function(ID, Var)
            if not alias[k](Var) then return end
            if nw3.Variables[k][ID] == Var then return end

            nw3.Variables[k][ID] = Var
            net.Start("nw3.sync")
            net.WriteString(k)
            net.WriteUInt(1, 12)
            net.WriteString(ID)
            net["Write" .. k](Var)
            net.Broadcast()
        end

        ENTITY["nw3Set" .. k] = function(self, ID, Var)
            print(self, ID, Var)
            if not alias[k](Var) then return end

            nw3.Entities[self:EntIndex()] = nw3.Entities[self:EntIndex()] or {}
            nw3.Entities[self:EntIndex()][k] = nw3.Entities[self:EntIndex()][k] or {}
            if nw3.Entities[self:EntIndex()][k][ID] == Var then return end
            nw3.Entities[self:EntIndex()][k][ID] = Var

            net.Start("nw3.sync.entity")
            net.WriteUInt(self:EntIndex(), 13)
            net.WriteString(k)
            net.WriteUInt(1, 12)
            net.WriteString(ID)
            net["Write" .. k](Var)
            net.Broadcast()
        end
    end

    --Global Exceptions
    function nw3.SetGlobalFloat(ID, Var)
        if not isnumber(Var) then return end
        if nw3.Variables.Float[ID] == Var then return end

        nw3.Variables.Float[ID] = Var
        net.Start("nw3.sync")
        net.WriteString("Float")
        net.WriteUInt(1, 12)
        net.WriteString(ID)
        net.WriteFloat(Var)
        net.Broadcast()
    end

    function nw3.SetGlobalInt(ID, Var)
        if not isnumber(Var) then return end
        local Var = math.floor(Var)
        if nw3.Variables.Int[ID] == Var then return end

        nw3.Variables.Int[ID] = Var
        net.Start("nw3.sync")
        net.WriteString("Int")
        net.WriteUInt(1, 12)
        net.WriteString(ID)
        net.WriteInt(Var, 32)
        net.Broadcast()
    end

    --Entity Exceptions
    function ENTITY:nw3SetFloat(ID, Var)
        if not isnumber(Var) then return end

        nw3.Entities[self:EntIndex()] = nw3.Entities[self:EntIndex()] or {}
        nw3.Entities[self:EntIndex()].Float = nw3.Entities[self:EntIndex()].Float or {}
        if nw3.Entities[self:EntIndex()].Float[ID] == Var then return end
        nw3.Entities[self:EntIndex()].Float[ID] = Var

        net.Start("nw3.sync.entity")
        net.WriteUInt(self:EntIndex(), 13)
        net.WriteString("Float")
        net.WriteUInt(1, 12)
        net.WriteString(ID)
        net.WriteFloat(Var)
        net.Broadcast()
    end

    function ENTITY:nw3SetInt(ID, Var)
        if not isnumber(Var) then return end
        local Var = math.floor(Var)

        nw3.Entities[self:EntIndex()] = nw3.Entities[self:EntIndex()] or {}
        nw3.Entities[self:EntIndex()].Int = nw3.Entities[self:EntIndex()].Int or {}
        if nw3.Entities[self:EntIndex()].Int[ID] == Var then return end
        nw3.Entities[self:EntIndex()].Int[ID] = Var

        net.Start("nw3.sync.entity")
        net.WriteUInt(self:EntIndex(), 13)
        net.WriteString("Int")
        net.WriteUInt(1, 12)
        net.WriteString(ID)
        net.WriteInt(Var, 32)
        net.Broadcast()
    end
end

--"Get" Functions
for k, v in pairs(nw3.Variables) do
    nw3["GetGlobal" .. k] = function(ID)
        return nw3.Variables[k][ID]
    end

    ENTITY["nw3Get" .. k] = function(self, ID)
        return nw3.Entities[self:EntIndex()][k][ID]
    end
end

hook.Add("EntityRemoved", "nw3.entitymanagement", function(ent, fullupdate)
    if fullupdate then return end
    if not ent:IsValid() then return end

    nw3.Entities[ent:EntIndex()] = nil
end)

if SERVER then return end

net.Receive("nw3.sync", function()
    local typ = net.ReadString()
    local index = net.ReadUInt(12)
    --Bulk processing
    for i = 1, index do
        local ID = net.ReadString()

        local Var
        if typ == "Int" then
            Var = net.ReadInt(32)
        else
            Var = net["Read" .. typ]()
        end

        nw3.Variables[typ][ID] = Var
    end
end)

net.Receive("nw3.sync.entity", function()
    local entindex = net.ReadUInt(13)
    local typ = net.ReadString()
    local index = net.ReadUInt(12)

    nw3.Entities[entindex] = nw3.Entities[entindex] or {}
    nw3.Entities[entindex][typ] = nw3.Entities[entindex][typ] or {}

    --Bulk processing
    for i = 1, index do
        local ID = net.ReadString()

        local Var
        if typ == "Int" then
            Var = net.ReadInt(32)
        else
            Var = net["Read" .. typ]()
        end

        nw3.Entities[entindex][typ][ID] = Var
        print(entindex, typ, ID, Var)
    end
end)

