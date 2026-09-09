// =============================================================================
// CVLAdministration.fsh
// Profilo della somministrazione farmacologica oncologica del Cancer
// Virtual Lab dell'IRCCS IRST.
//
// NOTA IMPORTANTE - Anomalie rilevate nell'implementazione attuale:
// L'analisi dei sample della pipeline ha evidenziato quattro discrepanze
// rispetto allo standard FHIR R4:
//   1. Il campo temporale è denominato "occurenceDateTime" (con typo)
//      anziché "effectiveDateTime" come previsto dallo standard R4.
//   2. Il campo "medication" utilizza una struttura CodeableReference
//      introdotta in FHIR R5, mentre lo standard R4 prevede il campo
//      polimorfico medication[x] (medicationReference o
//      medicationCodeableConcept).
//   3. Viene utilizzato il campo "basedOn" per collegare la somministrazione
//      al CarePlan, ma nello standard FHIR R4 questo campo non esiste per
//      MedicationAdministration (è stato introdotto in R5).
//   4. Il campo "subject" (paziente destinatario), obbligatorio nello
//      standard R4, è assente nei payload attuali del CVL.
// Questo profilo aderisce integralmente allo standard FHIR R4. Le extension
// CVLOccurrenceDateTimeExtension e CVLMedicationCodeableReferenceExtension
// documentano formalmente le prime due anomalie e consentono la loro
// rappresentazione machine-readable in attesa dell'allineamento della
// pipeline allo standard. Le anomalie 3 e 4, per la loro natura più
// invasiva, sono trattate come discrepanze da correggere alla fonte.
// =============================================================================

Profile: CVLAdministration
Parent: MedicationAdministration
Id: cvl-administration
Title: "CVL Administration"
Description: """
Profilo MedicationAdministration del Cancer Virtual Lab dell'IRCCS IRST
"Dino Amadori". Rappresenta una singola somministrazione farmacologica
associata a un piano terapeutico oncologico del CVL. Il farmaco somministrato
è riferito tramite una risorsa Medication codificata in ATC. Il profilo
aderisce integralmente allo standard FHIR R4; due extension dedicate
consentono di documentare formalmente le convenzioni non standard adottate
dalla pipeline attuale.
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
// Dai sample tutte le somministrazioni hanno status = "completed".
// Non imponiamo fixed value per non escludere altri stati legittimi
// (in-progress, on-hold, stopped, ecc.) che potrebbero comparire in futuro.

* status 1..1 MS
* status ^short = "Stato della somministrazione"

// -----------------------------------------------------------------------------
// Subject
// -----------------------------------------------------------------------------
// Il paziente destinatario della somministrazione. Il campo è obbligatorio
// nello standard R4. Applichiamo il pattern architetturale sistematico
// dell'IG: vincolo di tipo al profilo CVLPatient per garantire l'integrità
// del modello dati.

* subject 1..1 MS
* subject only Reference(CVLPatient)
* subject ^short = "Riferimento al paziente CVL destinatario della somministrazione"

// -----------------------------------------------------------------------------
// Medication
// -----------------------------------------------------------------------------
// Riferimento al farmaco somministrato, codificato in ATC nella risorsa
// Medication referenziata. Il profilo adotta la struttura standard R4
// medicationReference.

* medication[x] 1..1 MS
* medication[x] only Reference(Medication)
* medicationReference ^short = "Riferimento alla risorsa Medication (codice ATC)"

// -----------------------------------------------------------------------------
// Effective (data della somministrazione)
// -----------------------------------------------------------------------------
// Il profilo adotta la denominazione standard R4 "effectiveDateTime".
// La data è perturbata per pseudo-anonimizzazione.

* effective[x] 1..1 MS
* effective[x] only dateTime
* effectiveDateTime ^short = "Data della somministrazione (perturbata)"

// -----------------------------------------------------------------------------
// PartOf (collegamento al piano terapeutico)
// -----------------------------------------------------------------------------
// Nello standard FHIR R4, MedicationAdministration.partOf accetta riferimenti
// a MedicationAdministration o Procedure, ma non a CarePlan direttamente.
// Il collegamento formale al CarePlan del CVL non è quindi esprimibile
// direttamente come vincolo del profilo. Nella pipeline attuale il
// collegamento avviene tramite basedOn (comportamento R5), rappresentando
// una delle anomalie documentate.

* partOf MS
* partOf ^short = "Riferimento a procedure o somministrazioni di cui questa è parte"

// -----------------------------------------------------------------------------
// Campi NON vincolati esplicitamente
// -----------------------------------------------------------------------------
// I seguenti campi dello standard FHIR MedicationAdministration non vengono
// vincolati perché non emergono dalle fonti verificate:
//   - identifier
//   - instantiates
//   - statusReason
//   - category
//   - context
//   - supportingInformation
//   - performer
//   - reasonCode, reasonReference
//   - request
//   - device
//   - note
//   - dosage
//   - eventHistory
//
// Nota specifica su "dosage": l'assenza di informazioni sulla dose e sulle
// modalità di somministrazione è una scelta implementativa consapevole della
// pipeline CVL. Il profilo mantiene la cardinalità opzionale dello standard.
