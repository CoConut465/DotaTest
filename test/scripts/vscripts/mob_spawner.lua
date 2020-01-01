local spawner_config = require("config_mob_spawn")

if MobSpawner == nil then
    MobSpawner = class({})
end


function MobSpawner:Start()
    print("=========================== MobSpawner: Start")
    GameRules:GetGameModeEntity():SetThink("OnThink", self)   
    self.wave = 0
end


function MobSpawner: OnThink()
    print("=========================== MobSpawner: OnThink")

    local now = GameRules:GetDOTATime(false, true)
    if self.wave == 0 and now >= spawner_config.spawn_start_time then
        self:SpawnNextWave()
        return nil
    end

    return 1
end

function MobSpawner: SpawnNextWave()
    print("=========================== MobSpawner: SpawnNextWave")
    self.wave = self.wave + 1
    local wave_info = spawner_config.waves[self.wave]
    if wave_info then
        for i = 1, wave_info.num do
            self:SpawnMob(wave_info.name, wave_info.location, wave_info.level, wave_info.path)
        end
    else
        print("game over!")
    end
end

function MobSpawner:SpawnMob(name, location, level, path)

        -- 找刷怪点实体 https://developer.valvesoftware.com/wiki/Dota_2_Workshop_Tools/Scripting/API/CEntities.FindByName
        local location_ent = Entities:FindByName(nil, location)
        -- 拿到刷怪点的坐标 
        local position = location_ent:GetOrigin()
        -- 创建单位 https://developer.valvesoftware.com/wiki/Dota_2_Workshop_Tools/Scripting/API/Global.CreateUnitByName
        local mob = CreateUnitByName(name, position, true, nil, nil, DOTA_TEAM_BADGUYS)

        if mob == nil then 
            print("Create unit failed,")
            return nil
        else
            print("Create unit success.")
        end

        if level == nil then 
            print("Level is null.")
            level = 1
        else
            print("Level is not null.")
        end

        mob:CreatureLevelUp(1)-- 设置怪物等级

        if path then
            -- 设置怪物必须按路线走
            mob:SetMustReachEachGoalEntity(true)
            local path_ent = Entities:FindByName(nil, path)
            -- 设置怪物寻路的第一个路径点
            mob:SetInitialGoalEntity(path_ent)
        end
end