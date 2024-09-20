--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
--%%%%% CTLD Based on MOOSE --%%%%%
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

--%%% CREDITS %%%
-- JGi | Quéton 1-1

--%%% DEPENDENCIES %%%
-- Moose : >2.9.9 custom, ask me
-- Unicodes : ☮☐☑☒▮▯⚑⚐✈⏣➳⟳⭮⚒⚔☄⛽

--%%% CHANGELOG %%%
--[[
    1.03
    - Add FARP command et fuel vehicles
    
    1.02
    - Add FARP vehicules supply
    - Add engineer

    1.01
    - Ajusted some crates

    1.00
    - Initial
--]]

--%%% TODO %%%
--[[
    Add FARP supply
    Add ingineer
--]]

--%%% MAIN OBJECT %%%
    --> Main instance of CTLD. Filter on all unit with ".". Do no touch!
    local blueCtld = CTLD:New(coalition.side.BLUE,{"."},"CTLD")

--%%% TEMPLATES NAMES %%%
    --> For each mission, in the mission editor, you have to place late activated units as models
    --> Put here model's name from mission editor, or use these names.
    local templateNameForLoadingZone = "pz-"
    local templateNameForFOB = "template FOB"
    local templateNameForFARP = "template FARP invisible-1"
    local templateNameForSoldier = "template soldier"
    local templateNameForAntiTank = "template anti-tank"
    local templateNameForAntiAir = "template anti-air"
    --> For cargos and troops, report templates's names from editor in the right named section below.    

--%%% OPTIONS PREFIX %%%
    blueCtld.useprefix = false -- Adjust **before** starting CTLD. If set to false, *all* choppers of the coalition side will be enabled for CTLD.
    blueCtld.usesubcats = true -- use sub-category names for crates, adds an extra menu layer in "Get Crates", useful if you have > 10 crate types.
    blueCtld.suppressmessages = false -- Set to true if you want to script your own messages.
    blueCtld.nobuildmenu = false -- if set to true effectively enforces to have engineers build/repair stuff for you.

--%%% OPTIONS CRATES %%%
    blueCtld.CrateDistance = 50 -- List and Load crates in this radius only. 35
    blueCtld.PackDistance = 50 -- Pack crates in this radius only. 35
    blueCtld.dropcratesanywhere = true -- Option to allow crates to be dropped anywhere.
    blueCtld.dropAsCargoCrate = false -- Parachuted herc cargo is not unpacked automatically but placed as crate to be unpacked. Needs a cargo with the same name defined like the cargo that was dropped.

--%%% OPTIONS HOVER %%%
    blueCtld.maximumHoverHeight = 15 -- Hover max this high to load.
    blueCtld.minimumHoverHeight = 2 -- Hover min this low to load.
    blueCtld.forcehoverload = false -- Crates (not: troops) can **only** be loaded while hovering.
    blueCtld.hoverautoloading = false -- Crates in CrateDistance in a LOAD zone will be loaded automatically if space allows.
    blueCtld.enableslingload = true -- allow cargos to be slingloaded - might not work for all cargo types
    blueCtld.pilotmustopendoors = false -- force opening of doors

    blueCtld.smokedistance = 2000 -- Smoke or flares can be request for zones this far away (in meters).
    blueCtld.movetroopstowpzone = true -- Troops and vehicles will move to the nearest MOVE zone...
    blueCtld.movetroopsdistance = 1500 -- .. but only if this far away (in meters) --5000
    blueCtld.SmokeColor = SMOKECOLOR.White -- default color to use when dropping smoke from heli 
    blueCtld.FlareColor = FLARECOLOR.White -- color to use when flaring from heli

    blueCtld.basetype = "uh1h_cargo" -- default shape of the cargo container
    blueCtld.repairtime = 120 -- Number of seconds it takes to repair a unit. 300s
    blueCtld.buildtime = 3 --120 -- Number of seconds it takes to build a unit. Set to zero or nil to build instantly. 300s
    blueCtld.cratecountry = country.id.CJTF_BLUE -- ID of crates. Will default to country.id.RUSSIA for RED coalition setups.
    blueCtld.allowcratepickupagain = true  -- allow re-pickup crates that were dropped.
    blueCtld.placeCratesAhead = false -- place crates straight ahead of the helicopter, in a random way. If true, crates are more neatly sorted.
    blueCtld.nobuildinloadzones = false -- forbid players to build stuff in LOAD zones if set to `true`
    blueCtld.movecratesbeforebuild = false -- crates must be moved once before they can be build. Set to false for direct builds.
    blueCtld.surfacetypes = {land.SurfaceType.LAND,land.SurfaceType.ROAD,land.SurfaceType.RUNWAY,land.SurfaceType.SHALLOW_WATER} -- surfaces for loading back objects.

