// =============================================================================
// CVLBodyMeasurement.fsh
// Profilo delle misurazioni antropometriche (peso e altezza) del Cancer
// Virtual Lab dell'IRCCS IRST "Dino Amadori".
// =============================================================================

Profile: CVLBodyMeasurement
Parent: Observation
Id: cvl-body-measurement
Title: "CVL Body Measurement"
Description: """
Profilo Observation del Cancer Virtual Lab dell'IRCCS IRST "Dino Amadori"
per la registrazione delle misurazioni antropometriche di un paziente
oncologico. Il profilo modella peso e altezza come due component all'interno
di una singola Observation, riflettendo la loro rilevazione contestuale
durante la stessa visita clinica. I codici sono SNOMED CT per l'identificazione
delle misurazioni e UCUM per le unità di misura.
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
// Dai sample tutte le misurazioni hanno status = "registered".

* status 1..1 MS
* status ^short = "Stato della misurazione"

// -----------------------------------------------------------------------------
// Category (vital signs)
// -----------------------------------------------------------------------------
// Dai sample tutte le misurazioni hanno una singola category con codice
// "vital-signs" dal CodeSystem HL7 standard observation-category, coerentemente
// con la prassi FHIR di classificare peso e altezza come parametri vitali.

* category 1..1 MS
* category ^short = "Categoria: vital-signs (parametri vitali)"
* category.coding 1..1 MS
* category.coding.system 1..1 MS
* category.coding.system = "http://terminology.hl7.org/CodeSystem/observation-category" (exactly)
* category.coding.code 1..1 MS
* category.coding.code = #vital-signs (exactly)

// -----------------------------------------------------------------------------
// Code (Body measure SNOMED CT)
// -----------------------------------------------------------------------------
// Il code identifica il tipo generale di Observation come misurazione
// corporea, con il codice SNOMED CT 248326004 "Body measure".
// Le misurazioni specifiche (peso, altezza) sono espresse nei component.

* code 1..1 MS
* code ^short = "Codice SNOMED CT per la misurazione corporea generica"
* code.coding 1..1 MS
* code.coding.system 1..1 MS
* code.coding.system = "http://snomed.info/sct" (exactly)
* code.coding.code 1..1 MS

// -----------------------------------------------------------------------------
// Subject
// -----------------------------------------------------------------------------
// Applicazione del pattern architetturale sistematico dell'IG.

* subject 1..1 MS
* subject only Reference(CVLPatient)
* subject ^short = "Riferimento al paziente CVL"

// -----------------------------------------------------------------------------
// Effective (data della misurazione)
// -----------------------------------------------------------------------------

* effective[x] 1..1 MS
* effective[x] only dateTime
* effectiveDateTime ^short = "Data della misurazione (perturbata)"

// -----------------------------------------------------------------------------
// Component (peso e altezza tramite slicing)
// -----------------------------------------------------------------------------
// Dai sample ogni misurazione contiene esattamente 2 component:
//   - Slice "weight": codice SNOMED CT 363808001 "Body weight", valore in kg
//   - Slice "height": codice SNOMED CT 50373000 "Body height", valore in cm
// Il pattern di slicing consente di identificare univocamente ciascun
// component per il proprio codice SNOMED CT, garantendo che ogni misurazione
// contenga sia peso sia altezza.

* component 2..* MS
* component ^slicing.discriminator.type = #value
* component ^slicing.discriminator.path = "code.coding.code"
* component ^slicing.rules = #open
* component contains
    weight 1..1 MS and
    height 1..1 MS

// -- Component peso --
* component[weight] ^short = "Peso corporeo in kg"
* component[weight].code 1..1 MS
* component[weight].code.coding 1..1 MS
* component[weight].code.coding.system 1..1 MS
* component[weight].code.coding.system = "http://snomed.info/sct" (exactly)
* component[weight].code.coding.code 1..1 MS
* component[weight].code.coding.code = #363808001 (exactly)
* component[weight].value[x] 1..1 MS
* component[weight].value[x] only Quantity
* component[weight].valueQuantity.value 1..1 MS
* component[weight].valueQuantity.unit 1..1 MS
* component[weight].valueQuantity.system 1..1 MS
* component[weight].valueQuantity.system = "http://unitsofmeasure.org" (exactly)
* component[weight].valueQuantity.code 1..1 MS
* component[weight].valueQuantity.code = #kg (exactly)

// -- Component altezza --
* component[height] ^short = "Altezza corporea in cm"
* component[height].code 1..1 MS
* component[height].code.coding 1..1 MS
* component[height].code.coding.system 1..1 MS
* component[height].code.coding.system = "http://snomed.info/sct" (exactly)
* component[height].code.coding.code 1..1 MS
* component[height].code.coding.code = #50373000 (exactly)
* component[height].value[x] 1..1 MS
* component[height].value[x] only Quantity
* component[height].valueQuantity.value 1..1 MS
* component[height].valueQuantity.unit 1..1 MS
* component[height].valueQuantity.system 1..1 MS
* component[height].valueQuantity.system = "http://unitsofmeasure.org" (exactly)
* component[height].valueQuantity.code 1..1 MS
* component[height].valueQuantity.code = #cm (exactly)

// -----------------------------------------------------------------------------
// Campi NON vincolati esplicitamente
// -----------------------------------------------------------------------------
// I seguenti campi dello standard FHIR Observation non vengono vincolati
// perché non emergono dalle fonti verificate:
//   - identifier, basedOn, partOf, focus, encounter, issued, performer,
//     value[x] (a livello Observation), dataAbsentReason, interpretation,
//     note, bodySite, method, specimen, device, referenceRange, hasMember,
//     derivedFrom
