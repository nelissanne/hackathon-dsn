
library(DBI)
library(RPostgres)
library(dbplyr)
library(dplyr)
library(ggplot2)
library(data.table)


conn <- DBI::dbConnect(drv = RPostgres::Postgres(),
                       host = "10.0.0.1",
                       port = "5432",
                       dbname = "dsn",
                       user = "",
                       password = "")

# Requête SQL pour filtrer les établissements de type 
# hébergement médicalisé pour personnes âgées (8710A)
# et faire la jointure des tables employeurs, employeur_assure et contrats

join_query = 
  "WITH 
  employeurs as (SELECT id, siret, et_code_apet, et_ad_code_postal
    FROM ddadtemployeur 
    WHERE et_code_apet='8710A'),
  employeurs_assures as (SELECT id, id_employeur, id_assure
    FROM ddadtemployeur_assure),
  contrats as (SELECT id, id_employeur_assure, pcs_ese, 
    date_debut_contrat, date_fin_contrat, nature_contrat
    FROM ddadtcontrat)

SELECT * FROM employeurs e INNER JOIN employeurs_assures ea
ON e.id = ea.id_employeur INNER JOIN contrats c
ON c.id_employeur_assure=ea.id
"

contrats_medic_pa_sql = dbGetQuery(conn, join_query)
#####

# On choisit le 3e mercredi de chaque mois comme jour mensuel de référence 
date_interet <- c("2022-12-21","2023-01-18","2023-02-15","2023-03-15","2023-04-19","2023-05-17")

donnees_stock <- NULL
contrats_medic_pa_sql = as.data.table(contrats_medic_pa_sql)

# Calcul du stock mensuel
# Pour chaque date, on liste les contrats pour lesquels la date en question est comprise entre le début et la fin du contrat
for(t in as.Date(date_interet)){
  temp <- contrats_medic_pa_sql[as.Date(date_debut_contrat)<= t & as.Date(date_fin_contrat)>=t,
                                .(id = uniqueN(id_assure),
                                  contrats = .N),by = c("id_employeur", "nature_contrat", "et_ad_code_postal", "pcs_ese")]
  donnees_stock <- rbind(temp[, date:= as.Date(t, origin="1970-01-01")],
                         donnees_stock)
}
fwrite(donnees_stock, "donnees_brutes_stock_ehpad_extract.csv")




date_deb <- seq(as.Date('2022-12-01'), as.Date('2023-05-01'), by= 'month')
date_fin <- seq(as.Date('2023-01-01'), as.Date('2023-06-01'), by= 'month') - 1

# Calcul du flux mensuel d'entrée

donnees_flux_entree <- NULL
for(i in 1:length(date_deb)){
  temp <- contrats_medic_pa_sql[as.Date(date_debut_contrat)>= date_deb[i] & as.Date(date_debut_contrat)<date_fin[i],
                        .(id_contrat = id,
                          id_etab = id_employeur,
                          type_contrat = nature_contrat,
                          pcs = pcs_ese,
                          dat_fin = date_fin_contrat)]
  donnees_flux_entree <- rbind(temp[, c('mois','dep'):= .(as.Date(date_deb[i]), "66")],
                               donnees_flux_entree)
}

fwrite(donnees_flux_entree, file = 'donnees_brutes_flux_entree_ehpad.csv')

# Calcul du flux mensuel de sortie

donnees_flux_sortie <- NULL
for(i in 1:length(date_deb)){
  temp <- contrats3etab[as.Date(date_fin_contrat)>= date_deb[i] & as.Date(date_fin_contrat)<date_fin[i],
                        .(id_contrat = id,
                          id_etab = id_employeur,
                          motif_sortie = motif_rupture,
                          pcs = pcs_ese)]
  donnees_flux_sortie <- rbind(temp[, c('mois','dep'):= .(as.Date(date_deb[i]), "66")],
                               donnees_flux_sortie)
}

fwrite(donnees_flux_sortie, file = 'donnees_brutes_flux_sortie_ehpad.csv')



# Première analyse sur les durées des contrats

contrats_medic_pa_sql = contrats_medic_pa_sql %>%
  mutate(duree_effective = 1+(date_fin_contrat-date_debut_contrat)/(24*3600))

ggplot(data=contrats_medic_pa_sql %>% filter(duree_effective<50), aes(x=duree_effective))+
  geom_histogram()
