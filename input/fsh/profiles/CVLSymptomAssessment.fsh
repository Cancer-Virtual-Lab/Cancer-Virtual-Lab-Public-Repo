// =============================================================================
// CVLSymptomAssessment.fsh
// Profilo della valutazione multidimensionale dei sintomi (scala ESAS)
// del Cancer Virtual Lab dell'IRCCS IRST "Dino Amadori".
// =============================================================================

Profile: CVLSymptomAssessment
Parent: Observation
Id: cvl-symptom-assessment
Title: "CVL Symptom Assessment (ESAS)"
Description: """
Profilo Observation del Cancer Virtual Lab dell'IRCCS IRST "Dino Amadori"
per la registrazione della valutazione multidimensionale dei sintomi
secondo la scala ESAS (Edmonton Symptom Assessment System). La scala
ESAS è uno strumento validato di autovalutazione paziente-riferita
utilizzato in oncologia e cure palliative per il monitoraggio sintomatico
longitudinale. Il CVL adotta una variante della scala con 9 sintomi
(anziché i 10 della scala classica), ciascuno codificato in SNOMED CT
e valutato con un punteggio intero da 0 (assente) a 10 (massima intensità).
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
* status ^short = "Stato della valutazione"

// -----------------------------------------------------------------------------
// Category (doppia categorizzazione survey + ESAS)
// -----------------------------------------------------------------------------
// Dai sample tutte le valutazioni hanno DUE elementi in category, con
// pattern analogo a CVLECOGStatus:
//   - Slice "surveyCategory": HL7 "survey" (questionario generico)
//   - Slice "esasCategory": SNOMED CT 451021004 (identificazione specifica ESAS)

* category 2..* MS
* category ^slicing.discriminator.type = #value
* category ^slicing.discriminator.path = "coding.system"
* category ^slicing.rules = #open
* category contains
    surveyCategory 1..1 MS and
    esasCategory 1..1 MS

* category[surveyCategory] ^short = "Categoria generica HL7 (survey)"
* category[surveyCategory].coding 1..1 MS
* category[surveyCategory].coding.system 1..1 MS
* category[surveyCategory].coding.system = "http://terminology.hl7.org/CodeSystem/observation-category" (exactly)
* category[surveyCategory].coding.code 1..1 MS
* category[surveyCategory].coding.code = #survey (exactly)

* category[esasCategory] ^short = "Categoria specifica ESAS (SNOMED CT)"
* category[esasCategory].coding 1..1 MS
* category[esasCategory].coding.system 1..1 MS
* category[esasCategory].coding.system = "http://snomed.info/sct" (exactly)
* category[esasCategory].coding.code 1..1 MS
* category[esasCategory].coding.code = #451021004 (exactly)

// -----------------------------------------------------------------------------
// Code (codice ESAS SNOMED CT)
// -----------------------------------------------------------------------------
// Il code identifica la valutazione come istanza della scala ESAS, con lo
// stesso codice SNOMED CT 451021004 utilizzato nel category esasCategory.

* code 1..1 MS
* code ^short = "Codice SNOMED CT per Edmonton Symptom Assessment System"
* code.coding 1..1 MS
* code.coding.system 1..1 MS
* code.coding.system = "http://snomed.info/sct" (exactly)
* code.coding.code 1..1 MS
* code.coding.code = #451021004 (exactly)

// -----------------------------------------------------------------------------
// Subject
// -----------------------------------------------------------------------------

* subject 1..1 MS
* subject only Reference(CVLPatient)
* subject ^short = "Riferimento al paziente CVL valutato"

// -----------------------------------------------------------------------------
// Effective (data e ora della valutazione)
// -----------------------------------------------------------------------------
// Nei sample effectiveDateTime include anche l'orario preciso
// (es. "2017-03-03T12:07:28"), diversamente dagli altri profili CVL
// che usano solo la data. La precisione temporale riflette la possibilità
// che la scala ESAS sia rilevata più volte nella stessa giornata.

* effective[x] 1..1 MS
* effective[x] only dateTime
* effectiveDateTime ^short = "Data e ora della valutazione ESAS (perturbata)"

// -----------------------------------------------------------------------------
// Component (nove sintomi ESAS)
// -----------------------------------------------------------------------------
// Dai sample ogni valutazione contiene esattamente 9 component,
// corrispondenti ai nove sintomi della scala ESAS adottata dal CVL.
// Ciascun component ha codice SNOMED CT e valueInteger con punteggio 0-10.

* component 9..* MS
* component ^slicing.discriminator.type = #value
* component ^slicing.discriminator.path = "code.coding.code"
* component ^slicing.rules = #open
* component contains
    anxiety 1..1 MS and
    nausea 1..1 MS and
    malaise 1..1 MS and
    pain 1..1 MS and
    depression 1..1 MS and
    fatigue 1..1 MS and
    drowsiness 1..1 MS and
    lossOfAppetite 1..1 MS and
    dyspnea 1..1 MS

// -- Component ansia --
* component[anxiety] ^short = "Punteggio ansia (0-10)"
* component[anxiety].code.coding.system = "http://snomed.info/sct" (exactly)
* component[anxiety].code.coding.code = #48694002 (exactly)
* component[anxiety].value[x] 1..1 MS
* component[anxiety].value[x] only integer

// -- Component nausea --
* component[nausea] ^short = "Punteggio nausea (0-10)"
* component[nausea].code.coding.system = "http://snomed.info/sct" (exactly)
* component[nausea].code.coding.code = #422587007 (exactly)
* component[nausea].value[x] 1..1 MS
* component[nausea].value[x] only integer

// -- Component malessere --
* component[malaise] ^short = "Punteggio malessere generale (0-10)"
* component[malaise].code.coding.system = "http://snomed.info/sct" (exactly)
* component[malaise].code.coding.code = #367391008 (exactly)
* component[malaise].value[x] 1..1 MS
* component[malaise].value[x] only integer

// -- Component dolore --
* component[pain] ^short = "Punteggio dolore (0-10)"
* component[pain].code.coding.system = "http://snomed.info/sct" (exactly)
* component[pain].code.coding.code = #22253000 (exactly)
* component[pain].value[x] 1..1 MS
* component[pain].value[x] only integer

// -- Component depressione --
* component[depression] ^short = "Punteggio depressione (0-10)"
* component[depression].code.coding.system = "http://snomed.info/sct" (exactly)
* component[depression].code.coding.code = #35489007 (exactly)
* component[depression].value[x] 1..1 MS
* component[depression].value[x] only integer

// -- Component stanchezza --
* component[fatigue] ^short = "Punteggio stanchezza/fatigue (0-10)"
* component[fatigue].code.coding.system = "http://snomed.info/sct" (exactly)
* component[fatigue].code.coding.code = #84229001 (exactly)
* component[fatigue].value[x] 1..1 MS
* component[fatigue].value[x] only integer

// -- Component sonnolenza --
* component[drowsiness] ^short = "Punteggio sonnolenza (0-10)"
* component[drowsiness].code.coding.system = "http://snomed.info/sct" (exactly)
* component[drowsiness].code.coding.code = #271782001 (exactly)
* component[drowsiness].value[x] 1..1 MS
* component[drowsiness].value[x] only integer

// -- Component perdita appetito --
* component[lossOfAppetite] ^short = "Punteggio perdita di appetito (0-10)"
* component[lossOfAppetite].code.coding.system = "http://snomed.info/sct" (exactly)
* component[lossOfAppetite].code.coding.code = #289162002 (exactly)
* component[lossOfAppetite].value[x] 1..1 MS
* component[lossOfAppetite].value[x] only integer

// -- Component dispnea --
* component[dyspnea] ^short = "Punteggio dispnea/mancanza di respiro (0-10)"
* component[dyspnea].code.coding.system = "http://snomed.info/sct" (exactly)
* component[dyspnea].code.coding.code = #267036007 (exactly)
* component[dyspnea].value[x] 1..1 MS
* component[dyspnea].value[x] only integer

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
// Nota specifica sul range del valueInteger: la scala ESAS classica
// prevede valori interi da 0 (sintomo assente) a 10 (massima intensità).
// Nei sample analizzati vediamo solo valori 0 e 3, insufficienti per
// giustificare un vincolo formale sul range. Il profilo mantiene il tipo
// integer senza vincolo min/max, coerentemente con la regola di prudenza
// epistemica. Un raffinamento futuro potrà aggiungere il vincolo di range
// quando saranno disponibili sample più ampi.
