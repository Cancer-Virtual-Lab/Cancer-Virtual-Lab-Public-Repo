// =============================================================================
// CVLECOGStatus.fsh
// Profilo della valutazione ECOG (Eastern Cooperative Oncology Group)
// performance status del Cancer Virtual Lab dell'IRCCS IRST.
// =============================================================================

Profile: CVLECOGStatus
Parent: Observation
Id: cvl-ecog-status
Title: "CVL ECOG Status"
Description: """
Profilo Observation del Cancer Virtual Lab dell'IRCCS IRST "Dino Amadori"
per la registrazione della valutazione ECOG (Eastern Cooperative Oncology
Group) performance status di un paziente oncologico. La valutazione ECOG
è una scala clinica standard per misurare lo stato funzionale del paziente
su una scala da 0 (piena attività) a 5 (deceduto), utilizzata come indicatore
prognostico e per la stratificazione delle decisioni terapeutiche. Nel CVL
la valutazione è codificata secondo il vocabolario SNOMED CT.
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
// Dai sample tutte le valutazioni hanno status = "registered".
// Non imponiamo fixed value per non escludere altri stati legittimi
// (final, amended, corrected, ecc.) che potrebbero comparire in futuro.

* status 1..1 MS
* status ^short = "Stato della valutazione"

// -----------------------------------------------------------------------------
// Category (con slicing su due categorie parallele)
// -----------------------------------------------------------------------------
// Dai sample tutte le valutazioni hanno DUE elementi in category, con
// un pattern di discriminazione a due livelli:
//   - Slice "surveyCategory": codice HL7 standard "survey" per la classe
//     generica di Observation di tipo questionario/valutazione
//   - Slice "ecogCategory": codice SNOMED CT 423740007 "ECOG performance
//     status" per identificare specificamente la scala ECOG
// Il doppio livello permette di identificare univocamente il tipo di
// Observation con un pattern che potrà essere applicato in modo analogo
// ai futuri profili Observation del CVL.

* category 2..* MS
* category ^slicing.discriminator.type = #value
* category ^slicing.discriminator.path = "coding.system"
* category ^slicing.rules = #open
* category contains
    surveyCategory 1..1 MS and
    ecogCategory 1..1 MS

* category[surveyCategory] ^short = "Categoria generica HL7 (survey)"
* category[surveyCategory].coding 1..1 MS
* category[surveyCategory].coding.system 1..1 MS
* category[surveyCategory].coding.system = "http://terminology.hl7.org/CodeSystem/observation-category" (exactly)
* category[surveyCategory].coding.code 1..1 MS

* category[ecogCategory] ^short = "Categoria specifica ECOG (SNOMED CT)"
* category[ecogCategory].coding 1..1 MS
* category[ecogCategory].coding.system 1..1 MS
* category[ecogCategory].coding.system = "http://snomed.info/sct" (exactly)
* category[ecogCategory].coding.code 1..1 MS

// -----------------------------------------------------------------------------
// Code (grado ECOG con binding required al ValueSet)
// -----------------------------------------------------------------------------
// Il codice della valutazione identifica il grado ECOG (0-5) secondo la
// codifica SNOMED CT. Vincoliamo il campo tramite binding required al
// ValueSet CVLECOGValueSet che dichiara i sei codici ammessi.

* code 1..1 MS
* code ^short = "Grado ECOG (0-5) secondo codifica SNOMED CT"
* code.coding 1..* MS
* code.coding.system 1..1 MS
* code.coding.system = "http://snomed.info/sct" (exactly)
* code.coding.code 1..1 MS
* code.coding.display MS
* code from CVLECOGValueSet (required)

// -----------------------------------------------------------------------------
// Subject
// -----------------------------------------------------------------------------
// Riferimento obbligatorio al paziente CVL. Applichiamo il pattern
// architetturale sistematico dell'IG.

* subject 1..1 MS
* subject only Reference(CVLPatient)
* subject ^short = "Riferimento al paziente CVL valutato"

// -----------------------------------------------------------------------------
// Effective (data della valutazione)
// -----------------------------------------------------------------------------
// Data della valutazione ECOG (perturbata per pseudo-anonimizzazione).
// Il campo effective[x] di Observation ammette diversi tipi. Nel CVL
// osserviamo solo dateTime, quindi restringiamo il tipo.

* effective[x] 1..1 MS
* effective[x] only dateTime
* effectiveDateTime ^short = "Data della valutazione (perturbata)"

// -----------------------------------------------------------------------------
// Campi NON vincolati esplicitamente
// -----------------------------------------------------------------------------
// I seguenti campi dello standard FHIR Observation non vengono vincolati
// perché non emergono dalle fonti verificate:
//   - identifier
//   - basedOn
//   - partOf
//   - focus
//   - encounter
//   - issued
//   - performer
//   - value[x]
//   - dataAbsentReason
//   - interpretation
//   - note
//   - bodySite
//   - method
//   - specimen
//   - device
//   - referenceRange
//   - hasMember
//   - derivedFrom
//   - component
//
// Nota specifica su "value[x]": nei sample il grado ECOG è espresso
// interamente nel campo code (via SNOMED CT), non replicato come valore
// numerico in value[x]. Il campo resta opzionale secondo lo standard.
