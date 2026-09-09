// =============================================================================
// CVLLaboratoryTest.fsh
// Profilo degli esami di laboratorio del Cancer Virtual Lab dell'IRCCS IRST
// "Dino Amadori".
// =============================================================================

Profile: CVLLaboratoryTest
Parent: Observation
Id: cvl-laboratory-test
Title: "CVL Laboratory Test"
Description: """
Profilo Observation del Cancer Virtual Lab dell'IRCCS IRST "Dino Amadori"
per la registrazione degli esami di laboratorio dei pazienti oncologici.
Il profilo modella l'ampia gamma di esami che il CVL registra (emocromo,
formule leucocitarie, chimica clinica, marker sierici, ecc.) attraverso
una struttura generica basata sui campi standard di Observation con
particolare attenzione al campo referenceRange per gli intervalli di
riferimento clinici. Il vocabolario utilizzato è prevalentemente LOINC
(99% degli esami) integrato da SNOMED CT (1%).
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
* status ^short = "Stato della registrazione dell'esame"

// -----------------------------------------------------------------------------
// Category (laboratory)
// -----------------------------------------------------------------------------

* category 1..1 MS
* category ^short = "Categoria: laboratory (esami di laboratorio)"
* category.coding 1..1 MS
* category.coding.system 1..1 MS
* category.coding.system = "http://terminology.hl7.org/CodeSystem/observation-category" (exactly)
* category.coding.code 1..1 MS
* category.coding.code = #laboratory (exactly)

// -----------------------------------------------------------------------------
// Code (LOINC prevalente o SNOMED CT)
// -----------------------------------------------------------------------------
// Il code identifica il tipo di esame di laboratorio. Il vocabolario è
// eterogeneo: nei sample quasi tutti gli esami utilizzano
// LOINC, mentre i restanti utilizzano SNOMED CT. Il profilo non
// impone fixed value sul system per accomodare entrambe le codifiche.
//
// NOTA IMPORTANTE: i codici numerici LOINC osservati nei sample 
// sono a 7 cifre e NON corrispondono ai
// codici LOINC canonici (che sono a 5-6 cifre con checkdigit, es.
// 2951-2 per Sodio). Si tratta probabilmente di codici interni all'IRST
// registrati sotto il namespace LOINC. Il campo text del CodeableConcept
// contiene la descrizione italiana del test (es. "S/P-Acido urico",
// "Esame Emocromocitometrico", "Formula leucocitaria"), che è la reale
// fonte di identificazione clinica dell'esame.

* code 1..1 MS
* code ^short = "Tipo di esame (codifica LOINC prevalente o SNOMED CT)"
* code.coding 1..1 MS
* code.coding.system 1..1 MS
* code.coding.code 1..1 MS
* code.text 1..1 MS
* code.text ^short = "Descrizione italiana dell'esame (es. 'S/P-Acido urico')"

// -----------------------------------------------------------------------------
// Subject
// -----------------------------------------------------------------------------

* subject 1..1 MS
* subject only Reference(CVLPatient)
* subject ^short = "Riferimento al paziente CVL"

// -----------------------------------------------------------------------------
// Effective (data dell'esame)
// -----------------------------------------------------------------------------

* effective[x] 1..1 MS
* effective[x] only dateTime
* effectiveDateTime ^short = "Data dell'esame di laboratorio (perturbata)"

// -----------------------------------------------------------------------------
// Value (risultato dell'esame come stringa)
// -----------------------------------------------------------------------------
// Nei sample tutti gli esami utilizzano valueString per il risultato
// (es. "6.3" per Acido urico). La scelta della stringa consente
// rappresentazioni miste: valori numerici, valori qualitativi (positive,
// negative), valori con annotazioni (es. "<0.5", "trace"). L'unità di
// misura per i valori numerici non è dichiarata direttamente ma è
// desumibile dal referenceRange.

* value[x] 1..1 MS
* value[x] only string
* valueString ^short = "Risultato dell'esame (numerico o testuale)"

// -----------------------------------------------------------------------------
// Reference Range (intervallo di riferimento clinico)
// -----------------------------------------------------------------------------
// Dai sample tutti gli esami hanno un referenceRange valorizzato con i
// campi low e high, ciascuno con value e unit. L'unità di misura è
// espressa come stringa libera (es. "mg/dl") e non secondo il vocabolario
// UCUM. Questa è una scelta implementativa della pipeline; un allineamento
// futuro a UCUM è raccomandabile per interoperabilità.

* referenceRange 1..* MS
* referenceRange ^short = "Intervallo di riferimento clinico per l'interpretazione"
* referenceRange.low 1..1 MS
* referenceRange.low.value 1..1 MS
* referenceRange.low.unit 1..1 MS
* referenceRange.high 1..1 MS
* referenceRange.high.value 1..1 MS
* referenceRange.high.unit 1..1 MS

// -----------------------------------------------------------------------------
// Note (marker documentativo di pipeline)
// -----------------------------------------------------------------------------
// Come CVLBiomarker e CVLVariant, dai sample tutti gli esami contengono
// un campo note con testo "laboratory", utilizzato dalla pipeline per
// marcatura interna del tipo di Observation. Non vincolato formalmente.

// -----------------------------------------------------------------------------
// Campi NON vincolati esplicitamente
// -----------------------------------------------------------------------------
// I seguenti campi dello standard FHIR Observation non vengono vincolati:
//   - identifier, basedOn, partOf, focus, encounter, issued, performer,
//     dataAbsentReason, interpretation, bodySite, method, specimen, device,
//     component, hasMember, derivedFrom