--%%% SOUNDS %%%
    --> As Ciribob CTLD, you have to load these two sound in the mission editor.
    blueCtld.RadioSound = "beacon.ogg"
    blueCtld.RadioSoundFC3 = "beacon.ogg"
    blueCtld.droppedbeacontimeout = 600 -- dropped beacon lasts 10 minutes

--%%% HERCULES %%%
    --> Specifi parameters for Hercules (i didn't test yet)
    blueCtld.HercMinAngels = 50 -- for troop/cargo drop via chute in meters, ca 470 ft (Default : 155m/470ft)
    blueCtld.HercMaxAngels = 2000 -- for troop/cargo drop via chute in meters, ca 6000 ft (Default : 2000m/6000ft)
    blueCtld.HercMaxSpeed = 77 -- 77mps or 270kph or 150kn
    blueCtld.enableHercules = true -- avoid dual loading via CTLD F10 and F8 ground crew
    local herccargo = CTLD_HERCULES:New("blue", "Hercules", blueCtld)

--%%% CAPABILITIES %%%
    --> Set capabilities in this section. Does your 'vehicule' needs to transport Cargos and/or Troops and how many. Don't be fool!

    --> Command exemple to capabilities :
    --> Var:SetUnitCapabilities(type="SA342Mistral", crates=false, troops=true, cratelimit = 0, trooplimit = 4, length = 12, cargoweightlimit = 400)
    --%% Mods %%
        blueCtld:SetUnitCapabilities("Bronco-OV-10A", true, true, 1, 5, 18, 1450) --Payload max : 1450kg
        blueCtld:SetUnitCapabilities("Hercules", true, true, 20, 10, 25, 22000)
        blueCtld:SetUnitCapabilities("T-45", false, true, 0, 1, 18, 429)
    --%% Mods - Choppers %%
        blueCtld:SetUnitCapabilities("UH-60L", true, true, 3, 10, 18, 3630)
        blueCtld:SetUnitCapabilities("MH-60R", true, true, 3, 10, 18, 3630)
        blueCtld:SetUnitCapabilities("SH-60B", true, true, 3, 10, 18, 3630)
        blueCtld:SetUnitCapabilities("OH-6A", false, true, 0, 3, 18, 684)
    --%% Choppers Euro %%
        blueCtld:SetUnitCapabilities("SA342", false, true, 0, 3, 18, 300) --Payload max : 287kg
        blueCtld:SetUnitCapabilities("SA342L", false, true, 0, 2, 18, 287)
        blueCtld:SetUnitCapabilities("SA342M", false, true, 0, 3, 18, 300)
        blueCtld:SetUnitCapabilities("SA342Mistral", false, true, 0, 1, 18, 287)
        blueCtld:SetUnitCapabilities("SA342Minigun", false, true, 0, 1, 18, 287)
    --%% Choppers Russia %%
        blueCtld:SetUnitCapabilities("Ka-50", true, false, 1, 0, 18, 1665)
        blueCtld:SetUnitCapabilities("Ka-50_3", true, false, 1, 0, 18, 1665)
        blueCtld:SetUnitCapabilities("Mi-8MTV2", true, true, 4, 10, 18, 4100) --Payload max : 4000kg
        blueCtld:SetUnitCapabilities("Mi-8MT", true, true, 4, 10, 18, 4100) --Payload max : 4000kg
        blueCtld:SetUnitCapabilities("Mi-24P", true, true, 2, 8, 18, 2500)
    --%% Choppers USA %%
        blueCtld:SetUnitCapabilities("AH-64D_BLK_II", false, true, 0, 1, 18, 3569)
        blueCtld:SetUnitCapabilities("CH-47Fbl1", true, true, 6, 10, 18, 10886)
        blueCtld:SetUnitCapabilities("OH58D", true, false, 0, 1, 18, 227)
        blueCtld:SetUnitCapabilities("UH-1H", true, true, 1, 8, 18, 1760)
    --%% Aircrafts %%
        blueCtld:SetUnitCapabilities("C-101EB", true, true, 1, 1, 18, 1000)
        blueCtld:SetUnitCapabilities("C-101CC", true, true, 1, 1, 18, 1000)
        blueCtld:SetUnitCapabilities("Christen Eagle II", false, true, 0, 1, 18, 1000)
        blueCtld:SetUnitCapabilities("L-39C", true, true, 1, 1, 18, 1000)
        blueCtld:SetUnitCapabilities("L-39ZA", true, true, 1, 1, 18, 1000)
        blueCtld:SetUnitCapabilities("MB-339A", true, true, 1, 1, 18, 1000)
        blueCtld:SetUnitCapabilities("MB-339APAN", true, true, 1, 1, 18, 1000)
        blueCtld:SetUnitCapabilities("Mirage-F1B", true, true, 1, 1, 18, 1000)
        blueCtld:SetUnitCapabilities("Mirage-F1BD", true, true, 1, 1, 18, 1000)
        blueCtld:SetUnitCapabilities("Mirage-F1BE", true, true, 1, 1, 18, 1000)
        blueCtld:SetUnitCapabilities("Mirage-F1BQ", true, true, 1, 1, 18, 1000)
        blueCtld:SetUnitCapabilities("Mirage-F1DDA", true, true, 1, 1, 18, 1000)
        blueCtld:SetUnitCapabilities("Su-25T", true, true, 1, 1, 18, 1000)
        blueCtld:SetUnitCapabilities("Yak-52", false, true, 0, 1, 18, 1000)
    --%% WarBirds %%
        blueCtld:SetUnitCapabilities("Bf-109K-4", true, true, 1, 1, 18, 1000)
        blueCtld:SetUnitCapabilities("Fw 190A8", true, true, 1, 1, 18, 1000)
        blueCtld:SetUnitCapabilities("FW-190D9", true, true, 1, 1, 18, 1000)
        blueCtld:SetUnitCapabilities("I-16", true, true, 1, 1, 18, 1000)
        blueCtld:SetUnitCapabilities("MosquitoFBMkVI", true, true, 1, 1, 18, 1000)
        blueCtld:SetUnitCapabilities("P-47D-30", true, true, 1, 1, 18, 1000)
        blueCtld:SetUnitCapabilities("P-47D-40", true, true, 1, 1, 18, 1000)
        blueCtld:SetUnitCapabilities("P-51D", true, true, 1, 1, 18, 1000)
        blueCtld:SetUnitCapabilities("P-51D-30-NA", true, true, 1, 1, 18, 1000)
        blueCtld:SetUnitCapabilities("SpitfireLFMkIX", true, true, 1, 1, 18, 1000)
        blueCtld:SetUnitCapabilities("SpitfireLFMkIXCW", true, true, 1, 1, 18, 1000)
        blueCtld:SetUnitCapabilities("TF-51D", true, true, 1, 1, 18, 1000)

    --%% GROUND TRANSPORT %%
        blueCtld:SetUnitCapabilities("Land_Rover_109_S3", false, true, 0, 4, 18, 400)
        blueCtld:SetUnitCapabilities("Hummer", false, true, 0, 4, 18, 400)
        
        blueCtld:SetUnitCapabilities("P20_drivable", true, true, 2, 8, 18, 1600)
        blueCtld:SetUnitCapabilities("M 818", true, true, 6, 10, 18, 6000) --Payload max : 4500kg

        blueCtld:SetUnitCapabilities("UAZ-469", false, true, 0, 4, 18, 400)
        blueCtld:SetUnitCapabilities("Tigr_233036", false, true, 0, 8, 18, 1000)

        blueCtld:SetUnitCapabilities("KrAZ-6322", true, true, 6, 10, 18, 6000) --Payload max : 12000kg

        blueCtld:SetUnitCapabilities("GAZ-66", true, false, 2, 0, 18, 2000)
        blueCtld:SetUnitCapabilities("Ural-375", true, false, 4, 0, 18, 4500)
        blueCtld:SetUnitCapabilities("ZIL-135", true, false, 6, 0, 18, 6000) --Payload max : 5900kg

    --%% GROUND OFFENSIVE %%
        blueCtld:SetUnitCapabilities("M1043 HMMWV Armament", false, true, 0, 4, 18, 400)
        blueCtld:SetUnitCapabilities("M1043 HMMWV TOW", false, true, 0, 4, 18, 400)
        blueCtld:SetUnitCapabilities("MaxxPro_MRAP", false, true, 0, 8, 18, 1000)
        blueCtld:SetUnitCapabilities("M1126 Stryker ICV", false, true, 0, 8, 18, 400)
        blueCtld:SetUnitCapabilities("M1134 Stryker ATGM", false, true, 0, 8, 18, 400)
        blueCtld:SetUnitCapabilities("VAB_Mephisto", false, true, 0, 8, 18, 1000)
        blueCtld:SetUnitCapabilities("TPZ", false, true, 0, 8, 18, 1000)
        blueCtld:SetUnitCapabilities("M-2 Bradley", false, true, 0, 4, 18, 400)

        blueCtld:SetUnitCapabilities("Cobra", false, true, 0, 4, 18, 400)
        blueCtld:SetUnitCapabilities("BTR-80", false, true, 0, 8, 18, 1000)
        blueCtld:SetUnitCapabilities("BTR-82A", false, true, 0, 8, 18, 1000)
        blueCtld:SetUnitCapabilities("BTR-RD", false, true, 0, 8, 18, 1000)

    --%% GROUND WWII %%
        blueCtld:SetUnitCapabilities("Willys_MB", false, true, 0, 4, 18, 400)
        blueCtld:SetUnitCapabilities("Beford_MWD", true, true, 1, 8, 18, 1000)
        blueCtld:SetUnitCapabilities("CCKW_553", true, true, 1, 8, 18, 1000)

        blueCtld:SetUnitCapabilities("Kubelwagen_82", false, true, 0, 4, 18, 400)
        blueCtld:SetUnitCapabilities("Horch_901_typ_40_kfz_21", false, true, 0, 4, 18, 400)
        blueCtld:SetUnitCapabilities("Blitz_36-6700A", true, true, 1, 8, 18, 1000)

--%%% TROOPS %%%
    local att = templateNameForAntiTank
    local aat = templateNameForAntiAir
    local inf = templateNameForSoldier
    
    --> Command exemple to add troops :
    -- Var:AddTroopsCargo(name,{templates},CTLD_CARGO.Enum.TROOPS,size, mass, stock)
    blueCtld:AddTroopsCargo("Soldier x1",{inf},CTLD_CARGO.Enum.TROOPS,1,100)
    blueCtld:AddTroopsCargo("Anti-Tank x1",{att},CTLD_CARGO.Enum.TROOPS,1,100)
    blueCtld:AddTroopsCargo("Anti-Air x1",{aat},CTLD_CARGO.Enum.TROOPS,1,100)
    blueCtld:AddTroopsCargo("Engineer x1",{inf},CTLD_CARGO.Enum.ENGINEERS,1,100)
    blueCtld:AddTroopsCargo("Mixed x4",{inf,ing,att,aat},CTLD_CARGO.Enum.TROOPS,4,100)
    blueCtld:AddTroopsCargo("Mixed x8",{inf,inf,att,att,att,aat,aat,aat},CTLD_CARGO.Enum.TROOPS,4,100)
    blueCtld:AddTroopsCargo("Mixed x10",{inf,inf,inf,att,att,att,aat,aat,aat,aat},CTLD_CARGO.Enum.TROOPS,10,100)

    --> Engineer whill repair on this perimeter
    blueCtld.EngineerSearch = 2000 -- teams will search for crates in this radius.

--%%% CARGO %%%
    --> Don't forget to add unit template in the mission editor et report names Below

    --> Command exemple to add some cargo :
    -- Var:AddCratesCargo(name,{templates},CTLD_CARGO.Enum.VEHICLE, crates to build, mass, stock)

    -- Command - 1 crate
        -- M1043 HMMWV Armament
        blueCtld:AddCratesCargo("HUMVEE (1)",{"template HMMWV"},CTLD_CARGO.Enum.VEHICLE,1,1000,nil, "Supply / Transport")
        -- template UAZ-469
        -- blueCtld:AddCratesCargo("UAZ-469 (1)",{"template UAZ-469"},CTLD_CARGO.Enum.VEHICLE,1,1000,nil, "Supply / Transport")

    -- Fuel supply
        -- M978 Refueler
        blueCtld:AddCratesCargo("M978 refueler (1)",{"template M978"},CTLD_CARGO.Enum.VEHICLE,1,1000,nil, "Supply / Transport")
        -- ATZ-5
        -- blueCtld:AddCratesCargo("ATZ-5 refueler (1)",{"template ATZ-5"},CTLD_CARGO.Enum.VEHICLE,1,1000,nil, "Supply / Transport")
        
    -- Transport - 1 crate
        -- Truck M939
        blueCtld:AddCratesCargo("Truck M939 (1)",{"template M939"},CTLD_CARGO.Enum.VEHICLE,1,1000,nil, "Supply / Transport")
        -- KrAZ-6322
        -- blueCtld:AddCratesCargo("Truck KrAZ-6322 (1)",{"template KrAZ-6322"},CTLD_CARGO.Enum.VEHICLE,1,1000,nil, "Supply / Transport")
        -- blueCtld:AddCratesRepair("Humvee Repair",{"Humvee"},CTLD_CARGO.Enum.REPAIR,1,100,nil, "Supply / Transport")

    -- ATGM - 1c
        -- ATGM M1134 Stryker ATGM
        -- blueCtld:AddCratesCargo("ATGM Stryker (2)",{"template ATGM Stryker"},CTLD_CARGO.Enum.VEHICLE,2,1000,nil, "Ground Offensive")
        -- ATGM VAB_Mephisto
        blueCtld:AddCratesCargo("ATGM VAB (2)",{"template ATGM VAB"},CTLD_CARGO.Enum.VEHICLE,2,1000,nil, "Ground Offensive")

        -- APC BTR-RD
        -- blueCtld:AddCratesCargo("ATGM BTR-RD (2)",{"template BTR-RD"},CTLD_CARGO.Enum.VEHICLE,2,1000,nil, "Ground Offensive")

    -- IFV / APC - 2c
        -- APC MRAP MaxxPro
        blueCtld:AddCratesCargo("APC MRAP MaxxPro (2)",{"template APC MRAP"},CTLD_CARGO.Enum.VEHICLE,2,1000,nil, "Ground Offensive")
        -- APC M1126 Stryker
        -- blueCtld:AddCratesCargo("APC Stryker (2)",{"tempalte APC Stryker"},CTLD_CARGO.Enum.VEHICLE,2,1000,nil, "Ground Offensive")
        -- IFV M2A2 Bradley
        -- blueCtld:AddCratesCargo("IFV M2A2 Bradley (2)",{"template IFV Bradley"},CTLD_CARGO.Enum.VEHICLE,2,1000,nil, "Ground Offensive")

        -- APC BTR-82A
        -- blueCtld:AddCratesCargo("APC BTR-82A (2)",{"template APC BTR-82A"},CTLD_CARGO.Enum.VEHICLE,2,1000,nil, "Ground Offensive")

    -- ARTILLERY - 4c

    -- MBT - 4c
        -- MBT Leclerc
        blueCtld:AddCratesCargo("MBT Leclerc (4)",{"template MBT Leclerc"},CTLD_CARGO.Enum.VEHICLE,4,1000, nil, "Ground Offensive")
        -- MBT T-72B3
        -- blueCtld:AddCratesCargo("MBT T-72B3 (4)",{"template MBT T-72B"},CTLD_CARGO.Enum.VEHICLE,4,1000, nil, "Ground Offensive")

    -- AAA canon - 1c
        -- Bofors
        blueCtld:AddCratesCargo("AAA Bofors canon (2)",{"template AAA Bofors"},CTLD_CARGO.Enum.VEHICLE,2,1000, nil, "Anti Air Defence")

        -- S-60
        -- blueCtld:AddCratesCargo("AAA S-60 Canon (2)",{"template AAA S-60"},CTLD_CARGO.Enum.VEHICLE,2,1000, nil, "Anti Air Defence")
        -- KS-100
        --blueCtld:AddCratesCargo("AAA KS-19 Canon (2)",{"template AAA KS-19"},CTLD_CARGO.Enum.VEHICLE,2,1000, nil, "Anti Air Defence")

    -- AAA - 2c
        -- Vulcan
        -- blueCtld:AddCratesCargo("AAA Vulcan (2)",{"template AAA Vulcan"},CTLD_CARGO.Enum.VEHICLE,2,1000, nil, "Anti Air Defence")
        -- C-RAM
        blueCtld:AddCratesCargo("AAA C-RAM (2)",{"template AAA C-RAM"},CTLD_CARGO.Enum.VEHICLE,2,1000, nil, "Anti Air Defence")

        -- LC ZU-23
        --blueCtld:AddCratesCargo("AAA LC ZU-23 (2)",{"template AAA LC ZU-23"},CTLD_CARGO.Enum.VEHICLE,2,1000, nil, "Anti Air Defence")
        -- Shilka
        --blueCtld:AddCratesCargo("AAA Shilka (2)",{"template AAA Shilka"},CTLD_CARGO.Enum.VEHICLE,2,1000, nil, "Anti Air Defence")
        
    -- SAM SR - 2c
        -- SAM Avenger M1097
        -- blueCtld:AddCratesCargo("SAM SR Avenger (4)",{"template SAM Avenger"},CTLD_CARGO.Enum.VEHICLE,4,1000, nil, "Surface-to-Air Missile")
        -- SAM Chaparral (CW)
        -- blueCtld:AddCratesCargo("SAM SR Chaparral (4)",{"template SAM Chaparral"},CTLD_CARGO.Enum.VEHICLE,24,1000, nil, "Surface-to-Air Missile")
        -- SAM M6 Linebacker
        -- blueCtld:AddCratesCargo("SAM SR M6 Linebacker (4)",{"template SAM Linebacker"},CTLD_CARGO.Enum.VEHICLE,4,1000, nil, "Surface-to-Air Missile")
        -- SAM Rapier
        blueCtld:AddCratesCargo("SAM SR Rapier (4)",{"template SAM Rapier"},CTLD_CARGO.Enum.VEHICLE,4,1000, nil, "Surface-to-Air Missile")

        -- SAM SA-9 Strela
        --blueCtld:AddCratesCargo("SAM SR SA-9 Strela (2)",{"template SAM SA-9"},CTLD_CARGO.Enum.VEHICLE,2,1000, nil, "Surface-to-Air Missile")
        -- SAM SA-19 Tungunska
        --blueCtld:AddCratesCargo("SAM SR SA-19 Tungunska (2)",{"template SAM SA-19"},CTLD_CARGO.Enum.VEHICLE,2,1000, nil, "Surface-to-Air Missile")

    -- SAM MR - 4c
        -- SAM Nasams
        blueCtld:AddCratesCargo("SAM MR Nasams (6)",{"template SAM Nasams"},CTLD_CARGO.Enum.VEHICLE,6,1000, nil, "Surface-to-Air Missile")
        -- SA-8 Osa
        -- blueCtld:AddCratesCargo("SAM MR SA-8 Osa (6)",{"template SAM SA-8"},CTLD_CARGO.Enum.VEHICLE,6,1000, nil, "Surface-to-Air Missile")
        -- SA-15 Tor
        -- blueCtld:AddCratesCargo("SAM MR SA-15 Tor (6)",{"template SAM SA-15"},CTLD_CARGO.Enum.VEHICLE,6,1000, nil, "Surface-to-Air Missile")
        -- SA-6 Kub
        --blueCtld:AddCratesCargo("SAM MR SA-6 Kub (6)",{"template SAM SA-6"},CTLD_CARGO.Enum.VEHICLE,6,1000, nil, "Surface-to-Air Missile")

    -- SAM LR - 6c
        -- SAM Hawk
        -- blueCtld:AddCratesCargo("SAM LR Hawk (8)",{"template SAM Hawk"},CTLD_CARGO.Enum.VEHICLE,8,1000, nil, "Surface-to-Air Missile")
        -- SAM Patriot
        -- blueCtld:AddCratesCargo("SAM LR Patriot (10)",{"template SAM Patriot"},CTLD_CARGO.Enum.VEHICLE,8,1000, nil, "Surface-to-Air Missile")

        -- SA-11 Buk
        --blueCtld:AddCratesCargo("SAM LR SA-11 Buk (8)",{"template SAM SA-11"},CTLD_CARGO.Enum.VEHICLE,8,1000, nil, "Surface-to-Air Missile")
        -- SA-10 S-300 Grumble
        --blueCtld:AddCratesCargo("SAM LR SA-10 Grumble (10)",{"template SAM SA-10"},CTLD_CARGO.Enum.VEHICLE,8,1000, nil, "Surface-to-Air Missile")

    -- EWR - 6c
        -- EWR AN/FPS 117 Radar
        blueCtld:AddCratesCargo("EWR AN/FPS 117 (8)",{"template EWR AN/FPS-117"},CTLD_CARGO.Enum.VEHICLE,8,1000, nil, "Supply / Transport")

        -- EWR 1L13
        --blueCtld:AddCratesCargo("EWR 1L13 (8)",{"template EWR 1L13"},CTLD_CARGO.Enum.VEHICLE,8,1000, nil, "Supply / Transport")
        -- EWR 55G6
        --blueCtld:AddCratesCargo("EWR 55G6 (8)",{"template EWR 55G6"},CTLD_CARGO.Enum.VEHICLE,8,1000, nil, "Supply / Transport")

    -- Other
        -- blueCtld:AddStaticsCargo("Ammunition",500)

--%%% FOB %%%
    blueCtld:AddCratesCargo("FOB/FARP (6)",{templateNameForFOB,},CTLD_CARGO.Enum.FOB,6,1000, nil, "Supply / Transport")
    local FARPFreq = 225.1
    local FARPName = 1 -- numbers 1..10
    local FARPClearnames = {
      [1]="London",
      [2]="Dallas",
      [3]="Paris",
      [4]="Moscow",
      [5]="Berlin",
      [6]="Rome",
      [7]="Madrid",
      [8]="Warsaw",
      [9]="Dublin",
      [10]="Perth",
      }

    warehouseModel = {
        {4,15,46,2578},
        {4,15,46,2577},
        {4,15,46,2576},
        {4,15,46,2575},
        {4,15,46,2574},
        {4,15,46,1771},
        {4,15,46,1770},
        {4,15,46,1769},
        {4,15,46,1764},
        {4,15,46,1765},
        {4,15,46,1766},
        {4,15,46,1767},
        {4,15,46,1768},
        {4,15,46,170},
        {4,15,46,171},
        {4,15,46,183},
        {4,15,46,1294},
        {4,15,46,1295},
        {4,15,46,824},
        {4,15,46,825},
        {4,15,46,300},
        {4,15,47,1100},
        {4,15,47,680},
        {4,15,47,679},
        {4,15,46,2476},
        {4,15,46,2477},
        {4,15,46,2478},
        {4,15,46,2479},
        {4,15,46,2480},
        {4,15,46,2481},
        {4,15,46,2482},
        {4,15,46,2483},
        {4,15,46,2484},
        {4,15,46,2579},
        {4,15,46,2580},
        {4,15,46,2581},
        {4,15,46,1057},
        {4,15,46,160},
        {4,15,46,161},
        {4,15,46,184},
        {4,15,46,174},
        {4,15,46,175},
        {4,15,46,176},
        {4,15,46,177},
        {4,15,46,20},
        {4,5,32,94},
        {4,5,32,95},
    }

    -- --this will grab the weapons from our template and fill our array with everything else
    -- for i, d in pairs(Airbase.getByName(templateNameForFARP):getWarehouse():getInventory("weapon")) do
    --     if(i == "weapon") then
    --         for i2, d2 in pairs(d) do
    --             table.insert(warehouseModel,i2)
    --         end
    --     end
    -- end

    function BuildAFARP(Coordinate)
        local coord = Coordinate
        local FarpName = ((FARPName-1)%10)+1
        local FName = FARPClearnames[FarpName]
        --FARPFreq = FARPFreq + 1
        FARPName = FARPName + 1

        UTILS.SpawnFARPAndFunctionalStatics(FName,Coordinate,ENUMS.FARPType.INVISIBLE,my_ctld.coalition,country.id.USA,FarpNameNumber,FARPFreq,radio.modulation.AM,nil,nil,nil,10,10)
        
        -- local SpawnStaticFarp=SPAWNSTATIC:NewFromStatic(templateNameForFARP, country.id.CJTF_BLUE)
        -- local SpawnStaticFarp=SPAWNSTATIC:NewFromType("Invisible FARP","Heliports", country.id.CJTF_BLUE)
        -- SpawnStaticFarp:InitFARP(FARPName, FARPFreq, 0)
        -- SpawnStaticFarp:InitDead(false)

        local ZoneSpawn = ZONE_RADIUS:New("FARP "..FName,Coordinate:GetVec2(),160,false)
        local Heading = 0
        local FarpBerlin=SpawnStaticFarp:SpawnFromZone(ZoneSpawn, Heading, "FARP "..FName)

        local base = 270 --330
        local delta = 7
        local assetDist = 60

        local windsock = SPAWNSTATIC:NewFromType("Windsock","Fortifications",country.id.CJTF_BLUE)
        local sockcoord = coord:Translate(assetDist,base)
        windsock:SpawnFromCoordinate(sockcoord,Heading,"Windsock "..FName)
        base=base-delta

        -- local ammodepot = SPAWNSTATIC:NewFromType("FARP Ammo Dump Coating","Fortifications",country.id.CJTF_BLUE)
        -- local ammocoord = coord:Translate(assetDist,base)
        -- ammodepot:SpawnFromCoordinate(ammocoord,Heading,"Ammodepot "..FName)
        -- base=base-delta

        local Tent1 = SPAWNSTATIC:NewFromType("Container_watchtower_lights","Fortifications",country.id.CJTF_BLUE)
        local Tent1Coord = coord:Translate(assetDist,base)
        Tent1:SpawnFromCoordinate(Tent1Coord,Heading+90,"Command Tent "..FName)
        base=base-delta

        -- local fueldepot = SPAWNSTATIC:NewFromType("FARP Fuel Depot","Fortifications",country.id.CJTF_BLUE)
        -- local fuelcoord = coord:Translate(assetDist,base)
        -- fueldepot:SpawnFromCoordinate(fuelcoord,Heading,"Fueldepot "..FName)
        -- base=base-delta

        -- local Tent2 = SPAWNSTATIC:NewFromType("Building08_PBR","Fortifications",country.id.CJTF_BLUE)
        -- local Tent2Coord = coord:Translate(assetDist,base)
        -- Tent2:SpawnFromCoordinate(Tent2Coord,Heading-90,"Command Tent2 "..FName)
        -- base=base-delta

        -- local windsock = SPAWNSTATIC:NewFromStatic("template FARP Dépot de munitions camouflé",country.id.CJTF_BLUE)
        -- local sockcoord = coord:Translate(125,base)
        -- windsock:SpawnFromCoordinate(sockcoord,Heading,"Windsock "..FName)
        -- base=base-delta

        -- ATC and services - put them 125m from the center of the zone towards North
        -- local FarpVehicles = SPAWN:NewWithAlias("FARP Vehicles Template","FARP "..FName.." Technicals")
        -- FarpVehicles:InitHeading(180)
        -- local FarpVCoord = coord:Translate(assetDist,0)
        -- FarpVehicles:SpawnFromCoordinate(FarpVCoord)

        -- local function addmystuff(array)
        --     --500000 is not required but its a good large figure for now
        --     Airbase.getByName(FARPName):getWarehouse():setLiquidAmount(0,500000)
        --     --iterate over each uber warehouse item and add nuclear stockpile
        --     for warei, wared in pairs(warehouseModel) do
        --         Airbase.getByName(farpname):getWarehouse():setItem(wared,500000)
        --     end
        --     return nil
        -- end

        -- --schedule function 5 seconds after the FARP has been made so the game has time to init the plate
        -- timer.scheduleFunction(addmystuff, {1}, timer.getTime() + 5)

        blueCtld:AddCTLDZone("FARP "..FName,CTLD.CargoZoneType.LOAD,SMOKECOLOR.Blue,true,true)
        local m  = MESSAGE:New(string.format("FARP %s in operation!",FName),15,"CTLD"):ToBlue() 
    end

    function blueCtld:OnAfterCratesBuild(From,Event,To,Group,Unit,Vehicle)
        local name = Vehicle:GetName()
        if string.match(name,"FOB",1,true) then
          local Coord = Vehicle:GetCoordinate()
          Vehicle:Destroy(false)
          BuildAFARP(Coord) 
        end
    end

--%%% LOADING ZONES %%%
    --> Command exemple to add zone :
    --blueCtld:AddCTLDZone("001",CTLD.CargoZoneType.LOAD,SMOKECOLOR.Blue,true,true)

    --> User defined zones
    --blueCtld:AddCTLDZone("Tarawa",CTLD.CargoZoneType.SHIP,SMOKECOLOR.Blue,true,true,240,20)
    
    --> Generated zones from pattern
    local i=0
    for i=1, 199 do
        blueCtld:AddCTLDZone(templateNameForLoadingZone..i,CTLD.CargoZoneType.LOAD,SMOKECOLOR.White,true,true)
    end

--%%% EXECUTION %%%
    blueCtld:__Start(1)
