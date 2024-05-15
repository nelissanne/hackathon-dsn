### Description

* *Problématique et proposition de valeur.*
* *A quelle problématique s’attaque votre projet ?*

Les établissements médicalisés pour personnes âgées sont sujets à des difficultés de recrutement. Il n'est pas évident de suivre les tensions RH du secteur, à un niveau fin (établissement) comme au niveau départemental ou régional. Les outils existants sont les enquêtes faites tous les 4 ans par la DREES (enquêtes à destination de l'ensemble des établissements sur le personnel, l'offre de soin proposée), ainsi que les déclarations annuelles des établissements à la CNSA, concernant leurs effectifs prévisionnels.

* *Quelle est votre proposition de valeur ?*

Les données de la DSN permettraient de faire un suivi mensuel et automatisé des tensions RH rencontrées par chaque établissement.


### Solution

* *Description de la solution et de ses fonctionnalités*

Nous proposons de générer un tableau de bord permettant d'évaluer facilement la situation d'un établissement ou d'une zone géographique.
Il permettrait de faire un suivi des contrats en cours, par établissement et par profession.


* *Quel usage est fait des données ? Que vous permettent-elles de faire ?*

Plusieurs graphiques sont disponibles pour un établissement :
  - évolution des stocks (nombre de contrats en cours par mois), par profession et type de contrat
  - flux d'entrée/flux de sortie (nombre de contrats commencés/terminés sur un mois)
  - décompte des fins de contrats agrégés par motif de rupture et évolution mensuelle

* *Quelle est la méthode de création de la solution ?*

Tableau de bord développé en R, utilisant la librairie flexdashboard pour la génération du tableau de bord, et la librairie crosstalk pour gérer la réactivité (sélection de l'établissement ou de la zone géographique d'intérêt par exemple).

### Impact envisagé

* *Que permet de faire la solution ?*


* *Aller plus loin*
Dans un potentiel futur, pourraient être ajoutés :

- au niveau de l'établissement :    
    - taux de recours à des contrats courts 
    - nombre d'arrêts de travail / arrêts maladie travail 
    - ajout du nombre de lits ouverts par établissement : répertoire FINESS
        - difficultés de jointure : identifiant finess dans ce répertoire, contre siret dans la DSN
- au niveau du département / de la région :
    - offre de soin par PCS par département (indépendamment des établissements)


* *Qui sont les usagers visés, et qu’en feraient-ils ?*

Les usagers seraient les autorités de tarification et de contrôle (ARS, conseils départementaux). Ce tableau de bord leur permettraient notamment de repérer les établissements en difficulté et d'engager la discussion 

### Ressources

* *Lien vers la documentation du projet*

### [Facultatif] Retours sur la qualité des données exploitées

* *Quelles sont les difficultés que vous avez rencontrées dans l’usage des données ?*