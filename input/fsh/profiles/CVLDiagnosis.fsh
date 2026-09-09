// =============================================================================
// CVLDiagnosis.fsh
// Profilo della diagnosi oncologica del Cancer Virtual Lab dell'IRCCS IRST.
// =============================================================================

Profile: CVLDiagnosis
Parent: Condition
Id: cvl-diagnosis
Title: "CVL Diagnosis"
Description: """
Profilo Condition del Cancer Virtual Lab dell'IRCCS IRST "Dino Amadori".
Rappresenta una diagnosi oncologica confermata per un paziente arruolato
negli studi del CVL. La diagnosi è codificata in ICD-10 secondo la
classificazione dei siti tumorali. Può includere opzionalmente uno stadio
diagnostico codificato in SNOMED CT (sistema AJCC) e riferimenti a valutazioni
TNM cliniche e patologiche modellate come risorse Observation separate.
"""

// -----------------------------------------------------------------------------
// Metadati del profilo
// -----------------------------------------------------------------------------

* ^status = #draft
* ^experimental = true
* ^publisher = "IRCCS IRST 'Dino Amadori'"

// -----------------------------------------------------------------------------
// ClinicalStatus
// -----------------------------------------------------------------------------
// Dai sample tutte le diagnosi analizzate hanno clinicalStatus valorizzato
// con un codice dal CodeSystem HL7 standard "condition-clinical".
// Rendiamo il campo obbligatorio (1..1) e Must Support. Non imponiamo un
// fixed value perche' in futuro il CVL potrebbe registrare diagnosi con
// clinicalStatus diversi (es. "resolved" per remissione documentata).

* clinicalStatus 1..1 MS
* clinicalStatus ^short = "Stato clinico della diagnosi (codice HL7)"

// -----------------------------------------------------------------------------
// VerificationStatus
// -----------------------------------------------------------------------------
// Dai sample tutte le diagnosi hanno verificationStatus valorizzato con
// codice dal CodeSystem HL7 standard "condition-ver-status".
// Nel CVL osserviamo solo "confirmed" ma non imponiamo un fixed value
// per non escludere altri valori legittimi (es. "differential", "provisional").

* verificationStatus 1..1 MS
* verificationStatus ^short = "Stato di verifica della diagnosi (codice HL7)"

// -----------------------------------------------------------------------------
// Category
// -----------------------------------------------------------------------------
// Dai sample tutte le diagnosi hanno category valorizzata con
// "encounter-diagnosis" dal CodeSystem HL7 "condition-category".
// Cardinalita' 1..* (mantenuta dallo standard, che ammette piu' categorie).

* category 1..* MS
* category ^short = "Categoria della diagnosi (tipicamente encounter-diagnosis)"

// -----------------------------------------------------------------------------
// Code
// -----------------------------------------------------------------------------
// Il codice della diagnosi identifica il sito tumorale secondo la
// classificazione ICD-10 (system http://hl7.org/fhir/sid/icd-10),
// coerentemente con la Table 4 del paper Carbonaro et al. 2025.
// Rendiamo il campo obbligatorio e vincoliamo il sistema di codifica.

* code 1..1 MS
* code ^short = "Codice ICD-10 del sito tumorale"
* code.coding 1..* MS
* code.coding.system 1..1 MS
* code.coding.system = "http://hl7.org/fhir/sid/icd-10" (exactly)
* code.coding.code 1..1 MS
* code.coding.display MS

// -----------------------------------------------------------------------------
// Subject
// -----------------------------------------------------------------------------
// Riferimento obbligatorio al paziente CVL. Vincoliamo il tipo del
// riferimento al profilo CVLPatient definito in questa stessa IG, per
// garantire l'integrita' del modello dati del CVL.

* subject 1..1 MS
* subject only Reference(CVLPatient)
* subject ^short = "Riferimento al paziente CVL a cui la diagnosi appartiene"

// -----------------------------------------------------------------------------
// OnsetDateTime
// -----------------------------------------------------------------------------
// Data di insorgenza della diagnosi (perturbata per pseudo-anonimizzazione).
// Il campo onset[x] della risorsa Condition ammette diversi tipi
// (dateTime, Age, Period, Range, string). Nel CVL osserviamo solo
// dateTime, quindi restringiamo il tipo.

* onset[x] MS
* onset[x] only dateTime
* onsetDateTime ^short = "Data di insorgenza della diagnosi (perturbata)"

// -----------------------------------------------------------------------------
// Stage
// -----------------------------------------------------------------------------
// Dai sample, alcune diagnosi hanno il campo stage valorizzato.
// La cardinalita' e' quindi 0..*, coerente con lo standard FHIR ma con
// vincoli interni sui sotto-campi effettivamente osservati.
//
// La struttura del campo stage nei sample e':
//   - summary con codice SNOMED CT (sistema AJCC)
//   - assessment come reference a Observation (tipicamente valutazioni TNM)

* stage MS
* stage ^short = "Stadio diagnostico (opzionale, presente ~36% dei casi)"

* stage.summary MS
* stage.summary ^short = "Codice SNOMED CT dello stadio (sistema AJCC)"
* stage.summary.coding 1..* MS
* stage.summary.coding.system 1..1 MS
* stage.summary.coding.system = "http://snomed.info/sct" (exactly)
* stage.summary.coding.code 1..1 MS
* stage.summary.coding.display MS

* stage.assessment MS
* stage.assessment ^short = "Riferimento a Observation di valutazione TNM"
* stage.assessment only Reference(Observation)

// -----------------------------------------------------------------------------
// Campi NON vincolati esplicitamente
// -----------------------------------------------------------------------------
// I seguenti campi dello standard FHIR Condition non vengono vincolati
// perche' non emergono dalle fonti verificate:
//   - identifier
//   - severity
//   - bodySite
//   - encounter
//   - recordedDate
//   - recorder
//   - asserter
//   - note
//   - evidence
//   - stage.type
//
// Restano quindi con le cardinalita' e i binding standard di FHIR base.
