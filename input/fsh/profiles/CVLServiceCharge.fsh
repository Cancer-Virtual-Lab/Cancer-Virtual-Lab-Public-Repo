// =============================================================================
// CVLServiceCharge.fsh
// Profilo della prestazione clinica tariffata del Cancer Virtual Lab
// dell'IRCCS IRST "Dino Amadori". Utilizza la risorsa ChargeItem FHIR
// per rappresentare le prestazioni erogate ai pazienti oncologici
// nell'ambito del percorso di cura, con tariffazione in euro.

//
// NOTA IMPORTANTE - Divergenza rispetto allo standard FHIR R4:
// La pipeline utilizza il campo "unitPriceComponent" per la rappresentazione
// del prezzo unitario. In FHIR R4 questo campo NON esiste in ChargeItem:
// è stato introdotto solo in R5, dove ha struttura articolata comprendente
// amount (Money), factor (decimal) e type (code). Il campo R4 equivalente
// sarebbe priceOverride (Money diretto).
//
// Coerentemente con l'approccio adottato per CVLAdministration,
// dove le anomalie R5 sono state formalizzate attraverso Extension dedicate,
// il profilo CVLServiceCharge utilizza l'Extension CVLChargeItemUnitPriceExtension
// per rappresentare il pattern R5 in un profilo R4. Questa scelta preserva
// la fedeltà all'implementazione attuale della pipeline senza imporre
// migrazioni.
// =============================================================================

Profile: CVLServiceCharge
Parent: ChargeItem
Id: cvl-service-charge
Title: "CVL Service Charge"
Description: """
Profilo ChargeItem del Cancer Virtual Lab dell'IRCCS IRST "Dino Amadori"
per la rappresentazione delle prestazioni cliniche erogate ai pazienti
oncologici con relativa tariffazione. Copre l'intera gamma di prestazioni
del percorso di cura oncologico: esami di laboratorio, radiodiagnostica,
radioterapia, visite specialistiche oncologiche ed ematologiche,
consulenze cardiologiche, cure palliative e altre prestazioni accessorie.
Le prestazioni sono codificate in SNOMED CT e collegate al reparto
erogatore attraverso il pattern architetturale sistematico dell'IG.
Il prezzo unitario è modellato attraverso l'Extension
CVLChargeItemUnitPriceExtension che formalizza il pattern R5
unitPriceComponent presente nella pipeline.
"""

// -----------------------------------------------------------------------------
// Metadati del profilo
// -----------------------------------------------------------------------------

* ^status = #draft
* ^experimental = true
* ^publisher = "IRCCS IRST 'Dino Amadori'"

// -----------------------------------------------------------------------------
// Status (fixed value: billed)
// -----------------------------------------------------------------------------

* status 1..1 MS
* status ^short = "Stato: billed (prestazione fatturata)"
* status = #billed (exactly)

// -----------------------------------------------------------------------------
// Code (tipo di prestazione in SNOMED CT)
// -----------------------------------------------------------------------------

* code 1..1 MS
* code ^short = "Tipo di prestazione codificato in SNOMED CT"
* code.coding 1..1 MS
* code.coding.system 1..1 MS
* code.coding.system = "http://snomed.info/sct" (exactly)
* code.coding.code 1..1 MS
* code.coding.display MS

// -----------------------------------------------------------------------------
// Subject (paziente CVL)
// -----------------------------------------------------------------------------

* subject 1..1 MS
* subject only Reference(CVLPatient)
* subject ^short = "Riferimento al paziente CVL"

// -----------------------------------------------------------------------------
// Occurrence (data della prestazione)
// -----------------------------------------------------------------------------

* occurrence[x] 1..1 MS
* occurrence[x] only dateTime
* occurrenceDateTime ^short = "Data della prestazione (perturbata)"

// -----------------------------------------------------------------------------
// Performing Organization (reparto erogatore)
// -----------------------------------------------------------------------------

* performingOrganization 1..1 MS
* performingOrganization only Reference(CVLDepartment)
* performingOrganization ^short = "Reparto CVL erogatore della prestazione"

// -----------------------------------------------------------------------------
// Quantity (quantità della prestazione)
// -----------------------------------------------------------------------------

* quantity 1..1 MS
* quantity.value 1..1 MS
* quantity ^short = "Quantità della prestazione erogata"

// -----------------------------------------------------------------------------
// Extension per il prezzo unitario (pattern R5)
// -----------------------------------------------------------------------------
// Il prezzo unitario è rappresentato tramite l'Extension
// CVLChargeItemUnitPriceExtension che formalizza il pattern R5
// unitPriceComponent utilizzato dalla pipeline. Range osservato nei
// sample: 1.00 - 1.900,00 EUR.

* extension contains CVLChargeItemUnitPriceExtension named unitPriceComponent 1..1 MS
* extension[unitPriceComponent] ^short = "Prezzo unitario (pattern R5 tramite Extension)"

// -----------------------------------------------------------------------------
// Note (metadati contestuali di pipeline)
// -----------------------------------------------------------------------------
// Dai sample tutte le prestazioni contengono un campo note con testi
// strutturati (es. "T", "T1", "T10" ). Non vincolato formalmente.

// -----------------------------------------------------------------------------
// Campi NON vincolati esplicitamente
// -----------------------------------------------------------------------------
// I seguenti campi dello standard FHIR ChargeItem non vengono vincolati:
//   - identifier, definitionUri, definitionCanonical, partOf, context,
//     bodysite, factorOverride, priceOverride, overrideReason, enterer,
//     enteredDate, reason, service, product[x], account, supportingInformation
