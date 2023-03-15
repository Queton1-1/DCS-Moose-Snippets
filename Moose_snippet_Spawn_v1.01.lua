--[[

    -= Moose Spawn =-

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



group="groupe_modele"
-- Nom du groupe modele, a ne saisir qu'ici

-- probabilité de % spawn
proba = 100

if math.random(0,100) <= proba then

-- Spawn normal ou en-dessous si commande par menu radio
Sp =SPAWN:New(group)
--Sp =SPAWN:NewWithAlias(group,group.."-"..math.random(100,999))

-- Nb dans le groupe X nb de spawn, max spawnable total
-- exemple : groupe de 3 unités, deux spawns & maximum 5 spawn du groupe >> :InitLimit(6,5)
:InitLimit( 1, 0 )

-- activé, rayon ext. m, rayon int. m
--:InitRandomizePosition( true, 25, 5 )

-- premier WP, dernier WP, rayon max
--:InitRandomizeRoute(0,0,50000) 

--[[ --- pour activer message au spawn, -- pour désactiver
:OnSpawnGroup(function(MSG)
MSG=MESSAGE:New(
"HQ : Nouveau contact",
10,false):ToAll()
end)
--]]

-- Spawn une seule fois
--:Spawn()

-- Spawn & re-Spawn
-- Activer délai dès le début
--:InitDelayOn()

-- Re-spawn time : temps sec, % variation
:SpawnScheduled( 30, .5 )

end
