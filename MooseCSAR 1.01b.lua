--%%%%%%%%%%%%%%%%%%%%%%%%%%%
--%%% CSAR Based on MOOSE %%%
--%%%%%%%%%%%%%%%%%%%%%%%%%%%

--%%% CREDITS %%%
-- JGi | Quéton 1-1

--%%% DEPENDENCIES %%%
-- Moose : >2.9.13
-- Unicodes : ☮☐☑☒▮▯⚑⚐✈⏣➳⟳⭮⚒⚔☄⛽
--
-- Put an infantery, late activation mode, call it "CSAR pilot"
-- Put a static A-10A, hide & dead options on, call it "CSAR crash-1"
-- Define zone "MASH" on heliport for example
-- Define zone "crash zone -1" and more to generate SAR missons

--%%% CHANGELOG %%%
--[[
    1.01b
    - Pilot weight 80>90kg
    - Seat number correction ; OH-58D, SA342, Mi-24, Mi-8, 
    - spawn minTimeToGenerate/maxTimeToGenerate 120>600 600>1200 sec

    1.01a
    - add region/zone handler and more

    1.00
    - Initial
--]]

--%%% LOCALEXEC %%%
    local templateNameForPilot="CSAR pilot"
    local templateNameForMash="mash"
    local templatesForCrashZones={
        "crash zone 1-",
        "crash zone 2-",
        "crash zone 3-",
        "crash zone 4-",
        "crash zone 5-",
        "crash zone 6-",
        "crash zone 7-",
        "crash zone 8-",
    }
    local templatesNameForCrashAnimation={
        "CSAR crash-1",
        "CSAR crash-2",
        "CSAR crash-3",
    } -- No need for the moment
    local minTimeToGenerate=300
    local maxTimeToGenerate=900
    local isDebug=false

    local radiusLimitFor2=4500 -- 15'000 ft
    local radiusLimitFor3=7620 -- 25'000 ft
    local radiusLimitFor4=9753 -- 32'000 ft
    local radiusLimitFor5=12192 -- 40'000 ft
    local maxSpawnGlobal=20
    local maxSpawnPerRegion=4
    local sumMaxSpawnPerRegion=0
    local zonesAndPilots={}
    local missionsDatas={}

--%%% LOCALS VARS %%%
    -- LUA ORIGINAL
    local Ran = math.random
    local StrMatch = string.match
    local StrSub = string.sub
    local Floor = math.floor
    local Sin=math.sin
    local Cos=math.cos
    local ToNumber=tonumber
    local OpenFile = io.open

    -- LUA EXTERNAL
    local WriteDir = lfs.writedir
    local MkDir = lfs.mkdir
    local Attributes = lfs.attributes

    -- LUA DCS API
    local AddGroup=coalition.addGroup
    local Explode=trigger.action.explosion
    local Scheduler=timer.scheduleFunction
    local Now=timer.getTime
    local GetZone=trigger.misc.getZone
    local OutText=trigger.action.outText
    local OutTextForCoalition=trigger.action.outTextForCoalition
    local Info=env.info
    local d

--%%% MAIN OBJECT %%%
    local blueCSAR = CSAR:New(coalition.side.BLUE,templateNameForPilot,"Pilote ejecté")

-- %%% CSAR USERS SETS %%%
    local mySet = SET_GROUP:New():FilterPrefixes("."):FilterCoalitions("blue"):FilterStart()
    blueCSAR:SetOwnSetPilotGroups(mySet)

