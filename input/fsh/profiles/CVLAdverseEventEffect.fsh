// =============================================================================
// CVLAdverseEventEffect.fsh
// Profilo della Condition che rappresenta l'effetto clinico di un evento
// avverso del Cancer Virtual Lab dell'IRCCS IRST "Dino Amadori".
//
// Le Condition di questo profilo sono referenziate dagli AdverseEvent
// (CVLAdverseEvent) attraverso il campo resultingEffect (R5) o
// resultingCondition (R4), rappresentando la manifestazione clinica
// dell'evento avverso (per esempio, la fatigue causata da una
// somministrazione chemioterapica).
//
// NOTA IMPORTANTE - Anomalia rilevata nell'implementazione attuale:
// L'analisi dei sample ha evidenziato una anomalia strutturale rispetto
// allo standard FHIR R4:
//   1. Campo "subject" obbligatorio (1..1 in R4) omesso nei sample.
//      Il paziente è derivabile solo indirettamente dall'id della
//      Condition (es. "7152380_Fatigue_1" contiene l'id paziente 7152380).
//      Questa anomalia si somma alle 13 già documentate nei profili
//      precedenti, portando il totale a 14.
// =============================================================================

Profile: CVLAdverseEventEffect
Parent: Condition
Id: cvl-adverse-event-effect
Title: "CVL Adverse Event Effect"
Description: """
Profilo Condition del Cancer Virtual Lab dell'IRCCS IRST "Dino Amadori"
per la registrazione degli effetti clinici manifestati come conseguenza
degli eventi avversi da trattamento oncologico. Le Condition di questo
profilo sono referenziate dagli AdverseEvent (CVLAdverseEvent) attraverso
il meccanismo resultingEffect, rappresentando la manifestazione clinica
concreta dell'evento avverso registrato in farmacovigilanza. Codifica in
MedDRA per il tipo di effetto, con severity espressa secondo la scala
CTCAE (grade 1-5).
"""

// -----------------------------------------------------------------------------
// Metadati del profilo
// -----------------------------------------------------------------------------

* ^status = #draft
* ^experimental = true
* ^publisher = "IRCCS IRST 'Dino Amadori'"

// -----------------------------------------------------------------------------
// Clinical Status
// -----------------------------------------------------------------------------
// Dai sample tutte le Condition hanno clinicalStatus = "active", coerente
// con il fatto che gli effetti avversi vengono registrati durante la
// manifestazione clinica.

* clinicalStatus 1..1 MS
* clinicalStatus ^short = "Stato clinico della Condition (active nei sample)"
* clinicalStatus.coding 1..1 MS
* clinicalStatus.coding.system 1..1 MS
* clinicalStatus.coding.system = "http://terminology.hl7.org/CodeSystem/condition-clinical" (exactly)
* clinicalStatus.coding.code 1..1 MS
* clinicalStatus.coding.code = #active (exactly)

// -----------------------------------------------------------------------------
// Verification Status
// -----------------------------------------------------------------------------
// Dai sample tutte le Condition hanno verificationStatus = "confirmed".

* verificationStatus 1..1 MS
* verificationStatus ^short = "Stato di verifica (confirmed nei sample)"
* verificationStatus.coding 1..1 MS
* verificationStatus.coding.system 1..1 MS
* verificationStatus.coding.system = "http://terminology.hl7.org/CodeSystem/condition-ver-status" (exactly)
* verificationStatus.coding.code 1..1 MS
* verificationStatus.coding.code = #confirmed (exactly)

// -----------------------------------------------------------------------------
// Category (problem-list-item)
// -----------------------------------------------------------------------------
// Dai sample tutte le Condition hanno category = "problem-list-item".
// Questa è la distinzione strutturale principale rispetto a CVLDiagnosis,
// che utilizza "encounter-diagnosis": problem-list-item indica un problema
// clinico attivo nella lista dei problemi del paziente, mentre
// encounter-diagnosis indica una diagnosi formulata in un episodio
// specifico di cura.

* category 1..1 MS
* category ^short = "Categoria: problem-list-item (problema attivo)"
* category.coding 1..1 MS
* category.coding.system 1..1 MS
* category.coding.system = "http://terminology.hl7.org/CodeSystem/condition-category" (exactly)
* category.coding.code 1..1 MS
* category.coding.code = #problem-list-item (exactly)

// -----------------------------------------------------------------------------
// Severity (grado CTCAE)
// -----------------------------------------------------------------------------
// Nei sample severity è codificata con system "http://meddra.org" e codici
// numerici da 1 a 5. I codici corrispondono ai grade della scala CTCAE
// (Common Terminology Criteria for Adverse Events), la scala standard
// internazionale per la classificazione della severità degli eventi
// avversi in oncologia. Il display è variabile con descrizioni specifiche
// per ciascun sintomo (es. "Mild fatigue over baseline" per fatigue grade 1).
//
// NOTA: la scelta di dichiarare CTCAE grade sotto il system MedDRA è
// tecnicamente imprecisa (CTCAE e MedDRA sono sistemi correlati ma distinti).
// Il profilo rispetta la scelta implementativa della pipeline senza forzare
// alternative.

* severity 1..1 MS
* severity ^short = "Grado di severità CTCAE (1-5) sotto system MedDRA"
* severity.coding 1..1 MS
* severity.coding.system 1..1 MS
* severity.coding.system = "http://meddra.org" (exactly)
* severity.coding.code 1..1 MS
* severity.coding.display MS

// -----------------------------------------------------------------------------
// Code (tipo di effetto in MedDRA)
// -----------------------------------------------------------------------------
// Dai sample tutti i codici del campo code sono in MedDRA con codici a
// 8 cifre (es. 10016256 per Fatigue, 10000081 per Pain, 10013963 per
// Dyspnea). MedDRA è il vocabolario standard internazionale per la
// codifica degli eventi avversi in farmacovigilanza regolatoria.

* code 1..1 MS
* code ^short = "Tipo di effetto avverso codificato in MedDRA"
* code.coding 1..1 MS
* code.coding.system 1..1 MS
* code.coding.system = "http://meddra.org" (exactly)
* code.coding.code 1..1 MS
* code.coding.display MS

// -----------------------------------------------------------------------------
// Subject (obbligatorio in R4 ma omesso nei sample - ANOMALIA n. 14)
// -----------------------------------------------------------------------------
// Nello standard FHIR R4, subject è obbligatorio (1..1). Applichiamo il
// pattern architetturale sistematico dell'IG: vincolo di tipo al profilo
// CVLPatient per garantire l'integrità del modello dati.
// Nei sample attuali il campo è OMESSO: questa costituisce
// un'anomalia strutturale documentata nel progetto.
// Il paziente è derivabile solo indirettamente dall'id della Condition
// (formato "{patient_id}_{effect_type}_{seq}").

* subject 1..1 MS
* subject only Reference(CVLPatient)
* subject ^short = "Riferimento al paziente CVL (omesso nei sample - anomalia)"

// -----------------------------------------------------------------------------
// Campi NON vincolati esplicitamente
// -----------------------------------------------------------------------------
// I seguenti campi dello standard FHIR Condition non vengono vincolati:
//   - identifier, encounter, onset[x], abatement[x], recordedDate,
//     recorder, asserter, stage, evidence, bodySite, note
//
// Nota specifica su "onset[x]": la data di insorgenza dell'effetto non
// è valorizzata nei sample. Questa è un'informazione clinicamente
// significativa (permetterebbe di correlare temporalmente l'effetto
// con la somministrazione) ma è opzionale nello standard R4 e non
// viene contabilizzata tra le anomalie.
