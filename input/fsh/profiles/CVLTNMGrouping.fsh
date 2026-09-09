// =============================================================================
// CVLTNMGrouping.fsh
// Profilo delle valutazioni TNM aggregate del Cancer Virtual Lab.
//
// Il profilo rappresenta una Observation che aggrega le tre componenti
// T/N/M di una valutazione TNM completa in una delle sue due forme
// (Clinical TNM stage grouping o Pathologic TNM stage grouping).
// L'aggregazione avviene tramite il campo hasMember che referenzia
// tre risorse CVLTNMComponent.
//
// NOTA IMPORTANTE - Divergenza rispetto ai sample:
// Nei sample della pipeline le Observation di raggruppamento non hanno
// il campo code valorizzato. Lo standard FHIR R4 dichiara pero' code come
// obbligatorio (1..1) in Observation base, e i profili possono solo
// restringere le cardinalita', non ampliarle. Il profilo mantiene quindi
// code come obbligatorio in coerenza con lo standard.
// =============================================================================

Profile: CVLTNMGrouping
Parent: Observation
Id: cvl-tnm-grouping
Title: "CVL TNM Grouping"
Description: """
Profilo Observation del Cancer Virtual Lab dell'IRCCS IRST "Dino Amadori"
per la registrazione di una valutazione TNM completa aggregata. L'aggregazione
raccoglie le tre componenti T, N, M come Observation separate riferite tramite
il campo hasMember. La discriminazione tra la variante Clinical e Pathological
avviene attraverso il codice SNOMED CT dichiarato nel campo category.
"""

// -----------------------------------------------------------------------------
// Metadati del profilo
// -----------------------------------------------------------------------------

* ^status = #draft
* ^experimental = true
* ^publisher = "IRCCS IRST 'Dino Amadori'"

// -----------------------------------------------------------------------------
// Status
// -----------------------------------------------------------------------------

* status 1..1 MS
* status ^short = "Stato del raggruppamento"

// -----------------------------------------------------------------------------
// Code (obbligatorio per aderenza allo standard FHIR R4)
// -----------------------------------------------------------------------------
// Il campo code e' dichiarato obbligatorio nella risorsa Observation base
// di FHIR R4 (cardinalita' 1..1). Per convenzione, nelle Observation di
// aggregazione si utilizza come code lo stesso codice SNOMED CT che
// identifica il tipo di raggruppamento (es. 399588009 per pathological).

* code 1..1 MS
* code ^short = "Codice del tipo di raggruppamento (SNOMED CT)"
* code.coding 1..1 MS
* code.coding.system 1..1 MS
* code.coding.system = "http://snomed.info/sct" (exactly)
* code.coding.code 1..1 MS

// -----------------------------------------------------------------------------
// Category (discriminazione clinical/pathological)
// -----------------------------------------------------------------------------
// Dai sample ogni raggruppamento ha una category con codice SNOMED CT
// che identifica il tipo di stage grouping:
//   - 399537006 "Clinical TNM stage grouping"
//   - 399588009 "Pathologic TNM stage grouping"

* category 1..1 MS
* category ^short = "Tipo di raggruppamento (Clinical o Pathological)"
* category.coding 1..1 MS
* category.coding.system 1..1 MS
* category.coding.system = "http://snomed.info/sct" (exactly)
* category.coding.code 1..1 MS

// -----------------------------------------------------------------------------
// HasMember (aggregazione delle tre componenti)
// -----------------------------------------------------------------------------
// Nei sample tutti i raggruppamenti hanno esattamente 3 hasMember,
// corrispondenti alle tre componenti T, N, M della valutazione TNM.
// Vincoliamo il tipo del riferimento a CVLTNMComponent per garantire
// l'integrita' del modello dati.

* hasMember 3..3 MS
* hasMember only Reference(CVLTNMComponent)
* hasMember ^short = "Riferimento alle tre componenti T, N, M"

// -----------------------------------------------------------------------------
// Subject
// -----------------------------------------------------------------------------

* subject 1..1 MS
* subject only Reference(CVLPatient)
* subject ^short = "Riferimento al paziente CVL valutato"

// -----------------------------------------------------------------------------
// Campi NON vincolati esplicitamente
// -----------------------------------------------------------------------------
// Come per CVLTNMComponent, i restanti campi dello standard Observation
// non vengono vincolati per la regola di prudenza epistemica.
