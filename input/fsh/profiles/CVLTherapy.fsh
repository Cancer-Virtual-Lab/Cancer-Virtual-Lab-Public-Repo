// =============================================================================
// CVLTherapy.fsh
// Profilo del piano terapeutico oncologico del Cancer Virtual Lab dell'IRCCS IRST.
// =============================================================================

Profile: CVLTherapy
Parent: CarePlan
Id: cvl-therapy
Title: "CVL Therapy"
Description: """
Profilo CarePlan del Cancer Virtual Lab dell'IRCCS IRST "Dino Amadori".
Rappresenta un piano terapeutico oncologico associato a un paziente CVL.
Il piano è caratterizzato da un periodo di erogazione, da una categoria
di sessione di pianificazione delle cure (codice SNOMED CT 133891005) e
da tre annotazioni testuali che documentano rispettivamente la linea di
terapia, il setting terapeutico (es. Adiuvante, Avanzato, Induzione) e
il codice ICD-10 del sito tumorale della diagnosi correlata.
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
// Dai sample tutte le terapie hanno status = "active".
// Non imponiamo fixed value per non escludere altri stati legittimi
// (completed, on-hold, revoked, ecc.) che potrebbero comparire in futuro.

* status 1..1 MS
* status ^short = "Stato del piano terapeutico"

// -----------------------------------------------------------------------------
// Intent
// -----------------------------------------------------------------------------
// Dai sample tutte le terapie hanno intent = "plan".
// Non imponiamo fixed value per coerenza con la regola epistemica.

* intent 1..1 MS
* intent ^short = "Tipo di intento del piano terapeutico"

// -----------------------------------------------------------------------------
// Category
// -----------------------------------------------------------------------------
// Dai sample tutte le terapie hanno category valorizzata con il codice
// SNOMED CT 133891005 "Care planning session (procedure)".
// Vincoliamo il system a SNOMED CT ma non imponiamo il codice specifico
// come fixed value per mantenere flessibilita' evolutiva.

* category 1..* MS
* category ^short = "Categoria del piano terapeutico (codice SNOMED CT)"
* category.coding 1..* MS
* category.coding.system 1..1 MS
* category.coding.system = "http://snomed.info/sct" (exactly)
* category.coding.code 1..1 MS
* category.coding.display MS

// -----------------------------------------------------------------------------
// Subject
// -----------------------------------------------------------------------------
// Riferimento obbligatorio al paziente CVL. Applichiamo il pattern
// architetturale sistematico dell'IG: vincolo di tipo al profilo
// CVLPatient per garantire l'integrita' del modello dati.

* subject 1..1 MS
* subject only Reference(CVLPatient)
* subject ^short = "Riferimento al paziente CVL destinatario della terapia"

// -----------------------------------------------------------------------------
// Period
// -----------------------------------------------------------------------------
// Dai sample tutte le terapie hanno period con start ed end valorizzati
// (date perturbate per pseudo-anonimizzazione). Rendiamo entrambi i
// sotto-campi obbligatori e Must Support.

* period 1..1 MS
* period ^short = "Periodo di erogazione della terapia"
* period.start 1..1 MS
* period.start ^short = "Data di inizio della terapia (perturbata)"
* period.end 1..1 MS
* period.end ^short = "Data di fine della terapia (perturbata)"

// -----------------------------------------------------------------------------
// Note
// -----------------------------------------------------------------------------
// Dai sample TUTTE le terapie hanno esattamente 3 annotazioni testuali
// nell'ordine convenzionale:
//   - Posizione 0: linea di terapia (numero intero come stringa, es. "1")
//   - Posizione 1: setting terapeutico in italiano
//                  (es. "Adiuvante", "Avanzato", "Induzione")
//   - Posizione 2: codice ICD-10 del sito tumorale della diagnosi correlata
//                  (es. "C24", "C60")
//
// La convenzione posizionale non e' formalizzata come vincolo FHIR poiche'
// il tipo Annotation non ammette una discriminazione per posizione. La
// convenzione e' documentata in questo commento e nella descrizione del
// profilo, ma il vincolo formale si limita alla cardinalita' esatta (3..3).
//
// Nota metodologica: la rappresentazione dei setting e delle linee come
// testo libero e non come coded value FHIR e' una scelta implementativa
// consapevole della pipeline CVL. La ricodifica ontologica formale, se
// necessaria, avviene a valle nella fase di reasoning del Knowledge Graph.

* note 3..3 MS
* note ^short = "Tre annotazioni testuali: linea, setting, codice ICD-10"
* note.text 1..1 MS

// -----------------------------------------------------------------------------
// Campi NON vincolati esplicitamente
// -----------------------------------------------------------------------------
// I seguenti campi dello standard FHIR CarePlan non vengono vincolati
// perche' non emergono dalle fonti verificate:
//   - identifier
//   - instantiatesCanonical, instantiatesUri
//   - basedOn, replaces, partOf
//   - title, description
//   - encounter
//   - created
//   - author, contributor
//   - careTeam
//   - addresses
//   - supportingInfo
//   - goal
//   - activity
//
// Restano quindi con le cardinalita' e i binding standard di FHIR base.
