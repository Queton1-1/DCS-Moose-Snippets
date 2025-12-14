--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
--%%%%% CTLD Based on MOOSE --%%%%%
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

--%%% CREDITS %%%
-- JGi | Quéton 1-1

--%%% DEPENDENCIES %%%
-- Moose : >2.9.13a_
-- Unicodes : ☮☐☑☒▮▯⚑⚐✈⏣➳⟳⭮⚒⚔☄⛽

--%%% CHANGELOG %%%
--[[
    1.08e
    - add C-130J
    - update Apache & Kiowa

    1.08d
    - update various options. Move before build and other i don't remember.
    - movetroopsdistance = 1500 > 5000
    - buildtime = 30 > 120
    
    1.08c
    - add verification in zone parsing
    - add Pantsir SA-22, SA-15 M2, IRIS-T, MBTs
    - add options dynamic spawn to farp generator (Moose Utils)

    1.08b
    - rename file
    - add last options from Moose 2.9.13 (Combined Arms & cargo planes without tweak Moose)

    1.08
    - add Sams
    - Rename to CTLD xxxx
    
    1.07
    - update script name to MooseCTLD_blue / MooseCTLD_red
    - update templates SAM layout
    - update available crates
    - update troops
    - replace utility UAZ by Cobra
    - activate FAC Mantis 3 - 288.00 MHz for utility HMMWV and Cobra
    - update APC / IFV
    - update sound

    1.06
    - update and correct function BuildAFarp
        
    1.05
    - add JTAC, TODO : add way to go and search for target
    - add FAC vehicules, driveable
    
    1.04
    - update FARP Spawn
    - update cargo mass 2000lbs > 907,184 kg
    - add Cargo to refill FARP/FOB
    
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
    Add complete Hercules supported
    Add behavior to troops and véchicule to search ennemies after drop.
--]]

--%%% CHANGE CTLD COALITION %%%
-- Search and replace blue / BLUE text, adjust cargos

--%%% MAIN OBJECT %%%
    --> Main instance of CTLD. Filter on all unit with ".". Do no touch!
    local blueCtld = CTLD:New(coalition.side.BLUE,{"."},"Blue CTLD")

--%%% TEMPLATES NAMES %%%
    --> For each mission, in the mission editor, you have to place late activated units as models
    --> Put here model's name from mission editor, or use these names.
    local templateNameForLoadingZone = "pz-"
    local templateNameForFOB = "CTLD FOB"
    local templateNameForFARP = "CTLD FARP single-1"
    local templateNameForSoldier = "CTLD soldier"
    local templateNameForAntiTank = "CTLD anti-tank"
    local templateNameForAntiAir = "CTLD anti-air"
    -- local templateNameForAntiAir = "CTLD SA-18"
    local templateNameForJTAC = "CTLD JTAC"
    --> For cargos and troops, report templates's names from editor in the right named section below.    

--%%% OPTIONS FIXED WINGS %%%
    blueCtld.enableFixedWing = true

