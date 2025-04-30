--%%%%%%%%%%%%%%%%%%%%%%%%%%%
--%%% SNIPPET MOOSE SPAWN %%%
--%%%%%%%%%%%%%%%%%%%%%%%%%%%

--%%% CREDITS %%%
-- JGi | Quéton 1-1

--%%% DEPENDENCIES %%%
-- Moose >2.9

--%%% CHANGELOG %%%
--[[
    1.08
    - Refonte totale
--]]

--%%% USAGE %%%
--[[
    (FR)
    Le chargement de la lib Moose est requis avant l'exécution.
    Ajoutez un déclencheur, avec condition 'temps sup à ' spécifiez quelques secondes et 
    chargez le script
        - soit en tant que fichier .lua avec l'action 'executer fichier script'
        - soit en copier/coller à partir le la ligne 'group' avec l'action 'executer script'
        (Spécifiquement pour ce script, je recommande la seconde solution)
        - soit avec un dofile, pour externaliser le script
            ex. DoFile [Nouveau déclencheur][Tps sup à : 1][éxecuter script]:
                local scriptLocation = "..\DCS.Missions\\MaSuperMission\\MooseSpawn_1.08a.lua"
                dofile(lfs.writedir()..scriptLocation)

            ex. localisation: 
                Saved Games\DCS\Missions\MaSuperMission\ScriptLoader_v1.02.lua => "Missions\\MaSuperMission\\ScriptLoader_v1.02.lua" 
                or
                Saved Games\DCS.Missions\MaSuperMission\ScriptLoader_v1.02.lua => "..\\DCS.Missions\\MaSuperMission\\ScriptLoader_v1.02.lua",

    /!\ Attention au accolades, guillemets et virgules
]]--

--%%% I - TABLES DE DATAS %%%
    --> Complète une ou plusieurs tables à partir des modèles suivants pour chaque spawn

    --> Version minimaliste - spawn ultra simplifié
    local sp1 = {
        groupName="groupe_modele_2",
        unitsInGroup=1,
    }

    --> Version avec paramètres
    local sp2 = {
        groupName="groupe_modele_1",
        message="Spawning ground units",
        unitsInGroup=1,
        spawnLimit=0,
        replaceIfRespawn=false,
        iterate={enable=false, first=1, last=3},
        clone={enable=true, number=5},
        schedule={enable=false, time=30, delayFirstSpawn=false},
        zone={"z-1","z-2"},
        randomizePosition={enable=false, minRadius=10, maxRadius=100},
        randomizeRoute={enable=true, firstWp=1,lastWp=0,maxDistance=10000},
        AwacsTanker={enable=false,callsign="Texaco",callsignId=1,squadronNo=5,aircraftNo=1},
    }

--%%% II - TABLES A ACTIVER ... OU PAS %%%
    --> Inscrit ici, à l'intérieur de la table ci desous, le nom des tables à activer
    local tablesToSpawn={
        sp1,
        sp2,
    }

