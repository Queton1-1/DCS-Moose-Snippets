--%%%%%%%%%%%%%%%%%%%%%%%%%%%
--%%% SNIPPET MOOSE SPAWN %%%
--%%%%%%%%%%%%%%%%%%%%%%%%%%%

--%%% CREDITS %%%
-- JGi | Quéton 1-1

--%%% DEPENDENCIES %%%
-- Moose >2.9

--%%% CHANGELOG %%%
--[[
    1.06
    - Ajout condition existence
    
    1.05
    - Refactor
--]]

--%%% USAGE %%%
--[[
    (FR)
    Le chargement de la lib Moose est requis avant l'exécution.
    Ajoutez un déclencheur, avec condition 'temps sup à ' spécifiez quelques secondes et 
    chargez le script
        soit en tant que fichier .lua avec l'action 'executer fichier script'
        soit en copier/coller à partir le la ligne 'group' avec l'action 'executer script'
        (Spécifiquement pour ce script, je recommande la seconde solution)

    /!\ Attention au accolades, guillemets et virgules

    Personalisez le scripts suivant vos besoins.
    Certaines fonction sont désactivées, supprimez les -- pour activer

    (EN)
    Need Moose lib to be loaded before this script
    Add new trigger, with 'time more' as conditions ans specify few seconds, 
    in action column, load the script (as file or execution with copy/paste in the box - i prefer 2nd solution for this script)

    Be aware with {} "" and ,

    Modify params as needed.
    If -- before functions, it will be ignored
]]--

--%%%%%%%%%%%%%%%%%%%%%%%%%%%%
--%%%%% VERSION COMMENTE %%%%%
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%
local group="groupe_modele"
--> Nom du groupe dans l'éditeur en activation retardée, a ne saisir qu'ici

--> Optionnel : Mode Iterable - Si plusieurs groupes identiques (mon_groupe-1 mon_groupe-2 etc..) à spawner
-- local firstGroupNumber = 1
-- local lastGroupNumber  = 4
-- local groupTemp = group
-- for i = firstGroupNumber , lastGroupNumber  do
-- group=groupTemp..i

--> Optionnel : Ne rien faire si le groupe existe déjà.(ne fonctionne pas pour les unités au sol)
--if Group.getByName(group.."#001") == nil then --(ne oublier d'activer le 'end' à la fin)

--> Optionnel : % probabilité de spawn
local probability = 100
if math.random(0,100) <= probability then --(ne oublier d'activer le 'end' à la fin)

--> Instance Spawn normale, peut écraser l'unité précédente
local sp=SPAWN:New(group)

--> Instance Spawn alternative, n'écrase pas
--local sp=SPAWN:NewWithAlias(group,group.."-"..math.random(100,999))

--> Optionnel : Pour les Awacs et Tankers (ID,Name,Minor,Major)
--sp:InitCallSign(1, "Texaco", 5, 1)

--> InitLimit (Nb d'unité dans groupe * nb de groupe à spawn, max total)
sp:InitLimit( 1, 0 )

--> Optionnel : Aleatoire dans la position (activé, rayon ext. m, rayon int. m)
--sp:InitRandomizePosition( true, 25, 5 )

--> Optionnel : Aleatoire dans WP (premier WP, dernier WP, rayon max)
--sp:InitRandomizeRoute(0, 0, 50000) 

--> Optionnel : Spawn random par zones
--[[
sp:InitRandomizeZones( { 
    ZONE:New( "ttgt -1" ),
    ZONE:New( "ttgt -2" ),
})--]]

--> Optionnel : Message
--[[ --- pour activer message au spawn, -- pour désactiver
sp:OnSpawnGroup(function(MSG) MSG=MESSAGE:New(
"PC | Nouveau contact",
10,false):ToAll() end)--]]

--> Methodes de Spawn :
--> soit Spawn une seule fois
--sp:Spawn()

--> ou Spawn une fois, départ d'une base (base, type de départ)
--sp:SpawnAtAirbase( AIRBASE:FindByName( AIRBASE.Caucasus.Krymsk ), SPAWN.Takeoff.Hot )

--> ou Spawn & re-Spawn :
--> Activer délai dès le début
--sp:InitDelayOn()
--> Re-spawn time (temps sec, % variation)
sp:SpawnScheduled( 120, .3 )
    
end --(if probability)
--end --(if Group.getByName)
--end --(boucle for)
