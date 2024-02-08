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

nw3 = {}
local nw3storage = {
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

local tFallbacks = {
    Angle = Angle(0, 0, 0),
    Bool = false,
    Entity = NULL,
    String = "",
    Vector = Vector(0, 0, 0),
    Int = 0,
    Float = 0
}

if SERVER then
    util.AddNetworkString("nw3_sync")
    util.AddNetworkString("nw3_sync_entity")

    local tAlias = {
        Angle = isangle,
        Bool = isbool,
        Entity = isentity,
        String = isstring,
        Vector = isvector,
        Int = isnumber,
        Float = isnumber
    }
    nw3storage.GlobalQueue = {}
    nw3storage.EntityQueue = {}

    function nw3_SyncPlayer(ply)
        for k,v in pairs(nw3storage.Variables) do
            if table.IsEmpty(v) then continue end

            net.Start("nw3_sync")
            net.WriteString(k)
            for kk, vv in pairs(v) do
                net.WriteString(kk)
                if k == "Int" then
                    net.WriteInt(vv, 32)
                else
                    net["Write" .. k](vv)
                end

                if net.BytesWritten() >= 65000 then
                    net.WriteString("-")
                    net.Send(ply)
                    coroutine.wait(0)
                    net.Start("nw3_sync")
                    net.WriteString(k)
                end
            end
            net.WriteString("-")
            net.Send(ply)
        end
        for i, Var1 in pairs(nw3storage.Entities) do
            for typ, Var2 in pairs(Var1) do
                if table.IsEmpty(Var2) then continue end

                net.Start("nw3_sync_entity")
                net.WriteUInt(i, 13)
                net.WriteString(typ)
                for k, v in pairs(Var2) do
                    net.WriteString(k)
                    if typ == "Int" then
                        net.WriteInt(v, 32)
                    else
                        net["Write" .. typ](v)
                    end

                    if net.BytesWritten() >= 65000 then
                        net.WriteString("-")
                        net.Send(ply)
                        coroutine.wait(0)
                        net.Start("nw3_sync_entity")
                        net.WriteUInt(i, 13)
                        net.WriteString(typ)
                    end
                end
                net.WriteString("-")
                net.Send(ply)
            end
        end

        MsgC(Color(84, 255, 212), "[nw3] ", Color(220, 255, 246), "Synchronised values for ", ply:Name(), "<", ply:SteamID(), ">\n")
    end

    gameevent.Listen("OnRequestFullUpdate")
    hook.Add("OnRequestFullUpdate", "nw3_SyncPlayer", function(data)
        local co = coroutine.create(nw3_SyncPlayer)
        coroutine.resume(co, Entity(data.index + 1))
    end)

    --Queue building & handling

    local function nw3FlushGlobalQueue()
        if player.GetCount() == 0 then return end

        for Type, TypeTable in pairs(nw3storage.GlobalQueue) do
            net.Start("nw3_sync")
            net.WriteString(Type)
            for ID, Val in pairs(TypeTable) do
                net.WriteString(ID)
                if Type == "Int" then
                    net.WriteInt(Val, 32)
                else
                    net["Write" .. Type](Val)
                end

                nw3storage.GlobalQueue[Type][ID] = nil
                if net.BytesWritten() >= 65000 then
                    net.WriteString("-")
                    net.Broadcast()
                    coroutine.wait(0)
                    net.Start("nw3_sync")
                    net.WriteString(Type)
                end
            end
            net.WriteString("-")
            net.Broadcast()
            nw3storage.GlobalQueue[Type] = nil
        end
    end

    local function nw3AddToGlobalQueue(Type, ID, Var)
        if nw3storage.Variables[Type][ID] == Var then return end
        nw3storage.Variables[Type][ID] = Var

        if not nw3storage.GlobalQueue[Type] then nw3storage.GlobalQueue[Type] = {} end
        nw3storage.GlobalQueue[Type][ID] = Var

        timer.Create("nw3_FlushGlobalQueue", 0, 1, function()
            local co = coroutine.create(nw3FlushGlobalQueue)
            coroutine.resume(co)
        end)
    end

    local function nw3FlushEntityQueue()
        if player.GetCount() == 0 then return end

        for EntIndex, EntTable in pairs(nw3storage.EntityQueue) do
            for Type, TypeTable in pairs(EntTable) do
                net.Start("nw3_sync_entity")
                net.WriteUInt(EntIndex, 13)
                net.WriteString(Type)
                for ID, Val in pairs(TypeTable) do
                    net.WriteString(ID)
                    if Type == "Int" then
                        net.WriteInt(Val, 32)
                    else
                        net["Write" .. Type](Val)
                    end

                    if net.BytesWritten() >= 65000 then
                        net.WriteString("-")
                        net.Broadcast()
                        coroutine.wait(0)
                        net.Start("nw3_sync_entity")
                        net.WriteUInt(EntIndex, 13)
                        net.WriteString(Type)
                    end
                    nw3storage.EntityQueue[EntIndex][Type][ID] = nil
                end
                net.WriteString("-")
                net.Broadcast()
                nw3storage.EntityQueue[EntIndex][Type] = nil
            end
            nw3storage.EntityQueue[EntIndex] = nil
        end
    end

    local function nw3AddToEntityQueue(EntIndex, Type, ID, Var)
        if not nw3storage.Entities[EntIndex] then nw3storage.Entities[EntIndex] = {} end
        if not nw3storage.Entities[EntIndex][Type] then nw3storage.Entities[EntIndex][Type] = {} end
        if nw3storage.Entities[EntIndex][Type][ID] == Var then return end
        nw3storage.Entities[EntIndex][Type][ID] = Var

        if not nw3storage.EntityQueue[EntIndex] then nw3storage.EntityQueue[EntIndex] = {} end
        if not nw3storage.EntityQueue[EntIndex][Type] then nw3storage.EntityQueue[EntIndex][Type] = {} end
        nw3storage.EntityQueue[EntIndex][Type][ID] = Var

        timer.Create("nw3_FlushEntityQueue", 0, 1, function()
            local co = coroutine.create(nw3FlushEntityQueue)
            coroutine.resume(co)
        end)
    end

    --"Set" Functions
    for k, v in pairs(nw3storage.Variables) do
        nw3["SetGlobal" .. k] = function(ID, Var)
            if not tAlias[k](Var) then error(string.format("Attempted to set a(n) %s with the %s function!", type(Var), k)) return end
            if ID == "-" then error("Attempted to set the ID with an internally reserved name!") return end

            nw3AddToGlobalQueue(k, ID, Var)
        end

        ENTITY["nw3Set" .. k] = function(self, ID, Var)
            if not tAlias[k](Var) then error(string.format("Attempted to set a(n) %s with the %s function on Entity(%i)!", type(Var), k, self:EntIndex())) return end
            if ID == "-" then error("Attempted to set the ID with an internally reserved name!") return end

            nw3AddToEntityQueue(self:EntIndex(), k, ID, Var)
        end
    end

    --Exceptions
    function nw3.SetGlobalInt(ID, Var)
        if not isnumber(Var) then error(string.format("Attempted to set a(n) %s with the interger function!", type(Var))) return end
        if ID == "-" then error("Attempted to set the ID with an internally reserved name!") return end

        nw3AddToGlobalQueue("Int", ID, math.floor(Var))
    end

    function ENTITY:nw3SetInt(ID, Var)
        if not isnumber(Var) then error(string.format("Attempted to set a(n) %s with the interger function!", type(Var))) return end
        if ID == "-" then error("Attempted to set the ID with an internally reserved name!") return end

        nw3AddToEntityQueue(self:EntIndex(), "Int", ID, math.floor(Var))
    end
end

--"Get" Functions
for k, v in pairs(nw3storage.Variables) do
    nw3["GetGlobal" .. k] = function(ID, Fallback)
        if nw3storage.Variables[k][ID] then
            return nw3storage.Variables[k][ID]
        else
            return Fallback or tFallbacks[k]
        end
    end

    ENTITY["nw3Get" .. k] = function(self, ID, Fallback)
        if nw3storage.Entities[self:EntIndex()][k] and nw3storage.Entities[self:EntIndex()][k][ID] then
            return nw3storage.Entities[self:EntIndex()][k][ID]
        else
            return Fallback or tFallbacks[k]
        end
    end
end

hook.Add("EntityRemoved", "nw3_EntityManagement", function(ent, fullupdate)
    if fullupdate then return end
    if not ent:IsValid() then return end

    nw3storage.Entities[ent:EntIndex()] = nil
end)

if SERVER then return end
local bDebugPrint = CreateConVar("nw3_debugprint", 0, FCVAR_ARCHIVE, "Prints the set nw3 entries as they are being received from the server if not 0", 0, 1)

--Bulk processing
net.Receive("nw3_sync", function()
    local typ = net.ReadString()
    while true do
        local ID = net.ReadString()
        if ID == "-" then return end

        local Var
        if typ == "Int" then
            Var = net.ReadInt(32)
        else
            Var = net["Read" .. typ]()
        end
        if bDebugPrint:GetBool() then print(string.format("[nw3] Global %s, %s, %s", typ, ID, Var)) end
        nw3storage.Variables[typ][ID] = Var
    end
end)

net.Receive("nw3_sync_entity", function()
    local entindex = net.ReadUInt(13)
    local typ = net.ReadString()

    nw3storage.Entities[entindex] = nw3storage.Entities[entindex] or {}
    nw3storage.Entities[entindex][typ] = nw3storage.Entities[entindex][typ] or {}

    while true do
        local ID = net.ReadString()
        if ID == "-" then return end

        local Var
        if typ == "Int" then
            Var = net.ReadInt(32)
        else
            Var = net["Read" .. typ]()
        end

        if bDebugPrint:GetBool() then print(string.format("[nw3] Entity(%i) %s, %s, %s", entindex, typ, ID, Var)) end
        nw3storage.Entities[entindex][typ][ID] = Var
    end
end)