--%%% OPTIONS PREFIX %%%
    blueCtld.useprefix = false -- Adjust **before** starting CTLD. If set to false, *all* choppers of the coalition side will be enabled for CTLD.
    blueCtld.usesubcats = true -- use sub-category names for crates, adds an extra menu layer in "Get Crates", useful if you have > 10 crate types.
    blueCtld.suppressmessages = false -- Set to true if you want to script your own messages.
    blueCtld.nobuildmenu = false -- if set to true effectively enforces to have engineers build/repair stuff for you.
    blueCtld.onestepmenu = true

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
    blueCtld.enableChinookGCLoading =true
    blueCtld.ChinookTroopCircleRadius=5

    blueCtld.smokedistance = 2000 -- Smoke or flares can be request for zones this far away (in meters).
    blueCtld.movetroopstowpzone = true -- Troops and vehicles will move to the nearest MOVE zone...
    blueCtld.movetroopsdistance = 5000 -- .. but only if this far away (in meters) --5000
    blueCtld.SmokeColor = SMOKECOLOR.White -- default color to use when dropping smoke from heli 
    blueCtld.FlareColor = FLARECOLOR.White -- color to use when flaring from heli

    blueCtld.basetype = "container_cargo" -- default shape of the cargo container
    blueCtld.repairtime = 120 -- Number of seconds it takes to repair a unit. 300s
    blueCtld.buildtime = 120 --120 -- Number of seconds it takes to build a unit. Set to zero or nil to build instantly. 300s
    blueCtld.cratecountry = country.id.CJTF_BLUE -- ID of crates. Will default to country.id.RUSSIA for RED coalition setups.
    blueCtld.allowcratepickupagain = true  -- allow re-pickup crates that were dropped.
    blueCtld.placeCratesAhead = false -- place crates straight ahead of the helicopter, in a random way. If true, crates are more neatly sorted.
    blueCtld.nobuildinloadzones = false -- forbid players to build stuff in LOAD zones if set to `true`
    blueCtld.movecratesbeforebuild = true -- crates must be moved once before they can be build. Set to false for direct builds.
    blueCtld.surfacetypes = {land.SurfaceType.LAND,land.SurfaceType.ROAD,land.SurfaceType.RUNWAY,land.SurfaceType.SHALLOW_WATER} -- surfaces for loading back objects.

    --[[ INFO - CARGO
        Given the correct shape, Moose created cargo can theoretically be either loaded with the ground crew or via the F10 CTLD menu. It is strongly stated to avoid using shapes with CTLD which can be Ground Crew loaded. Static shapes loadable into the Chinook and thus to be avoided for CTLD are at the time of writing:
        * Ammo box (type "ammo_crate")
        * M117 bomb crate (type name "m117_cargo")
        * Dual shell fuel barrels (type name "barrels")
        * UH-1H net (type name "uh1h_cargo")
    --]]

--%%% CA CTLD %%%
    local combinedArms = SET_CLIENT:New():HandleCASlots():FilterCoalitions("blue"):FilterPrefixes(""):FilterStart()
    blueCtld:AllowCATransport(true,combinedArms)

--%%% SOUNDS %%%
    --> As Ciribob CTLD, you have to load these two sound in the mission editor.
    blueCtld.RadioSound = "beacon.ogg"
    blueCtld.RadioSoundFC3 = "beaconsilent.ogg"
    blueCtld.droppedbeacontimeout = 600 -- dropped beacon lasts 10 minutes

