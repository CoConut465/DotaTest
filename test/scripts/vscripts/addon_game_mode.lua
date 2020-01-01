-- Sample adventure script
require("mob_spawner")


-- Create the class for the game mode, unused in this example as the functions for the quest are global
if CAddonAdvExGameMode == nil then
	CAddonAdvExGameMode = class({})
end


-- If something was being created via script such as a new npc, it would need to be precached here
function Precache( context )
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]
end


-- Create the game mode class when we activate
function Activate()
	GameRules.AddonAdventure = CAddonAdvExGameMode()
	GameRules.AddonAdventure:InitGameMode()
end

-- Begins processing script for the custom game mode.  This "template_example" contains a main OnThink function.
function CAddonAdvExGameMode:InitGameMode()
	print( "Before set SetPreGameTime" )
	GameRules:SetPreGameTime(5)

	print( "Before set self.mob_spawner" )
	self.mob_spawner = MobSpawner()
	print( "Before set self.mob_spawner:Start()" )
	self.mob_spawner:Start()

	print( "Adventure Example loaded." )
	GameRules:GetGameModeEntity():SetThink("OnThink",self,"GlobalThink",2)
end

function  CAddonAdvExGameMode: OnThink()
	 if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
	 elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	 end

	 return 1
end