-- %%% OPTIONS %%%
    blueCSAR.verbose = 0 -- set to > 1 for stats output for debugging.
    blueCSAR.topmenuname = "Search & Rescue" -- set the menu entry name
    blueCSAR.suppressmessages = false -- switch off all messaging if you want to do your own

    blueCSAR.useprefix = false  -- Requires CSAR helicopter #GROUP names to have the prefix(es) defined below.
    blueCSAR.csarPrefix = { "helicargo", "MEDEVAC"} -- #GROUP name prefixes used for useprefix=true - DO NOT use # in helicopter names in the Mission Editor! 
    blueCSAR.allowbronco = true  -- set to true to use the Bronco mod as a CSAR plane
    blueCSAR.max_units = 1 -- max number of pilots that can be carried if #CSAR.AircraftType is undefined.

    blueCSAR.coordtype = 1 -- Use Lat/Long DDM (0), Lat/Long DMS (1), MGRS (2), Bullseye imperial (3) or Bullseye metric (4) for coordinates.
    blueCSAR.csarOncrash = true -- (WIP) If set to true, will generate a downed pilot when a plane crashes as well.
    blueCSAR.enableForAI = false -- set to false to disable AI pilots from being rescued.
    
    blueCSAR.countryblue= country.id.UN_PEACEKEEPERS
    blueCSAR.countryred = country.id.UN_PEACEKEEPERS
    blueCSAR.countryneutral = country.id.UN_PEACEKEEPERS
    blueCSAR.PilotWeight = 90 --  Loaded pilots weigh 80kgs each
    blueCSAR.allowDownedPilotCAcontrol = false -- Set to false if you don\'t want to allow control by Combined Arms.

    blueCSAR.immortalcrew = true -- downed pilot spawn is immortal
    blueCSAR.invisiblecrew = true -- downed pilot spawn is visible
    blueCSAR.limitmaxdownedpilots = true
    blueCSAR.maxdownedpilots = 10 
    blueCSAR.csarUsePara = false -- If set to true, will use the LandingAfterEjection Event instead of Ejection. Requires mycsar.enableForAI to be set to true.
    -- blueCSAR.wetfeettemplate = "man in floating thingy" -- if you use a mod to have a pilot in a rescue float, put the template name in here for wet feet spawns. Note: in conjunction with csarUsePara this might create dual ejected pilots in edge cases.
    
    blueCSAR.messageTime = 15 -- Time to show messages for in seconds. Doubled for long messages.
    blueCSAR.approachdist_far = 5000 -- switch do 10 sec interval approach mode, meters
    blueCSAR.approachdist_near = 3000 -- switch to 5 sec interval approach mode, meters
    
    blueCSAR.CreateRadioBeacons = true -- set to false to disallow creating ADF radio beacons.
    blueCSAR.ADFRadioPwr = 1000 -- ADF Beacons sending with 1KW as default
    blueCSAR.radioSound = "beacon.ogg" -- the name of the sound file to use for the pilots\' radio beacons. 

    blueCSAR.AllowIRStrobe = true -- Allow a menu item to request an IR strobe to find a downed pilot at night (requires NVGs to see it).
    blueCSAR.IRStrobeRuntime = 600 -- If an IR Strobe is activated, it runs for 300 seconds (5 mins).

    blueCSAR.smokecolor = 2 -- Color of smokemarker, 0 is green, 1 is red, 2 is white, 3 is orange and 4 is blue.
    blueCSAR.autosmoke = false -- automatically smoke a downed pilot\'s location when a heli is near.
    blueCSAR.autosmokedistance = 750 -- distance for autosmoke

    blueCSAR.pilotRuntoExtractPoint = true -- Downed pilot will run to the rescue helicopter up to blueCSAR.extractDistance in meters. 
    blueCSAR.extractDistance = 300 -- Distance the downed pilot will start to run to the rescue helicopter.
    blueCSAR.pilotmustopendoors = false -- switch to true to enable check of open doors
    blueCSAR.loadDistance = 3 -- configure distance for pilots to get into helicopter in meters.
    blueCSAR.rescuehoverheight = 12 -- max height for a hovering rescue in meters
    blueCSAR.rescuehoverdistance = 3 -- max distance for a hovering rescue in meters

    blueCSAR.mashprefix = {templateNameForMash} -- prefixes of #GROUP objects used as MASHes.
    blueCSAR.allowFARPRescue = true -- allows pilots to be rescued by landing at a FARP or Airbase. Else MASH only!
    blueCSAR.FARPRescueDistance = 1200 -- you need to be this close to a FARP or Airport for the pilot to be rescued.

    blueCSAR.AircraftType["AH-64D_BLK_II"]=1
    blueCSAR.AircraftType["Bronco-OV-10A"]=4
    blueCSAR.AircraftType["CH-47Fbl1"]=33
    blueCSAR.AircraftType["Mi-24P"]=8
    blueCSAR.AircraftType["Mi-8MTV2"]=18
    blueCSAR.AircraftType["OH-6A"]=3
    blueCSAR.AircraftType["OH58D"]=1
    blueCSAR.AircraftType["SA342M"]=3
    blueCSAR.AircraftType["SA342L"]=3
    blueCSAR.AircraftType["SA342Minigun"]=1
    blueCSAR.AircraftType["SA342Mistral"]=3
    blueCSAR.AircraftType["UH-1H"]=6
    blueCSAR.AircraftType["UH-60L"]=12

