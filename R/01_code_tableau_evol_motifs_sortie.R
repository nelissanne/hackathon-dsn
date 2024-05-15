library(data.table)


## --- Avec DT, un joli tableau pour les motifs de rupture

donnees_flux_sortie = as.data.table(flux_sortie)
donnees_flux_sortie[, motif_sortie := as.character(motif_sortie)]

evol_motif <- donnees_flux_sortie[,.(.N),by=.(id_etab, motif_sortie, last_month=fifelse(mois == max(mois), TRUE,FALSE))]
evol_motif <- merge(
  CJ(id_etab = unique(evol_motif$id_etab), motif_sortie = unique(evol_motif$motif_sortie), last_month = c(TRUE,FALSE)),
  evol_motif, by =c('id_etab','motif_sortie','last_month'), all.x = TRUE)
evol_motif[is.na(N), N:=0]
evol_motif <- dcast(evol_motif, id_etab + motif_sortie ~ last_month, value.var = 'N')
evol_motif[, evol:=(`TRUE`-`FALSE`/5)]

test = donnees_flux_sortie[,.(.N),by=.(id_etab, motif_sortie)]
motifs[, unpadded_motif := substr(V1, 2, 3)]
tab_motif <- merge(donnees_flux_sortie[,.(.N),by=.(id_etab, motif_sortie)], motifs, by.x = "motif_sortie", by.y = 'unpadded_motif')
tab_motif <- merge(tab_motif, evol_motif[,.(id_etab, motif_sortie,last_month = `TRUE`, evol)], by = c('id_etab','motif_sortie'))

