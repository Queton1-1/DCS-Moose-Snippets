# DCS-Moose-Snippets

Quelques morceaux de code ("Snippet") à ajuster et intégrer dans vos partie à partir de l'éditeur.  
Requiert l'intégration de la librairie Moose  

Moose  
--  
Pour intégrer Moose à votre mission,  
* Téléchargez Moose : [Lien vers Moose](https://github.com/FlightControl-Master/MOOSE/releases)  
* Dans l'éditeur de mission de DCS,  
  * créez un **_déclencheur_** de type ``une fois`` avec le nom de votre choix,  
  * ajoutez une **_condition_** ``tps sup à : 1s``,   
  * puis ajoutez une **_action_** ``charger script`` avec le script **Moose**.  

RAT  
--  
**MooseRAT.lua** : fonctionnalité Random Air Traffic  

SPAWN  
--  
**MooseSpawn_1.08a.lua** : spawn d'unité  

OPS CHIEF  
--  
**Moose_OpsChief.lua** : fonctionnalité Chief/Auftrag  

CTLD  
--  
**MooseCTLD** : CTLD basé sur Moose  
  -> A charger dans l'éditeur après le chargement de Moose, ne pas oublier de charger les sons ``beacon.ogg`` et ``beaconsilent.ogg``   
  ``MooseCTLD_blue_v1.xx.lua`` : CTLD pour la coalition bleu  
  ``MooseCTLD_red_v1.xx.lua`` : CTLD pour la coalition rouge  
  ``MooseCTLD_saver_v1.xx.lua`` : pour savegarder vos unités déposées.  
  ``template_CTLD_v1.xx.zip`` : modèles d'unités CTLD à placer dans ``Saved Game\DCS\StaticTemplate`` et à appeler dans l'éditeur de mission.  
  
o7  

Quéton 1-1 | [YouTube](https://www.youtube.com/channel/UCkYOYKrKMwCV-3yASP9gf8Q) | [Twitch](https://www.twitch.tv/queton11) | [DCS UserFiles](https://www.digitalcombatsimulator.com/fr/files/filter/user-is-TheJGi/apply/) | [GitHub](https://github.com/Queton1-1)