-- %%% DEBUG MODE & TOOLS %%%

    --- Refactor of trigger.action.outText / trigger.action.outTextForCoalition
    -- @param string content : message
    -- @param int duration : time to show
    -- @param string dest : side, nil to all
    local function msg(content,duration,dest)
        if content~=nil then
            duration = duration or 10
            if dest==nil then
                OutText(content,duration)
            elseif dest==RED or dest==red or dest==1 then 
                OutTextForCoalition(coalition.side.RED,content,duration)
            elseif dest==BLUE or dest==blue or dest==2 then
                OutTextForCoalition(coalition.side.BLUE,content,duration)
            elseif dest==NEUTRAL or dest==neutral or dest==0 then
                OutTextForCoalition(coalition.side.NEUTRAL,content,duration)
            elseif dest==ALL or dest==all or dest==a then
                OutText(content,duration)
            end
        end
    end

    --> DEBUG MODE MESSAGES
    --- Debug log, if isDebug is set to true, send log text as outText to
    -- @param string content : message
    local function log (content)
        if content~=nil then 
            if isDebug then
                Info(content)
                msg(content,90)
            else
                Info(content)
            end
        end
    end
    if isDebug then
        minTimeToGenerate=60
        maxTimeToGenerate=120
        maxSpawnPerRegion=2
        d=log
    else
        function d() end
    end

