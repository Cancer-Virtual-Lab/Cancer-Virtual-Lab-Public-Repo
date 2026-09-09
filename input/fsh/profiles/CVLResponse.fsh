// =============================================================================
// CVLResponse.fsh
// Profilo della valutazione della risposta al trattamento oncologico
// del Cancer Virtual Lab dell'IRCCS IRST "Dino Amadori".
// =============================================================================

Profile: CVLResponse
Parent: Observation
Id: cvl-response
Title: "CVL Response"
Description: """
Profilo Observation del Cancer Virtual Lab dell'IRCCS IRST "Dino Amadori"
per la registrazione della valutazione della risposta al trattamento
oncologico. La valutazione segue prevalentemente i criteri RECIST (Response
Evaluation Criteria in Solid Tumors) con cinque categorie codificate in
LOINC Answers (Complete Response, Partial Response, Stable Disease,
Progressive Disease, Not Assessed) integrate dal concetto clinico NED
(No Evidence of Disease) codificato in SNOMED CT per la classificazione
post-trattamento.
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
* status ^short = "Stato della registrazione della risposta"

// -----------------------------------------------------------------------------
// Category (therapy)
// -----------------------------------------------------------------------------
// Dai sample tutte le risposte hanno una singola category con codice
// "therapy" dal CodeSystem HL7 standard observation-category.

* category 1..1 MS
* category ^short = "Categoria: therapy (osservazione terapeutica)"
* category.coding 1..1 MS
* category.coding.system 1..1 MS
* category.coding.system = "http://terminology.hl7.org/CodeSystem/observation-category" (exactly)
* category.coding.code 1..1 MS
* category.coding.code = #therapy (exactly)

// -----------------------------------------------------------------------------
// Code (LOINC 88040-1)
// -----------------------------------------------------------------------------
// Il code identifica il tipo di osservazione come valutazione della risposta
// al trattamento oncologico, con codice LOINC 88040-1. LOINC è il vocabolario
// standard internazionale per le valutazioni cliniche strutturate.

* code 1..1 MS
* code ^short = "Codice LOINC per Response to cancer treatment"
* code.coding 1..1 MS
* code.coding.system 1..1 MS
* code.coding.system = "http://loinc.org" (exactly)
* code.coding.code 1..1 MS
* code.coding.code = #88040-1 (exactly)

// -----------------------------------------------------------------------------
// Subject
// -----------------------------------------------------------------------------

* subject 1..1 MS
* subject only Reference(CVLPatient)
* subject ^short = "Riferimento al paziente CVL valutato"

// -----------------------------------------------------------------------------
// Effective (data della valutazione)
// -----------------------------------------------------------------------------

* effective[x] 1..1 MS
* effective[x] only dateTime
* effectiveDateTime ^short = "Data della valutazione di risposta (perturbata)"

// -----------------------------------------------------------------------------
// Component (categoria di risposta)
// -----------------------------------------------------------------------------
// Dai sample ogni risposta contiene esattamente 1 component. Il component
// rappresenta la categoria di risposta valutata (CR, PR, SD, PD, NV, NED)
// con codice tratto da LOINC Answers o SNOMED CT (vedere CVLResponseValueSet).
// Il campo valueString duplica la categoria come acronimo testuale,
// tipicamente per interoperabilità con sistemi legacy.

* component 1..1 MS
* component ^short = "Categoria di risposta al trattamento"
* component.code 1..1 MS
* component.code.coding 1..1 MS
* component.code.coding.system 1..1 MS
* component.code.coding.code 1..1 MS
* component.code from CVLResponseValueSet (required)
* component.value[x] 1..1 MS
* component.value[x] only string
* component.valueString ^short = "Acronimo testuale della risposta (CR, PR, SD, PD, NV, NED)"

// -----------------------------------------------------------------------------
// Campi NON vincolati esplicitamente
// -----------------------------------------------------------------------------
// I seguenti campi dello standard FHIR Observation non vengono vincolati
// perché non emergono dalle fonti verificate:
//   - identifier, basedOn, partOf, focus, encounter, issued, performer,
//     value[x] (a livello Observation), dataAbsentReason, interpretation,
//     note, bodySite, method, specimen, device, referenceRange, hasMember,
//     derivedFrom
//
// Nota metodologica sul binding required: il binding a CVLResponseValueSet
// è dichiarato con strength "required", che impone al server di respingere
// qualsiasi risposta con codice non appartenente al ValueSet. Questa scelta
// rafforza l'integrità del vocabolario di risposta del CVL, evitando che
// codici non standard o codici errati entrino nel dataset.
