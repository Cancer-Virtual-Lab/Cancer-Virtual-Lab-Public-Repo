// =============================================================================
// CVLPhysiologicalHistory.fsh
// Profilo dell'anamnesi fisiologica del Cancer Virtual Lab dell'IRCCS IRST
// "Dino Amadori". Rappresenta le abitudini comportamentali del paziente
// oncologico rilevanti per il quadro clinico: abitudine al fumo e
// consumo di alcol.
// =============================================================================

Profile: CVLPhysiologicalHistory
Parent: Observation
Id: cvl-physiological-history
Title: "CVL Physiological History"
Description: """
Profilo Observation del Cancer Virtual Lab dell'IRCCS IRST "Dino Amadori"
per la registrazione dell'anamnesi fisiologica di un paziente oncologico.
Il profilo modella le abitudini comportamentali rilevanti per il quadro
clinico come due component all'interno di una singola Observation: lo stato
di fumatore e il consumo di alcol. Entrambi sono espressi come valori
booleani con codifica SNOMED CT. Le classi ontologiche cvl:SmokerPatient
e cvl:DrinkerPatient sono derivate dal reasoner del Knowledge Graph a
partire da queste osservazioni.
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
* status ^short = "Stato della registrazione anamnestica"

// -----------------------------------------------------------------------------
// Category (social-history)
// -----------------------------------------------------------------------------
// Dai sample tutte le anamnesi hanno una singola category con codice
// "social-history" dal CodeSystem HL7 standard observation-category,
// coerentemente con la prassi FHIR di classificare le abitudini
// comportamentali come anamnesi sociale.

* category 1..1 MS
* category ^short = "Categoria: social-history (anamnesi sociale)"
* category.coding 1..1 MS
* category.coding.system 1..1 MS
* category.coding.system = "http://terminology.hl7.org/CodeSystem/observation-category" (exactly)
* category.coding.code 1..1 MS
* category.coding.code = #social-history (exactly)

// -----------------------------------------------------------------------------
// Code (Health-related behavior finding SNOMED CT)
// -----------------------------------------------------------------------------
// Il code identifica il tipo generale di Observation come rilevazione di
// comportamenti correlati alla salute, con codice SNOMED CT 365949003
// "Health-related behavior finding". Le abitudini specifiche (fumo, alcol)
// sono espresse nei component.

* code 1..1 MS
* code ^short = "Codice SNOMED CT per rilevazione comportamenti salute"
* code.coding 1..1 MS
* code.coding.system 1..1 MS
* code.coding.system = "http://snomed.info/sct" (exactly)
* code.coding.code 1..1 MS
* code.coding.code = #365949003 (exactly)

// -----------------------------------------------------------------------------
// Subject
// -----------------------------------------------------------------------------

* subject 1..1 MS
* subject only Reference(CVLPatient)
* subject ^short = "Riferimento al paziente CVL"

// -----------------------------------------------------------------------------
// Campo effective NON presente
// -----------------------------------------------------------------------------
// Diversamente dagli altri profili Observation del CVL, l'anamnesi
// fisiologica non ha un campo effective valorizzato nei sample. La
// rilevazione delle abitudini è considerata stabile nel tempo per il
// paziente e non richiede tracciamento temporale specifico. Il campo
// effective[x] resta opzionale secondo lo standard FHIR base.

// -----------------------------------------------------------------------------
// Component (fumo e alcol tramite slicing)
// -----------------------------------------------------------------------------
// Dai sample ogni anamnesi contiene esattamente 2 component:
//   - Slice "smoker": codice SNOMED CT 77176002 "Smoker (finding)",
//     valore booleano che indica se il paziente è fumatore
//   - Slice "drinker": codice SNOMED CT 219006 "Current drinker of alcohol",
//     valore booleano che indica se il paziente consuma alcol
// Il pattern di slicing è analogo a CVLBodyMeasurement, ma utilizza
// valueBoolean invece di valueQuantity.

* component 2..* MS
* component ^slicing.discriminator.type = #value
* component ^slicing.discriminator.path = "code.coding.code"
* component ^slicing.rules = #open
* component contains
    smoker 1..1 MS and
    drinker 1..1 MS

// -- Component fumatore --
* component[smoker] ^short = "Abitudine al fumo (valore booleano)"
* component[smoker].code 1..1 MS
* component[smoker].code.coding 1..1 MS
* component[smoker].code.coding.system 1..1 MS
* component[smoker].code.coding.system = "http://snomed.info/sct" (exactly)
* component[smoker].code.coding.code 1..1 MS
* component[smoker].code.coding.code = #77176002 (exactly)
* component[smoker].value[x] 1..1 MS
* component[smoker].value[x] only boolean
* component[smoker].valueBoolean ^short = "true se il paziente è fumatore, false altrimenti"

// -- Component consumatore alcol --
* component[drinker] ^short = "Consumo di alcol (valore booleano)"
* component[drinker].code 1..1 MS
* component[drinker].code.coding 1..1 MS
* component[drinker].code.coding.system 1..1 MS
* component[drinker].code.coding.system = "http://snomed.info/sct" (exactly)
* component[drinker].code.coding.code 1..1 MS
* component[drinker].code.coding.code = #219006 (exactly)
* component[drinker].value[x] 1..1 MS
* component[drinker].value[x] only boolean
* component[drinker].valueBoolean ^short = "true se il paziente consuma alcol, false altrimenti"

// -----------------------------------------------------------------------------
// Campi NON vincolati esplicitamente
// -----------------------------------------------------------------------------
// I seguenti campi dello standard FHIR Observation non vengono vincolati
// perché non emergono dalle fonti verificate:
//   - identifier, basedOn, partOf, focus, encounter, effective[x], issued,
//     performer, value[x] (a livello Observation), dataAbsentReason,
//     interpretation, note, bodySite, method, specimen, device,
//     referenceRange, hasMember, derivedFrom