-- %%% SAR GENERATOR %%%

    --- Names for downed players/pilots
    local sarGenPilotTable={
        "LeBibs",
        "Dilixo",
        "Quéton",
        "Kerboul",
        "Heimdall",
        "Pigon",
        "Berth",
        "Arhibeau",
        "Erepma",
        "Liose",
        "Sergent Lolo",
        "John Spa 103",
        "Einsamer Falk",
        "Pyro",
        "Loulouk Skywalker",
        "Power Doudou",
        "Mioril",
        "MiniKut",
        "Reaper",
        "Mistaff",
        "Delta",
        "Dusty",
        "PyroSkorp",
        "Starfox",
        "Nextlord",
        "OuiOui",
        "MisterKatsu",
        "Romi",
        "Rafiki",
        "Piprou",
        "Darzzake",
        "Muge",
        "Nhawx",
        "Scipiooo",
        "Chevre",
        "Mr Maquette",
        "r2_nico",
    }

    --- Init a table with zones name ans pilots count from zone name pattern from ME.
    -- @param zoneNamePattern : string, zone name pattern as defined in ME.
    -- @return zap table, zap for zones and pilots
    -- @return zap[].region : region name
    -- @return zap[].zone : zone name
    -- @return zap[].activePilots : pilot count to 0
    -- @return zap[].limitPerZonesize : max pilot in zone
    local function InitZonesAndPilots(zoneNamePatterns)
        local zap={}
        for i=1,#zoneNamePatterns do
            zap[#zap+1]={}
            for j=1,50 do
                if GetZone(zoneNamePatterns[i]..j)~=nil then 
                    local sum=0
                    if GetZone(zoneNamePatterns[i]..j).radius<radiusLimitFor2 then
                        sum=sum+1
                    elseif GetZone(zoneNamePatterns[i]..j).radius>=radiusLimitFor2 and GetZone(zoneNamePatterns[i]..j).radius<radiusLimitFor3 then
                        sum=sum+2
                    elseif GetZone(zoneNamePatterns[i]..j).radius>=radiusLimitFor3 and GetZone(zoneNamePatterns[i]..j).radius<radiusLimitFor4 then
                        sum=sum+3
                    elseif GetZone(zoneNamePatterns[i]..j).radius>=radiusLimitFor4 and GetZone(zoneNamePatterns[i]..j).radius<radiusLimitFor5 then
                        sum=sum+4
                    elseif GetZone(zoneNamePatterns[i]..j).radius>=radiusLimitFor5 then
                        sum=sum+5
                    end
                    zap[#zap][#zap[#zap]+1]={}
                    zap[#zap][#zap[#zap]]["region"]=zoneNamePatterns[i]
                    zap[#zap][#zap[#zap]]["zone"]=zoneNamePatterns[i]..j
                    zap[#zap][#zap[#zap]]["activePilots"]=0
                    zap[#zap][#zap[#zap]]["limitPerZonesize"]=sum
                    zap[#zap][#zap[#zap]]["activePilotsTable"]={}
                    log("Moose CSAR | InitZonesAndPilots [region="..zap[#zap][#zap[#zap]]["region"].."][zone="..StrSub(zap[#zap][#zap[#zap]]["zone"],-1).."][activePilots="..zap[#zap][#zap[#zap]]["activePilots"].."][limitPerZonesize="..zap[#zap][#zap[#zap]]["limitPerZonesize"].."]")
                end
            end
        end
        sumMaxSpawnPerRegion=#zoneNamePatterns*maxSpawnPerRegion
        log("Moose CSAR | InitZonesAndPilots [sumMaxSpawnPerRegion="..sumMaxSpawnPerRegion.."]["..#zoneNamePatterns.." regions x "..maxSpawnPerRegion.." spawns]")
        log("Moose CSAR | InitZonesAndPilots [maxSpawnGlobal="..maxSpawnGlobal.."]")
        return zap
    end

    --- Generate SAR mission in zone passed as arguments
    -- For each pair (find, subs), the function will create a field named with
    -- @param zoneDatas : table filtered with zone and pilots
    -- @param computedLimit : table with computed max downed pilots per zone
    local function CsarGenerator(datas)
        local theOneWhoEject
        local randomNumber
        local maxSpawnPerRegionSizeTable={}
        local sumMaxSpawnPerRegionSize=0
        local limitGlobal=sumMaxSpawnPerRegion
        local limitRegion=maxSpawnPerRegion

        if not datas then log("Moose CSAR | CsarGenerator [no datas passed to function]") ; return end
        for i=1,#datas do
            maxSpawnPerRegionSizeTable[#maxSpawnPerRegionSizeTable+1]=0
            local lastRegion
            for j=1,#datas[i] do 
                maxSpawnPerRegionSizeTable[#maxSpawnPerRegionSizeTable]=maxSpawnPerRegionSizeTable[#maxSpawnPerRegionSizeTable]+datas[i][j].limitPerZonesize
                sumMaxSpawnPerRegionSize=sumMaxSpawnPerRegionSize+datas[i][j].limitPerZonesize
                lastRegion=datas[i][j].region
            end
            d("Moose CSAR | CsarGenerator [region="..lastRegion.."][sumLimit="..maxSpawnPerRegionSizeTable[#maxSpawnPerRegionSizeTable].."]")
        end
        d("Moose CSAR | CsarGenerator [sumMaxSpawnPerRegionSize="..sumMaxSpawnPerRegionSize.."]")
        if sumMaxSpawnPerRegionSize<sumMaxSpawnPerRegion then limitGlobal=sumMaxSpawnPerRegionSize end
        if limitGlobal > maxSpawnGlobal then limitGlobal=maxSpawnGlobal end
        while blueCSAR:_CountActiveDownedPilots()<limitGlobal do
            for i=1,#datas do
                randomNumber=Ran(1,#datas[i])
                if maxSpawnPerRegionSizeTable[i]<maxSpawnPerRegion then limitRegion=maxSpawnPerRegionSizeTable[i] end
                local _pilotsByRegion=0
                for j=1,#datas[i] do
                    _pilotsByRegion=_pilotsByRegion+datas[i][randomNumber].activePilots
                end
                if _pilotsByRegion<limitRegion and datas[i][randomNumber].activePilots<datas[i][randomNumber].limitPerZonesize then
                    theOneWhoEject=sarGenPilotTable[Ran(1,#sarGenPilotTable)]
                    --CSAR:SpawnCSARAtZone(Zone, Coalition, description, RandomPoint, Nomessage, Unitname, Typename, Forcedesc)
                    blueCSAR:SpawnCSARAtZone( datas[i][randomNumber].zone, coalition.side.NEUTRAL, "["..theOneWhoEject.."]", true, false,datas[i][randomNumber].zone , "["..theOneWhoEject.."]", false)
                    datas[i][randomNumber].activePilots=datas[i][randomNumber].activePilots+1
                    log("Moose CSAR | CsarGenerator - New ["..theOneWhoEject.."] in ["..datas[i][randomNumber].zone.."]")
                end
            end
        end
        log("Moose CSAR | CsarGenerator [Active downed pilots="..blueCSAR:_CountActiveDownedPilots().."]")
        -- timer.scheduleFunction(function() CsarGenerator(datas) end,{},Now()+Ran(minTimeToGenerate,maxTimeToGenerate))
        if pcall(function () timer.scheduleFunction(function() CsarGenerator(datas) end,{},Now()+Ran(minTimeToGenerate,maxTimeToGenerate)) end) then 
            d("Moose CSAR | CsarGenerator [scheduleFunction=success]")
        else 
            log("Moose CSAR | CsarGenerator [scheduleFunction=error]")
        end
    end

-- %%% FSM %%%

    --- FSM fonction
    function blueCSAR:OnAfterPilotDown(from, event, to, spawnedGroup, frequency, leaderName, coordinatesText,playerName)
    --(From, Event, To, Group, Frequency, leaderName, CoordinatesText, playerName)
        d("Moose CSAR | OnAfterPilotDown [leaderName="..leaderName.."][playerName="..playerName.."][groupName="..spawnedGroup.GroupName.."]")
        missionsDatas[spawnedGroup.GroupName]=leaderName
        local newCoord=spawnedGroup:GetCoordinate():Translate(Ran(100,500), Ran(1,359), true, false)
        local scenario={
            {{type="A-10A",category="Planes"}},
            {{type="A-10A",category="Planes"}},
            {{type="M1043 HMMWV Armament",category="Armor"}},
            {{type="M1043 HMMWV Armament",category="Armor"},{type="LAZ Bus",category="Unarmed"}},
        }
        local r=Ran(1,#scenario)
        for i=1, #scenario[r] do
            local staticCrashAsset=SPAWNSTATIC:NewFromType(scenario[r][i].type, scenario[r][i].category, country.id.UN_PEACEKEEPERS)
            staticCrashAsset:InitType(scenario[r][i].type)
            staticCrashAsset:InitDead(true)
            if scenario[r][i]==1 then staticCrashAsset:InitCoordinate(newCoord) else staticCrashAsset:InitCoordinate(newCoord:Translate(3, Ran(1,359), true, false)) end
            staticCrashAsset:Spawn(Ran(1,359),"CSAR crash")
            newCoord:BigSmokeAndFireSmall(0.1,600,nil,nil)
            --newCoord:Explosion(100, 2)
        end

        -- local staticCrashAsset=SPAWNSTATIC:NewFromStatic(templatesNameForCrashAnimation[Ran(1,#templatesNameForCrashAnimation)], country.id.UN_PEACEKEEPERS)
        -- staticCrashAsset:InitDead(true)
        -- staticCrashAsset:InitCoordinate(newCoord)
        -- staticCrashAsset:Spawn(Ran(1,359),"CSAR crash")
        --if Ran(0,100)>55 then newCoord:BigSmokeAndFireSmall(0.01,900,nil,nil) end

        -- local staticCrashAsset=SPAWNSTATIC:NewFromType("FARP tent", "Fortification", country.id.UN_PEACEKEEPERS)
        -- staticCrashAsset:InitShape("PalatkaB")
        -- staticCrashAsset:InitType("FARP tent")
        -- staticCrashAsset:InitDead(true)
        -- staticCrashAsset:InitCoordinate(newCoord)
        -- staticCrashAsset:Spawn(Ran(1,359),"CSAR crash ")
        -- log("Moose CSAR | Generate group : "..spawnedGroup.GroupName)

        --? COORDINATE:BigSmokeAndFireSmall(Density, Duration, Delay, Name)
        -- newCoord:BigSmokeAndFireSmall(0.01,900,nil,nil)
        d("Moose CSAR | OnAfterPilotDown [spawning assets]")
    end

    function blueCSAR:OnAfterRescued(from, event, to, heliunit, heliname, pilotssaved) 
        log("Moose CSAR | OnAfterRescued [SAR mission success]")
        msg("Moose CSAR | Pilots saved ["..blueCSAR.rescuedpilots.."]",20)
    end

    function blueCSAR:OnAfterBoarded(From, Event, To, heliName, woundedGroupName, description)
    --CSAR:OnAfterBoarded(From, Event, To, heliName, woundedGroupName, description)
        local subRegion=StrSub(missionsDatas[woundedGroupName], 1, -2)
        local subZone=missionsDatas[woundedGroupName]
        for i=1, #zonesAndPilots do
            for j=1, #zonesAndPilots[i] do
                d("Moose CSAR | OnAfterRescued - parse [zone="..zonesAndPilots[i][j].zone.."]")
                if zonesAndPilots[i][j].zone==subZone then
                    local before=zonesAndPilots[i][j].activePilots
                    zonesAndPilots[i][j].activePilots=zonesAndPilots[i][j].activePilots-1
                    d("Moose CSAR | OnAfterRescued - remove 1 pilot in [zone="..zonesAndPilots[i][j].zone.."][activePilots="..(before).."->"..(zonesAndPilots[i][j].activePilots).."]")
                end
            end
        end
    end

-- %%% MAIN %%%
    Info("Moose CSAR | By Quéton")
    zonesAndPilots=InitZonesAndPilots(templatesForCrashZones)
    CsarGenerator(zonesAndPilots)
    blueCSAR:__Start(2)