---%%% III - MAGIE, RENDS-TOI DANS LA PARTIE SUIVANTE %%%
    local MathRan = math.random
    local OutText = trigger.action.outText
    local Log = env.info
    --- Spawn groups/units à partir de la Lib Moose
    local function MooseSp(spTable)
        local group={}
        if spTable.iterate and spTable.iterate.enable==true and spTable.iterate.first and spTable.iterate.last then
            for i=spTable.iterate.first, spTable.iterate.last do
                group[#group+1] = spTable.groupName..i
            end
        else
            group[#group+1]=spTable.groupName
        end

        -- Clone
        if spTable.clone and spTable.clone.enable==true and spTable.clone.number and spTable.replaceIfRespawn==false then
            for i=2, spTable.clone.number do
                group[#group+1] = spTable.groupName
            end
        end

        for k=1, #group do
            local sp

            -- Remplacer l'unité si ré-apparition - replaceIfRespawn
            if spTable.replaceIfRespawn==true then
                sp=SPAWN:New(group[k])
            else
                sp=SPAWN:NewWithAlias(group[k],"MooseSpawn "..MathRan(1000000,9999999))
            end

            --> Nombre d'unité dans le groupe - Unit Limit
            local _units=spTable.unitsInGroup
            if spTable.unitsInGroup and spTable.spawnLimit and spTable.clone and spTable.clone.enable==true and spTable.clone.number and spTable.replaceIfRespawn==true then
                local number = (spTable.unitsInGroup)*(spTable.clone.number)
                sp:InitLimit(number, spTable.spawnLimit)
            elseif spTable.unitsInGroup and spTable.spawnLimit then
                sp:InitLimit(spTable.unitsInGroup,spTable.spawnLimit)
            elseif spTable.unitsInGroup then
                sp:InitLimit(spTable.unitsInGroup,0)
            else
                sp:InitLimit(1,0)
            end

            --> Optionnel : message
            if spTable.message and spTable.message~="" then
                sp:OnSpawnGroup(function(MSG) MSG=MESSAGE:New(spTable.message,10,false):ToAll() end)
            end

            --> Optionnel : Pour les Awacs et Tankers (ID,Name,Minor,Major)
            if spTable.AwacsTanker and spTable.AwacsTanker.enable==true and spTable.AwacsTanker.callsign and spTable.AwacsTanker.callsignId and spTable.AwacsTanker.squadronNo and spTable.AwacsTanker.aircraftNo then
                sp:InitCallSign(spTable.AwacsTanker.callsignId, spTable.AwacsTanker.callsign, spTable.AwacsTanker.squadronNo, spTable.AwacsTanker.aircraftNo)
            end

            --> Optionnel : Aleatoire dans la position (activé, rayon ext. m, rayon int. m)
            if spTable.randomizePosition and spTable.randomizePosition.enable==true and spTable.randomizePosition.minRadius and spTable.randomizePosition.maxRadius then
                sp:InitRandomizePosition(true, spTable.randomizePosition.maxRadius, spTable.randomizePosition.minRadius)
            end

            --> Optionnel : Aleatoire dans WP (premier WP, dernier WP, rayon max)
            if spTable.randomizeRoute and spTable.randomizeRoute.enable==true and spTable.randomizeRoute.firstWp and spTable.randomizeRoute.lastWp and spTable.randomizeRoute.maxDistance then
                sp:InitRandomizeRoute(spTable.randomizeRoute.firstWp, spTable.randomizeRoute.lastWp, spTable.randomizeRoute.maxDistance)
            end

            --> Optionnel : Spawn random par zones
            if spTable.zone and spTable.zone[1] then
                local zoneList={}
                for l=1, #spTable.zone do
                    zoneList[#zoneList+1] = ZONE:New( spTable.zone[l] )
                end
                sp:InitRandomizeZones(zoneList)
            end

            --> Methodes de Spawn :
            if spTable.schedule and spTable.schedule.enable==true and spTable.schedule.time and spTable.schedule.delayFirstSpawn==true then
                --> Activer délai dès le début
                sp:InitDelayOn()
                --> Re-spawn time (temps sec, % variation)
                sp:SpawnScheduled(spTable.schedule.time, .3)
                Log("Moose Spawn Snippet | Spawning scheduled with initial delay ("..spTable.schedule.time.."s) : "..spTable.groupName)
                
            elseif spTable.schedule and spTable.schedule.enable==true and spTable.schedule.time then
                --> Re-spawn time (temps sec, % variation)
                sp:SpawnScheduled(spTable.schedule.time, .3)
                Log("Moose Spawn Snippet | Spawning scheduled without initial delay ("..spTable.schedule.time.."s) : "..spTable.groupName)
            else
                if spTable.clone and spTable.clone.enable==true and spTable.clone.number then
                    for m=1, spTable.clone.number do
                        sp:Spawn()
                    end
                    Log("Moose Spawn Snippet | Spawning : "..spTable.groupName.." (x"..spTable.clone.number..")")
                else
                    sp:Spawn()
                    Log("Moose Spawn Snippet | Spawning : "..spTable.groupName)
                end
            end
            --> Spawn une fois, départ d'une base (base, type de départ) -->>Inutilisé<<--
            --sp:SpawnAtAirbase( AIRBASE:FindByName( AIRBASE.Caucasus.Krymsk ), SPAWN.Takeoff.Hot )
        end
    end
    -- Spawn des tables incrites dans tablesToSpawn
    for i=1,#tablesToSpawn do
        MooseSp(tablesToSpawn[i])
    end