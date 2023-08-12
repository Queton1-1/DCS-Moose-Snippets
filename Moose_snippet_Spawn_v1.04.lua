--[[ -= Moose Spawn =-

    Snippet by JGi | Quéton 1-1

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

--%%%%% VERSION COMMENTE %%%%%
group="groupe_modele"
--> Nom du groupe modele, a ne saisir qu'ici

--> Mode Iterable - Si plusieurs groupes identiques (-1 -2 -3 etc..) à spawner
-- firstGroupNumber = 1
-- lastGroupNumber  = 4
-- groupTemp = group
-- for i = firstGroupNumber , lastGroupNumber  do
-- group=groupTemp..i

--> probabilité de % spawn
proba = 100
if math.random(0,100) <= proba then

--> Spawn normal :New ou :NewWithAlias si commande par menu radio
Sp1 =SPAWN:New(group)
--Sp1 = SPAWN:NewWithAlias(group,group.."-"..math.random(100,999))

--> InitLimit(Nb d'unité dans groupe * nb de groupe à spawn, max total)
Sp1 :InitLimit( 1, 0 )

--> activé?, rayon ext. m, rayon int. m
--Sp1 :InitRandomizePosition( true, 25, 5 )

--> premier WP, dernier WP, rayon max
--Sp1 :InitRandomizeRoute(0,0,50000) 

--> Spawn random par zones
--Sp1 :InitRandomizeZones( { ZONE:New( "spz1" ),ZONE:New( "spz2" ) } )

--> Message au Spawn
--[[ --- pour activer message au spawn, -- pour désactiver
Sp1 :OnSpawnGroup(function(MSG) MSG=MESSAGE:New(
"HQ : Nouveau contact",
10,false):ToAll() end)--]]

--> Si Spawn une seule fois
--Sp1 :Spawn()

--> Si Spawn & re-Spawn
--> Activer délai dès le début
--Sp1 :InitDelayOn()
--> Re-spawn time : temps sec, % variation
Sp1 :SpawnScheduled( 120, .3 )
end
--> Activer le 2nd end si iterable activé
end



--%%%%% VERSION LIGHT %%%%
group="TTGT -1"
-- firstGroupNumber = 1
-- lastGroupNumber  = 4
-- groupTemp = group
-- for i = firstGroupNumber , lastGroupNumber  do
-- group=groupTemp..i
proba = 100
if math.random(0,100) <= proba then
Sp1 = SPAWN:New(group)
Sp1 :InitLimit( 7, 0 )
--Sp1 :InitRandomizePosition( true, 25, 5 )
--Sp1 :InitRandomizeRoute(0,0,50000) 
--Sp1 :InitRandomizeZones( { ZONE:New( "spz1" ),ZONE:New( "spz2" ) } )
--[[ --- pour activer message au spawn, -- pour désactiver
Sp1 :OnSpawnGroup(function(MSG) MSG=MESSAGE:New(
"HQ : SA-10 Actif sur Sochi",
3,false):ToAll() end)--]]
--Sp1 :Spawn()
--Sp1 :InitDelayOn()
Sp1 :SpawnScheduled( 120, .2 )
-- end
end