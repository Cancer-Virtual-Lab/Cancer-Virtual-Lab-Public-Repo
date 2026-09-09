// =============================================================================
// CVLBiomarker.fsh
// Profilo del biomarker molecolare del Cancer Virtual Lab dell'IRCCS IRST
// "Dino Amadori".
// =============================================================================

Profile: CVLBiomarker
Parent: Observation
Id: cvl-biomarker
Title: "CVL Biomarker"
Description: """
Profilo Observation del Cancer Virtual Lab dell'IRCCS IRST "Dino Amadori"
per la registrazione dei biomarker molecolari e recettoriali di rilevanza
oncologica. Include marker recettoriali (Estrogen, Progesterone), marker
HER2, marker proliferativo Ki-67 e altri marker tumorali codificati in
LOINC. I biomarker sono utilizzati per la caratterizzazione molecolare
del tumore, per la stratificazione prognostica e per l'orientamento delle
scelte terapeutiche mirate.
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
* status ^short = "Stato della registrazione del biomarker"

// -----------------------------------------------------------------------------
// Category (laboratory)
// -----------------------------------------------------------------------------
// Dai sample tutti i biomarker hanno una singola category con codice
// "laboratory" dal CodeSystem HL7 standard observation-category,
// coerentemente con la prassi FHIR di classificare i biomarker molecolari
// come osservazioni di laboratorio.

* category 1..1 MS
* category ^short = "Categoria: laboratory (esami di laboratorio)"
* category.coding 1..1 MS
* category.coding.system 1..1 MS
* category.coding.system = "http://terminology.hl7.org/CodeSystem/observation-category" (exactly)
* category.coding.code 1..1 MS
* category.coding.code = #laboratory (exactly)

// -----------------------------------------------------------------------------
// Code (Genetic marker SNOMED CT)
// -----------------------------------------------------------------------------
// Il code identifica il tipo generale di Observation come biomarker con
// codice SNOMED CT 20889005 "Genetic marker, function". La terminologia
// "genetic" è utilizzata in senso estensivo dalla pipeline per includere
// anche marker non strettamente genetici (recettori, antigeni proteici,
// marker di proliferazione), coerentemente con la scelta implementativa
// della pipeline CVL. Il biomarker specifico è identificato nel component.

* code 1..1 MS
* code ^short = "Codice SNOMED CT per biomarker (usato in senso estensivo)"
* code.coding 1..1 MS
* code.coding.system 1..1 MS
* code.coding.system = "http://snomed.info/sct" (exactly)
* code.coding.code 1..1 MS
* code.coding.code = #20889005 (exactly)

// -----------------------------------------------------------------------------
// Subject
// -----------------------------------------------------------------------------

* subject 1..1 MS
* subject only Reference(CVLPatient)
* subject ^short = "Riferimento al paziente CVL"

// -----------------------------------------------------------------------------
// Effective (data della rilevazione)
// -----------------------------------------------------------------------------

* effective[x] 1..1 MS
* effective[x] only dateTime
* effectiveDateTime ^short = "Data della rilevazione del biomarker (perturbata)"

// -----------------------------------------------------------------------------
// Note (marker documentativo di pipeline)
// -----------------------------------------------------------------------------
// Dai sample tutti i biomarker contengono un campo note con testo "marker",
// probabilmente utilizzato dalla pipeline per marcatura interna del tipo
// di Observation. Il profilo non lo vincola formalmente per non irrigidire
// la struttura, ma lo documenta come pattern osservato.

// -----------------------------------------------------------------------------
// Component (biomarker specifico e valore)
// -----------------------------------------------------------------------------
// Dai sample ogni biomarker contiene esattamente 1 component. Il component
// rappresenta il biomarker specifico rilevato con codice LOINC (per esempio
// Progesterone receptor, Estrogen receptor, HER2, Ki-67).

* component 1..1 MS
* component ^short = "Biomarker specifico e valore rilevato"
* component.code 1..1 MS
* component.code.coding 1..1 MS
* component.code.coding.system 1..1 MS
* component.code.coding.system = "https://loinc.org" (exactly)
* component.code.coding.code 1..1 MS
* component.value[x] 1..1 MS
* component.value[x] only string
* component.valueString ^short = "Valore del biomarker (tipicamente percentuale o interpretazione testuale)"

// -----------------------------------------------------------------------------
// Nota metodologica sull'assenza di ValueSet per i biomarker
// -----------------------------------------------------------------------------
// A differenza di CVLResponse, il profilo non definisce un ValueSet per
// enumerare i codici LOINC dei biomarker. La scelta è motivata dalla
// esiguità dei sample analizzati (9 su 5.171 record complessivi, meno
// dello 0.2%): l'evidenza empirica è insufficiente per stabilire
// l'insieme completo dei biomarker che il CVL può registrare. Un
// vincolo required su un ValueSet limitato ai 5 codici osservati
// rischierebbe di respingere biomarker legittimi ma non ancora presenti
// nei sample. La regola di prudenza epistemica prevale.
//
// I cinque codici osservati nei sample sono documentati come riferimento:
//   - LOINC 85318-4: Progesterone receptor [Interpretation] in Tissue
//   - LOINC 16112-5: Estrogen receptor [Interpretation] in Tissue
//   - LOINC 48676-1: HER2 [Interpretation] in Tissue
//   - LOINC 85319-2: HER2 [Presence] in Breast cancer specimen
//   - LOINC 29593-1: Ki-67 nuclear Ag/100 cells in Tissue
//
// Un raffinamento futuro dell'IG, quando saranno disponibili sample più
// rappresentativi, potrà introdurre un CVLBiomarkerValueSet.

// -----------------------------------------------------------------------------
// Campi NON vincolati esplicitamente
// -----------------------------------------------------------------------------
// I seguenti campi dello standard FHIR Observation non vengono vincolati:
//   - identifier, basedOn, partOf, focus, encounter, issued, performer,
//     value[x] (a livello Observation), dataAbsentReason, interpretation,
//     bodySite, method, specimen, device, referenceRange, hasMember,
//     derivedFrom
