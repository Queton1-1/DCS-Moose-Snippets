--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
--%%% Moose Random Air Traffic %%%
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

--%%% CREDITS %%%
-- Snippet by JGi | Quéton 1-1

--%%% DEPENDENCIES %%%
-- Moose 2.9.6 /!\

--%%% USAGE %%%
--[[
    (FR)
    Le chargement de la lib Moose est requis avant l'exécution.
    Ajoutez un déclencheur, avec condition 'temps sup à ' spécifiez quelques secondes et 
    chargez le script
        soit en tant que fichier .lua avec l'action 'executer fichier script'
        soit en copier/coller à partir le la ligne 'groupModel' avec l'action 'executer script'

    Ajoutez vos groupes à la liste comme suit

    groupModel = {
    {"Nom de mon 1er groupe", nombre de spawn},
    {"Nom de mon 2nd groupe", nombre de spawn},
    {"Nom de mon 3eme groupe"},
    }

    /!\ Attention au accolades, guillemets et virgules
    Si nombre de spawn pas renseigné, un seul spawn.



    (EN)
    Need Moose lib to be loaded before this script
    Add new trigger, with 'time more' as conditions ans specify few seconds, 
    in action column load the script (as file or execution with copy/paste in the box)

    Modify params in PARAMS below.
    Structure is simple : {"my group name", how many to spawn},

    Be aware with {} "" and ,

    Enjoy!
]]--

--trigger.action.outText("Random Air Traffic | Loading...",3)

--%%% PARAMS %%%
local groupModel = {
    {"RAT - C-130",5},
    {"RAT - Su-27",2},
    {"RAT - MiG-29S",2},
    {"RAT - JF-17",2},
    {"RAT - Mi-24P",5},
}
--> Départ à froid, vrai/faux
local coldStart = false
--> Atterrir sur base bleu/rouge/neutre, vrai/faux
local ignoreAirbaseCoalition = true
--> Distance
local distanceMin = 50
--local distanceMax = 500
--> RespawnTime
local respawnTime = 30
--> Afficher messages de l'ATC (true/false)
local atcMsg = false
--> Comportement ("hold" = weapon hold, "return" = return fire, "free" = weapons free)
local ROE = "hold"
--> Comportement défensif ("noreaction" = no reaction to threats, "passive" = passive defence, "evade" = evade enemy attacks)
local ROT = "passive"

--%%% MAIN %%%
for key, value in pairs(groupModel) do
    local group = nil
    local nb = nil
    local start = nil
    for x,y in pairs(value) do
        if x==1 then group=y elseif x==2 then nb=y end
    end
    --> Traffic aérien aléatoire
    local rat = RAT:New(group)
    --> Type de départ
    if coldStart == true then rat:SetTakeoff("cold") else rat:SetTakeoff("hot") end
    --> Distance
    if distanceMin then rat:SetMinDistance(distanceMin) end
    if distanceMax then rat:SetMaxDistance(distanceMax) end
    --> Continuer périple indéfiniment
    rat:ContinueJourney()
    if respawnTime then rat:RespawnAfterLanding(30) end
    --> Temps Respawn
    rat:RespawnAfterLanding(30)
    --> Atterrir sur aéroport bleu/rouge/indifférent
    if ignoreAirbaseCoalition == false then rat:SetCoalition("sameonly") end
    if atcMsg == false then rat:ATC_Messages(false) end
    --> ROE ("hold" = weapon hold, "return" = return fire, "free" = weapons free)
    if ROE == "return" or ROE == "free" then rat:SetROE(ROE) else rat:SetROE("hold") end
    --> ROT ("noreaction" = no reaction to threats, "passive" = passive defence, "evade" = evade enemy attacks)
    if ROT == "passive" or ROT == "evade" then rat:SetROE(ROT) else rat:SetROE("noreaction") end
    --> Nb de Spawn
    if nb ~= nil then rat:Spawn(nb) else rat:Spawn(1) end
end