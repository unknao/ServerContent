local WM_FORCE = CreateConVar("wintermode_force", "0", {FCVAR_ARCHIVE}, "Forces winter mode outside of the winter season (requires rejoin to take effect).")

local path = "wintermode/maps/"
local map = game.GetMap()
local fullpath = path..map..".lua"

local map_file = file.Find(fullpath, "LUA")

if table.IsEmpty(map_file) then return end

AddCSLuaFile(fullpath)

local month = tonumber(os.date("%m"))
local IsWinter = month > 11 or month < 3

if IsWinter or WM_FORCE:GetBool() then
	
	hook.Add("InitPostEntity","Winter_Mode", function()
		local Snow_Material = include(fullpath)
		
		hook.Remove("InitPostEntity","Winter_Mode")
		
		if not Snow_Material then return end
		if CLIENT then
			
			hook.Add( "PlayerFootstep", "WinterMode.SnowStep", function( ply, pos, foot, _, volume)
				local mins, maxs = ply:OBBMins(), ply:OBBMaxs()
				maxs.z = 0
				
				local tr = util.TraceHull({
					start = pos + Vector(0,0,1),
					endpos = pos - Vector(0,0,1),
					filter = ply,
					mins = mins,
					maxs = maxs,
					mask = MASK_PLAYERSOLID
				})
				
				if not Snow_Material[tr.HitTexture] then return end
				local snowstep = tobool(foot) and "Snow.StepRight" or "Snow.StepLeft"
				ply:EmitSound(snowstep, 75, 100, volume)
				
				return true
			end)
			
			hook.Add("OnPlayerHitGround", "WinterMode.SnowLand", function(ply, inWater,  onFloater, speed)
				if InWater then return end
				if onFloater then return end
				if speed < 330 then return end
				
				local mins, maxs = ply:OBBMins(), ply:OBBMaxs()
				maxs.z = 0
				
				local tr = util.TraceHull({
					start = ply:GetPos() + Vector(0, 0, 36),
					endpos = ply:GetPos() - Vector(0, 0, 10),
					filter = ply,
					mins = mins,
					maxs = maxs,
					mask = MASK_PLAYERSOLID
				})
				if not Snow_Material[tr.HitTexture] then return end
				
				ply:EmitSound("Snow.StepRight", 75, 100, 1)
				
				return true
			end)
		end
		MsgC(Color(122, 228, 255),"[WinterMode] ", color_white, string.format("Initialized on %s.\n", game.GetMap()))
	end)
end
