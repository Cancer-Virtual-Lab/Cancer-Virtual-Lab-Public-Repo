// =============================================================================
// CVLAdverseEvent.fsh
// Profilo dell'evento avverso correlato a somministrazione farmacologica
// del Cancer Virtual Lab dell'IRCCS IRST.
//
// NOTA IMPORTANTE - Anomalie rilevate nell'implementazione attuale:
// L'analisi dei sample della pipeline ha evidenziato OTTO discrepanze
// pervasive rispetto allo standard FHIR R4:
//   1. Il campo "status" non esiste in AdverseEvent R4; è presente nella
//      pipeline con valore "completed" (comportamento tipico di FHIR R5).
//   2. Campo "subject" obbligatorio (1..1 in R4) omesso nei sample.
//   3. Uso di "resultingEffect" (campo R5) al posto di "resultingCondition"
//      previsto in R4.
//   4. Uso di "suspectEntity.instanceReference" (struttura R5) al posto
//      del campo R4 "suspectEntity.instance" (Reference diretto).
//   5. Uso di "occurrenceDateTime" (campo R5) al posto del campo R4 "date".
//   6. Assenza di codifica MedDRA nel campo event dell'AdverseEvent stesso;
//      la codifica è delegata alla Condition referenziata.
//   7. Assenza sistematica del campo "recordedDate", tipicamente presente
//      negli eventi avversi in farmacovigilanza.
//   8. Assenza del campo "event", che rappresenta il tipo di evento avverso
//      codificato (in R4 è opzionale ma il profilo lo rende obbligatorio
//      come restrizione voluta per il CVL, dato che il tipo di evento è
//      informazione clinicamente essenziale).
//
// La pervasività delle divergenze suggerisce che AdverseEvent, come già
// osservato in CVLAdministration, sia stato modellato dalla pipeline
// utilizzando la specifica FHIR R5 anziché R4. Questo profilo aderisce
// integralmente allo standard R4 e le divergenze sono trattate come
// requisiti per l'attivazione della validazione runtime, documentati
// come esito dell'audit tecnico nel Capitolo 4 e nel Capitolo 5.
// =============================================================================

Profile: CVLAdverseEvent
Parent: AdverseEvent
Id: cvl-adverse-event
Title: "CVL Adverse Event"
Description: """
Profilo AdverseEvent del Cancer Virtual Lab dell'IRCCS IRST "Dino Amadori"
per la registrazione di eventi avversi correlati a somministrazioni
farmacologiche nell'ambito di terapie oncologiche. Il profilo aderisce
integralmente allo standard FHIR R4 e utilizza la codifica MedDRA per
il tipo di evento, coerentemente con la Table 4 del paper Carbonaro et al. (2025).
"""

// -----------------------------------------------------------------------------
// Metadati del profilo
// -----------------------------------------------------------------------------

* ^status = #draft
* ^experimental = true
* ^publisher = "IRCCS IRST 'Dino Amadori'"

// -----------------------------------------------------------------------------
// Actuality
// -----------------------------------------------------------------------------
// Dai sample tutti gli eventi hanno actuality = "actual" (evento
// effettivamente occorso, non solo potenziale). Il campo è obbligatorio
// nello standard R4. Non imponiamo fixed value per consentire in futuro
// la rappresentazione di eventi potenziali.

* actuality 1..1 MS
* actuality ^short = "Attualità dell'evento (actual o potential)"

// -----------------------------------------------------------------------------
// Event (tipo di evento avverso)
// -----------------------------------------------------------------------------
// Nello standard FHIR R4, event è opzionale (0..1). Il profilo lo rende
// obbligatorio (1..1) come RESTRIZIONE VOLUTA per il CVL: il tipo di evento
// avverso è informazione clinicamente essenziale in oncologia e deve essere
// codificato secondo MedDRA per allineamento alle prassi di farmacovigilanza.
// Nei sample attuali il campo è omesso (anomalia n. 8), coerentemente con
// la scelta della pipeline di delegare l'informazione alla Condition
// referenziata da resultingEffect.

* event 1..1 MS
* event ^short = "Tipo di evento avverso codificato in MedDRA"
* event.coding 1..* MS
* event.coding.system 1..1 MS
* event.coding.system = "http://terminology.hl7.org/CodeSystem/mdr" (exactly)
* event.coding.code 1..1 MS
* event.coding.display MS

// -----------------------------------------------------------------------------
// Subject
// -----------------------------------------------------------------------------
// Nello standard FHIR R4, subject è obbligatorio (1..1). Applichiamo il
// pattern architetturale sistematico dell'IG: vincolo di tipo al profilo
// CVLPatient per garantire l'integrità del modello dati.
// Nei sample attuali il campo è OMESSO (anomalia n. 2); il paziente è
// derivabile solo attraverso la MedicationAdministration referenziata.

* subject 1..1 MS
* subject only Reference(CVLPatient)
* subject ^short = "Riferimento al paziente CVL coinvolto nell'evento"

// -----------------------------------------------------------------------------
// Date (data dell'evento)
// -----------------------------------------------------------------------------
// Nello standard FHIR R4, il campo per la data dell'evento avverso è
// denominato "date" (non "occurrenceDateTime" come in R5). Il profilo lo
// dichiara obbligatorio (1..1) come restrizione voluta, per garantire
// tracciabilità temporale degli eventi avversi. Nei sample attuali viene
// utilizzato "occurrenceDateTime" (anomalia n. 5).

* date 1..1 MS
* date ^short = "Data in cui è avvenuto l'evento avverso (perturbata)"

// -----------------------------------------------------------------------------
// SuspectEntity (entità sospetta di aver causato l'evento)
// -----------------------------------------------------------------------------
// Nello standard FHIR R4, suspectEntity.instance è un Reference diretto
// a MedicationAdministration, Medication, Procedure, ecc. Nei sample
// attuali viene utilizzata la struttura "instanceReference" con un livello
// aggiuntivo di annidamento (anomalia n. 4), coerente con FHIR R5.
// Applichiamo il pattern architetturale sistematico dell'IG vincolando
// il tipo del riferimento a CVLAdministration.

* suspectEntity 1..* MS
* suspectEntity ^short = "Entità sospetta di aver causato l'evento"
* suspectEntity.instance 1..1 MS
* suspectEntity.instance only Reference(CVLAdministration)
* suspectEntity.instance ^short = "Riferimento alla somministrazione sospetta"

// -----------------------------------------------------------------------------
// Campi NON vincolati esplicitamente
// -----------------------------------------------------------------------------
// I seguenti campi dello standard FHIR AdverseEvent non vengono vincolati
// perché non emergono dalle fonti verificate:
//   - identifier
//   - category
//   - encounter
//   - detected
//   - recordedDate (anomalia n. 7 - sistematicamente assente nei sample)
//   - resultingCondition (in R4; nei sample viene usato resultingEffect di
//     R5 come anomalia n. 3, referenziando Condition come effetti clinici
//     dell'evento avverso; il profilo mantiene il nome R4 senza vincoli
//     espliciti)
//   - location
//   - seriousness
//   - severity
//   - outcome
//   - recorder
//   - contributor
//   - suspectEntity.causality
//   - subjectMedicalHistory
//   - referenceDocument
//   - study
