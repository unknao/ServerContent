
local Category = ""

local function ADD_ITEM( class, offset, extras, classOverride )

	local base = { PrintName = "#" .. ( classOverride or class ), ClassName = class, Category = Category, NormalOffset = offset or 32, DropToFloor = true, Author = "VALVe" }
	list.Set( "SpawnableEntities", classOverride or class, table.Merge( base, extras or {} ) )
	duplicator.Allow( class )

end

local function ADD_WEAPON( class )

	list.Set( "Weapon", class, { ClassName = class, PrintName = "#" .. ( class ), Category = Category, Author = "VALVe", Spawnable = true } )
	duplicator.Allow( class )

end

local function ADD_NPC_WEAPON( class )

	list.Add( "NPCUsableWeapons", { class = class, title = "#" .. class, category = Category } )

end

Category = "Default"

-- Ammo

-- Dynamic materials; gives player what he needs most (health, shotgun ammo, suit energy, etc)
-- ADD_ITEM( "item_dynamic_resupply" )

-- Items
ADD_ITEM( "item_battery", -4 )
ADD_ITEM( "item_healthkit", -8 )
ADD_ITEM( "item_healthvial", -4 )

-- Weapons
ADD_WEAPON( "weapon_physcannon" )
ADD_WEAPON( "weapon_physgun" )

-- NPC Weapons
ADD_NPC_WEAPON( "weapon_pistol" )
ADD_NPC_WEAPON( "weapon_357" )
ADD_NPC_WEAPON( "weapon_smg1" )
ADD_NPC_WEAPON( "weapon_shotgun" )
ADD_NPC_WEAPON( "weapon_ar2" )
ADD_NPC_WEAPON( "weapon_rpg" )
ADD_NPC_WEAPON( "weapon_alyxgun" )
ADD_NPC_WEAPON( "weapon_annabelle" )
ADD_NPC_WEAPON( "weapon_crossbow" )
ADD_NPC_WEAPON( "weapon_stunstick" )
ADD_NPC_WEAPON( "weapon_crowbar" )

if ( IsMounted( "portal" ) ) then
	Category = "Portal"

	ADD_ITEM( "prop_glados_core", 32, { KeyValues = { CoreType = 0, DelayBetweenLines = 0.4 }, PrintName = "#prop_glados_core_curiosity" } )
	ADD_ITEM( "prop_glados_core", 32, { KeyValues = { CoreType = 1, DelayBetweenLines = 0.1 } }, "prop_glados_core_anger" )
	ADD_ITEM( "prop_glados_core", 32, { KeyValues = { CoreType = 2, DelayBetweenLines = 0.1 } }, "prop_glados_core_crazy" )
	ADD_ITEM( "prop_glados_core", 32, { KeyValues = { CoreType = 3 } }, "prop_glados_core_morality" )
end


