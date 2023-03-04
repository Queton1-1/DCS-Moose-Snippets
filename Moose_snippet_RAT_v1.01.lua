--[[

    -= Moose Random Air Traffic =-

    Snippet by JGi | Quéton 1-1



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



--[[

    PARAMS

]]--
groupModel = {

{"Aerial-2",3},
{"Rotary-1"},

}

-- Départ à froid, vrai/faux
coldStart = false

-- Atterrir sur base bleu/rouge/neutre, vrai/faux
ignoreAirbaseCoalition = true



--[[

    MAIN

]]--
trigger.action.outText("Random Air Traffic | Loading...",3)
for key, value in pairs(groupModel) do
    group = nil
    nb = nil
    start = nil
    for x,y in pairs(value) do
        if x==1 then
            group=y
        elseif x==2 then
            nb=y
        end
    end

    -- Traffic aérien aléatoire
    rat = RAT
    :New(group)

    -- Type de départ
    if coldStart == true then
        rat:SetTakeoff("cold")
    else
        rat:SetTakeoff("hot")
    end

    -- Continuer périple indéfiniment
    rat:ContinueJourney()

    -- Atterrir sur aéroport bleu/rouge/indifférent
    if ignoreAirbaseCoalition == false then
        rat:SetCoalition("sameonly")
    end

    -- Nb de Spawn
    if nb ~= nil then
        rat:Spawn(nb)
    else
        rat:Spawn(1)
    end
end