--%%% HERCULES %%%
    --> Specific parameters for Hercules (i didn't test yet)
    blueCtld.HercMinAngels = 50 -- for troop/cargo drop via chute in meters, ca 470 ft (Default : 155m/470ft)
    blueCtld.HercMaxAngels = 2000 -- for troop/cargo drop via chute in meters, ca 6000 ft (Default : 2000m/6000ft)
    blueCtld.HercMaxSpeed = 77 -- 77mps or 270kph or 150kn
    blueCtld.enableHercules = true -- avoid dual loading via CTLD F10 and F8 ground crew
    -- local herccargo = CTLD_HERCULES:New("blue", "Hercules", blueCtld)

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
        blueCtld:SetUnitCapabilities("AH-64D_BLK_II", false, false, 0, 1, 18, 3569)
        blueCtld:SetUnitCapabilities("CH-47Fbl1", true, true, 6, 10, 18, 10886)
        blueCtld:SetUnitCapabilities("OH58D", false, true, 0, 1, 18, 227)
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
    --%% CARGO %%
        blueCtld:SetUnitCapabilities("C-130J-30", true, true, 20, 10, 25, 22000)

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
    local jtac = templateNameForJTAC
    
    --> Command exemple to add troops :
    -- Var:AddTroopsCargo(name,{templates},CTLD_CARGO.Enum.TROOPS,size, mass, stock)
    
    blueCtld:AddTroopsCargo("Soldier x1",{inf},CTLD_CARGO.Enum.TROOPS,1,100)
    blueCtld:AddTroopsCargo("Anti-Tank x1",{att},CTLD_CARGO.Enum.TROOPS,1,100)
    blueCtld:AddTroopsCargo("Anti-Air x1",{aat},CTLD_CARGO.Enum.TROOPS,1,100)
    blueCtld:AddTroopsCargo("Engineer x1",{inf},CTLD_CARGO.Enum.ENGINEERS,1,100)
    blueCtld:AddTroopsCargo("JTAC x1",{jtac},CTLD_CARGO.Enum.TROOPS,1,100)
    blueCtld:AddTroopsCargo("Mixed x4",{inf,att,att,aat},CTLD_CARGO.Enum.TROOPS,4,100)
    blueCtld:AddTroopsCargo("Mixed x8",{inf,inf,att,att,att,aat,aat,aat},CTLD_CARGO.Enum.TROOPS,4,100)
    blueCtld:AddTroopsCargo("Mixed x10",{inf,inf,att,att,att,att,att,aat,aat,aat},CTLD_CARGO.Enum.TROOPS,10,100)

    --> Engineer whill repair on this perimeter
    blueCtld.EngineerSearch = 2500 -- teams will search for crates in this radius.

--%%% CARGO %%%
    --> Don't forget to add unit template in the mission editor et report names Below

    --> Command exemple to add some cargo :
    -- Var:AddCratesCargo(name,{templates},CTLD_CARGO.Enum.VEHICLE, crates to build, mass, stock)

    -- Command / FAC
        -- Cargo FARP
        -- blueCtld:AddStaticsCargo("FARP supply-1-1",907.184,nil,"Supply / Transport")
        -- blueCtld:AddStaticsCargo("FARP supply-2-1",907.184,nil,"Supply / Transport")

        -- FAC Land Rover (modern / cold war)
        -- blueCtld:AddCratesCargo("FAC Land Rover (1)",{"CTLD FAC Land Rover"},CTLD_CARGO.Enum.VEHICLE,1,907.184,nil, "Supply / Transport")
        -- M1043 HMMWV Armament (modern)
        blueCtld:AddCratesCargo("HUMVEE (1)",{"CTLD HMMWV"},CTLD_CARGO.Enum.VEHICLE,1,907.184,nil, "Supply / Transport")

        -- Cobra (modern / cold war)
        -- blueCtld:AddCratesCargo("Cobra (1)",{"CTLD Cobra"},CTLD_CARGO.Enum.VEHICLE,1,907.184,nil, "Supply / Transport")
        -- FAC UAZ-469 (modern / cold war)
        -- blueCtld:AddCratesCargo("FAC UAZ-469 (1)",{"CTLD FAC UAZ-469"},CTLD_CARGO.Enum.VEHICLE,1,907.184,nil, "Supply / Transport")

    -- Fuel supply
        -- M978 Refueler (modern / cold war)
        blueCtld:AddCratesCargo("M978 refueler (1)",{"CTLD M978"},CTLD_CARGO.Enum.VEHICLE,1,907.184,nil, "Supply / Transport")
        -- ATZ-5 (modern / cold war)
        -- blueCtld:AddCratesCargo("ATZ-5 refueler (1)",{"CTLD ATZ-5"},CTLD_CARGO.Enum.VEHICLE,1,907.184,nil, "Supply / Transport")
        
    -- Transport
        -- Truck M939 (modern / cold war)
        blueCtld:AddCratesCargo("Truck M939 (1)",{"CTLD M939"},CTLD_CARGO.Enum.VEHICLE,1,907.184,nil, "Supply / Transport")

        -- KrAZ-6322 (modern / cold war)
        -- blueCtld:AddCratesCargo("Truck KrAZ-6322 (1)",{"CTLD KrAZ-6322"},CTLD_CARGO.Enum.VEHICLE,1,907.184,nil, "Supply / Transport")
        -- blueCtld:AddCratesRepair("Humvee Repair",{"Humvee"},CTLD_CARGO.Enum.REPAIR,1,100,nil, "Supply / Transport")

    -- ATGM
        -- ATGM M1134 Stryker ATGM (modern / cold war)
        -- blueCtld:AddCratesCargo("ATGM Stryker (2)",{"CTLD ATGM Stryker"},CTLD_CARGO.Enum.VEHICLE,2,907.184,nil, "Ground Offensive")
        -- ATGM VAB_Mephisto (modern / cold war)
        blueCtld:AddCratesCargo("ATGM VAB (2)",{"CTLD ATGM VAB"},CTLD_CARGO.Enum.VEHICLE,2,907.184,nil, "Ground Offensive")

        -- APC BTR-RD (modern / cold war)
        -- blueCtld:AddCratesCargo("ATGM BTR-RD (2)",{"CTLD BTR-RD"},CTLD_CARGO.Enum.VEHICLE,2,907.184,nil, "Ground Offensive")

    -- APC
        -- APC MRAP MaxxPro (modern)
        blueCtld:AddCratesCargo("APC MRAP MaxxPro (2)",{"CTLD APC MRAP"},CTLD_CARGO.Enum.VEHICLE,2,907.184,nil, "Ground Offensive")
        -- APC M1126 Stryker (modern / cold war)
        -- blueCtld:AddCratesCargo("APC Stryker (2)",{"CTLD APC Stryker"},CTLD_CARGO.Enum.VEHICLE,2,907.184,nil, "Ground Offensive")

        -- APC BTR-82A (modern)
        -- blueCtld:AddCratesCargo("APC BTR-82A (2)",{"CTLD APC BTR-82A"},CTLD_CARGO.Enum.VEHICLE,2,907.184,nil, "Ground Offensive")
        -- APC MTLB (modern / cold war)
        -- blueCtld:AddCratesCargo("IFV MTLB (2)",{"CTLD APC MTLB"},CTLD_CARGO.Enum.VEHICLE,2,907.184,nil, "Ground Offensive")
        
    -- IFV
        -- IFV M2A2 Bradley (modern)
        blueCtld:AddCratesCargo("IFV M2A2 Bradley (3)",{"CTLD IFV Bradley"},CTLD_CARGO.Enum.VEHICLE,3,907.184,nil, "Ground Offensive")

        -- IFV BMP-1 (modern / cold war)
        -- blueCtld:AddCratesCargo("IFV BMP-1 (3)",{"CTLD IFV BMP-1"},CTLD_CARGO.Enum.VEHICLE,3,907.184,nil, "Ground Offensive")
        -- IFV BMP-2 (modern)
        -- blueCtld:AddCratesCargo("IFV BMP-2 (3)",{"CTLD IFV BMP-2"},CTLD_CARGO.Enum.VEHICLE,3,907.184,nil, "Ground Offensive")
        
    -- ARTILLERY
        -- MLRS M270 (modern / cold war)
        blueCtld:AddCratesCargo("MLRS M270 (4)",{"CTLD MLRS M270"},CTLD_CARGO.Enum.VEHICLE,4,907.184, nil, "Ground Offensive")

        -- SPH Dana (modern / cold war)
        -- blueCtld:AddCratesCargo("SPH Dana (4)",{"CTLD SPH Dana"},CTLD_CARGO.Enum.VEHICLE,4,907.184, nil, "Ground Offensive")
        -- SPH Paladin (modern / cold war)
        blueCtld:AddCratesCargo("SPH Paladin (4)",{"CTLD SPH Paladin"},CTLD_CARGO.Enum.VEHICLE,4,907.184, nil, "Ground Offensive")

        -- MLRS Uragan (modern / cold war)
        -- blueCtld:AddCratesCargo("MLRS Uragan (4)",{"CTLD MLRS Uragan"},CTLD_CARGO.Enum.VEHICLE,4,907.184, nil, "Ground Offensive")
        -- blueCtld:AddCratesCargo("MLRS TOS-1A (4)",{"CTLD MLRS TOS-1A"},CTLD_CARGO.Enum.VEHICLE,4,907.184, nil, "Ground Offensive")

        -- SPH Akatsia (modern / cold war)
        -- blueCtld:AddCratesCargo("SPH Akatsia (4)",{"CTLD SPH Akatsia"},CTLD_CARGO.Enum.VEHICLE,4,907.184, nil, "Ground Offensive")
        -- SPH Firtina (modern / cold war)
        -- blueCtld:AddCratesCargo("SPH Firtina (4)",{"CTLD SPH Firtina"},CTLD_CARGO.Enum.VEHICLE,4,907.184, nil, "Ground Offensive")
        
    -- MBT
        -- MBT Leclerc (modern)
        blueCtld:AddCratesCargo("MBT Leclerc (4)",{"CTLD MBT Leclerc"},CTLD_CARGO.Enum.VEHICLE,4,907.184, nil, "Ground Offensive")
        -- MBT Abrams (modern)
        -- blueCtld:AddCratesCargo("MBT Abrams (4)",{"CTLD MBT Abrams"},CTLD_CARGO.Enum.VEHICLE,4,907.184, nil, "Ground Offensive")

        -- MBT T-72B3 (modern / late cold war)
        -- blueCtld:AddCratesCargo("MBT T-72B (4)",{"CTLD MBT T-72B"},CTLD_CARGO.Enum.VEHICLE,4,907.184, nil, "Ground Offensive")
        -- MBT T-90 (modern)
        -- blueCtld:AddCratesCargo("MBT T-84 (4)",{"CTLD MBT T-84"},CTLD_CARGO.Enum.VEHICLE,4,907.184, nil, "Ground Offensive")
        -- blueCtld:AddCratesCargo("MBT T-90M (4)",{"CTLD MBT T-90M"},CTLD_CARGO.Enum.VEHICLE,4,907.184, nil, "Ground Offensive")

    -- AAA canon
        -- Bofors (modern / cold war)
        blueCtld:AddCratesCargo("AAA Bofors canon (2)",{"CTLD AAA Bofors"},CTLD_CARGO.Enum.VEHICLE,2,907.184, nil, "Anti Air Defence")

        -- S-60 (modern / cold war)
        -- blueCtld:AddCratesCargo("AAA S-60 Canon (2)",{"CTLD AAA S-60"},CTLD_CARGO.Enum.VEHICLE,2,907.184, nil, "Anti Air Defence")
        -- KS-100 (modern / cold war)
        --blueCtld:AddCratesCargo("AAA KS-19 Canon (2)",{"CTLD AAA KS-19"},CTLD_CARGO.Enum.VEHICLE,2,907.184, nil, "Anti Air Defence")

    -- AAA
        -- Vulcan (modern / late cold war)
        -- blueCtld:AddCratesCargo("AAA Vulcan (2)",{"CTLD AAA Vulcan"},CTLD_CARGO.Enum.VEHICLE,2,907.184, nil, "Anti Air Defence")
        -- C-RAM (modern)
        blueCtld:AddCratesCargo("AAA C-RAM (2)",{"CTLD AAA C-RAM"},CTLD_CARGO.Enum.VEHICLE,2,907.184, nil, "Anti Air Defence")

        -- LC ZU-23 (modern / cold war)
        --blueCtld:AddCratesCargo("AAA LC ZU-23 (2)",{"CTLD AAA LC ZU-23"},CTLD_CARGO.Enum.VEHICLE,2,907.184, nil, "Anti Air Defence")
        -- Shilka (modern / cold war)
        --blueCtld:AddCratesCargo("AAA Shilka (2)",{"CTLD AAA Shilka"},CTLD_CARGO.Enum.VEHICLE,2,907.184, nil, "Anti Air Defence")
        
    -- SAM SR
        -- SAM Avenger M1097 (modern)
        blueCtld:AddCratesCargo("SAM SR Avenger (4)",{"CTLD SAM Avenger"},CTLD_CARGO.Enum.VEHICLE,4,907.184, nil, "Surface-to-Air Missile")
        -- SAM Chaparral (cold war) 
        -- blueCtld:AddCratesCargo("SAM SR Chaparral (4)",{"CTLD SAM Chaparral"},CTLD_CARGO.Enum.VEHICLE,24,907.184, nil, "Surface-to-Air Missile")
        -- SAM M6 Linebacker (modern)
        blueCtld:AddCratesCargo("SAM SR M6 Linebacker (4)",{"CTLD SAM Linebacker"},CTLD_CARGO.Enum.VEHICLE,4,907.184, nil, "Surface-to-Air Missile")
        -- SAM Rapier (modern / cold war)
        blueCtld:AddCratesCargo("SAM SR Rapier (4)",{"CTLD SAM Rapier"},CTLD_CARGO.Enum.VEHICLE,4,907.184, nil, "Surface-to-Air Missile")

        -- SAM SA-9 Strela (modern / cold war)
        --blueCtld:AddCratesCargo("SAM SR SA-9 Strela (4)",{"CTLD SAM SA-9"},CTLD_CARGO.Enum.VEHICLE,4,907.184, nil, "Surface-to-Air Missile")
        -- SAM SA-19 Tungunska (modern)
        --blueCtld:AddCratesCargo("SAM SR SA-19 Tungunska (4)",{"CTLD SAM SA-19"},CTLD_CARGO.Enum.VEHICLE,4,907.184, nil, "Surface-to-Air Missile")

    -- SAM MR
        -- SAM Nasams (modern)
        blueCtld:AddCratesCargo("SAM MR Nasams (6)",{"CTLD SAM Nasams"},CTLD_CARGO.Enum.VEHICLE,6,907.184, nil, "Surface-to-Air Missile")
        -- SAM Hawk (modern / cold war)
        blueCtld:AddCratesCargo("SAM MR Hawk (8)",{"CTLD Hawk"},CTLD_CARGO.Enum.VEHICLE,8,907.184, nil, "Surface-to-Air Missile")
        -- SAM IRIS-T SLM (modern)
        blueCtld:AddCratesCargo("SAM MR IRIS-T (8)",{"CTLD SAM IRIT-T SLM"},CTLD_CARGO.Enum.VEHICLE,8,907.184, nil, "Surface-to-Air Missile")

        -- SA-2 (modern / cold war)
        -- blueCtld:AddCratesCargo("SAM MR SA-2 Guideline (6)",{"CTLD SAM SA-2"},CTLD_CARGO.Enum.VEHICLE,6,907.184, nil, "Surface-to-Air Missile")
        -- SA-3 (modern / cold war)
        -- blueCtld:AddCratesCargo("SAM MR SA-3 Goa (6)",{"CTLD SAM SA-3"},CTLD_CARGO.Enum.VEHICLE,6,907.184, nil, "Surface-to-Air Missile")
        -- SA-8 Osa (modern / cold war)
        -- blueCtld:AddCratesCargo("SAM MR SA-8 Osa (6)",{"CTLD SAM SA-8"},CTLD_CARGO.Enum.VEHICLE,6,907.184, nil, "Surface-to-Air Missile")
        -- SA-15 Tor (modern)
        -- blueCtld:AddCratesCargo("SAM MR SA-15 Tor (8)",{"CTLD SAM SA-15"},CTLD_CARGO.Enum.VEHICLE,8,907.184, nil, "Surface-to-Air Missile")
        -- blueCtld:AddCratesCargo("SAM MR SA-15 Tor M2 (8)",{"CTLD SAM SA-15 M2"},CTLD_CARGO.Enum.VEHICLE,8,907.184, nil, "Surface-to-Air Missile")
        -- SA-6 Kub (modern / cold war)
        -- blueCtld:AddCratesCargo("SAM MR SA-6 Kub (6)",{"CTLD SAM SA-6"},CTLD_CARGO.Enum.VEHICLE,6,907.184, nil, "Surface-to-Air Missile")
        -- SA-22 Pantsir
        -- blueCtld:AddCratesCargo("SAM MR SA-22 Pantsir (8)",{"CTLD SAM SA-22"},CTLD_CARGO.Enum.VEHICLE,8,907.184, nil, "Surface-to-Air Missile")

    -- SAM LR
        -- SAM Patriot (modern)
        -- blueCtld:AddCratesCargo("SAM LR Patriot (10)",{"CTLD SAM Patriot"},CTLD_CARGO.Enum.VEHICLE,8,907.184, nil, "Surface-to-Air Missile")

        -- SA-11 Buk (modern)
        --blueCtld:AddCratesCargo("SAM LR SA-11 Buk (8)",{"CTLD SAM SA-11"},CTLD_CARGO.Enum.VEHICLE,8,907.184, nil, "Surface-to-Air Missile")
        -- SA-10 S-300 Grumble ((modern / cold war))
        --blueCtld:AddCratesCargo("SAM LR SA-10 Grumble (10)",{"CTLD SAM SA-10"},CTLD_CARGO.Enum.VEHICLE,8,907.184, nil, "Surface-to-Air Missile")

    -- EWR
        -- EWR AN/FPS 117 Radar
        blueCtld:AddCratesCargo("EWR AN/FPS 117 (8)",{"CTLD EWR AN/FPS-117"},CTLD_CARGO.Enum.VEHICLE,8,907.184, nil, "Supply / Transport")

        -- EWR 1L13
        --blueCtld:AddCratesCargo("EWR 1L13 (8)",{"CTLD EWR 1L13"},CTLD_CARGO.Enum.VEHICLE,8,907.184, nil, "Supply / Transport")
        -- EWR 55G6
        --blueCtld:AddCratesCargo("EWR 55G6 (8)",{"CTLD EWR 55G6"},CTLD_CARGO.Enum.VEHICLE,8,907.184, nil, "Supply / Transport")

    -- Other
        -- blueCtld:AddStaticsCargo("Ammunition",500)

--%%% FOB %%%
    blueCtld:AddCratesCargo("FOB/FARP (6)",{templateNameForFOB,},CTLD_CARGO.Enum.FOB,6,907.184, nil, "Supply / Transport")
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

    local warehouseModel = {
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
    --this will grab the weapons from our template and fill our array with everything else
    -- for i, d in pairs(Airbase.getByName(templateNameForFARP):getWarehouse():getInventory("weapon")) do
    --     if(i == "weapon") then
    --         for i2, d2 in pairs(d) do
    --             table.insert(warehouseModel,i2)
    --         end
    --     end
    -- end

    function BuildAFARP_blue(Coordinate)
        local coord = Coordinate  --Core.Point#COORDINATE
        local farpCallsign = ((FARPName-1)%10)+1 -- make sure 11 becomes 1 etc
        local farpName = FARPClearnames[farpCallsign] -- get clear namee
        FARPName = FARPName + 1
 
        farpName = "CTLD ".. farpName .." "..tostring(FARPFreq).."AM" -- make name unique
 
        -- Get a Zone for loading 
        local ZoneSpawn = ZONE_RADIUS:New("FARP "..farpName,Coordinate:GetVec2(),150,false)
 
        -- Spawn a FARP with our little helper and fill it up with resources (10t fuel each type, 10 pieces of each known equipment)
        -- ENUMS.FARPType.INVISIBLE
        -- ENUMS.FARPType.PADSINGLE
        -- ENUMS.FARPType.FARP
        -- UTILS.SpawnFARPAndFunctionalStatics(farpName,Coordinate,ENUMS.FARPType.INVISIBLE,redCtld.coalition,country.id.CJTF_BLUE,farpCallsign,FARPFreq,radio.modulation.AM,nil,nil,nil,100,100)
        ---UTILS.SpawnFARPAndFunctionalStatics(Name,Coordinate,FARPType,Coalition,Country,CallSign,Frequency,Modulation,ADF,SpawnRadius,VehicleTemplate,Liquids,Equipment,Airframes,F10Text,DynamicSpawns,HotStart)
        UTILS.SpawnFARPAndFunctionalStatics(farpName,Coordinate,ENUMS.FARPType.PADSINGLE,blueCtld.coalition,country.id.CJTF_BLUE,farpCallsign,FARPFreq,radio.modulation.AM,nil,nil,nil,100,100,100,nil,true,true)
 
        -- add a loadzone to CTLD
        blueCtld:AddCTLDZone("FARP "..farpName,CTLD.CargoZoneType.LOAD,SMOKECOLOR.Blue,true,true)
        local m  = MESSAGE:New(string.format("FARP %s in operation!",farpName),15,"CTLD"):ToBlue() 
        
        -- local SpawnStaticFarp=SPAWNSTATIC:NewFromStatic(templateNameForFARP, country.id.CJTF_BLUE)
        -- local SpawnStaticFarp=SPAWNSTATIC:NewFromType("Invisible FARP","Heliports", country.id.CJTF_BLUE)
        -- SpawnStaticFarp:InitFarpDynamicSpawns
        -- SpawnStaticFarp:InitFARP(FARPName, FARPFreq, 0)
        -- SpawnStaticFarp:InitDead(false)

        local ZoneSpawn = ZONE_RADIUS:New("FARP "..farpName,Coordinate:GetVec2(),150,false)
        local Heading = 0

        local base = 270
        local delta = 20
        local assetDist = 60

        local Tent1 = SPAWNSTATIC:NewFromType("Container_watchtower_lights","Fortifications",country.id.CJTF_BLUE)
        local Tent1Coord = coord:Translate(assetDist,base)
        Tent1:SpawnFromCoordinate(Tent1Coord,Heading+90,"CTLD Command Tent "..farpName)
        base=base-delta

        blueCtld:AddCTLDZone("FARP "..farpName,CTLD.CargoZoneType.LOAD,SMOKECOLOR.Blue,true,true)
        local m  = MESSAGE:New(string.format("FARP %s in operation!",farpName),15,"CTLD"):ToBlue() 
    end

--%%% FSM %%%
    function blueCtld:OnAfterCratesBuild(From,Event,To,Group,Unit,Vehicle)
        local name = Vehicle:GetName()
        if string.match(name,"FOB",1) then
        local Coord = Vehicle:GetCoordinate()
        Vehicle:Destroy(false)
        BuildAFARP_blue(Coord)
        end
    end

    function blueCtld:OnAfterTroopsDeployed(From, Event, To, Group, Unit, Troops)
        --[[
        local function ifFound (foundItem, val)
            found[#found + 1] = foundItem:getName()
            if foundItem:getTypeName() == val then
                env.info('Tech static object found')
            end
            return true
        end
        world.searchObjects(Object.Category.UNIT, volS, ifFound)
        trigger.action.setAITask(Group, taskIndex)
        --]]
    end

--%%% LOADING ZONES %%%
    --> Command exemple to add zone :
    --blueCtld:AddCTLDZone("001",CTLD.CargoZoneType.LOAD,SMOKECOLOR.Blue,true,true)

    --> User defined zones
    --blueCtld:AddCTLDZone("Tarawa",CTLD.CargoZoneType.SHIP,SMOKECOLOR.Blue,true,true,240,20)
    
    --> Generated zones from pattern
    local i=0
    for i=1, 99 do
        if trigger.misc.getZone(templateNameForLoadingZone..i)~=nil then
            blueCtld:AddCTLDZone(templateNameForLoadingZone..i,CTLD.CargoZoneType.LOAD,SMOKECOLOR.White,true,true)
        end
    end

--%%% EXECUTION %%%
    blueCtld:__Start(1)
