// =============================================================================
// CVLActiveSubstance.fsh
// Profilo della sostanza farmacologica attiva del Cancer Virtual Lab
// dell'IRCCS IRST "Dino Amadori".
// =============================================================================

Profile: CVLActiveSubstance
Parent: Medication
Id: cvl-active-substance
Title: "CVL Active Substance"
Description: """
Profilo Medication del Cancer Virtual Lab dell'IRCCS IRST "Dino Amadori"
per la rappresentazione delle sostanze farmacologiche attive somministrate
nell'ambito delle terapie oncologiche. Ogni sostanza è codificata secondo
il sistema di classificazione ATC (Anatomical Therapeutic Chemical) dell'OMS,
coerentemente con la Table 4 del paper Carbonaro et al. (2025). Il CVL
copre principalmente sostanze della classe L01 (agenti antineoplastici).
"""

// -----------------------------------------------------------------------------
// Metadati del profilo
// -----------------------------------------------------------------------------

* ^status = #draft
* ^experimental = true
* ^publisher = "IRCCS IRST 'Dino Amadori'"

// -----------------------------------------------------------------------------
// Identifier
// -----------------------------------------------------------------------------
// Dai sample tutte le sostanze hanno un identifier con il solo campo
// value valorizzato, contenente il codice ATC della sostanza (che coincide
// con l'id della risorsa, es. L01AA01 per cyclophosphamide).

* identifier 1..1 MS
* identifier ^short = "Identificativo della sostanza (codice ATC)"
* identifier.value 1..1 MS
* identifier.value ^short = "Codice ATC (es. L01AA01)"

// -----------------------------------------------------------------------------
// Code (codifica ATC)
// -----------------------------------------------------------------------------
// Il codice della sostanza è espresso secondo il sistema di classificazione
// ATC dell'Organizzazione Mondiale della Sanità, utilizzando l'URL BioPortal
// come system, coerentemente con la scelta implementativa della pipeline CVL.

* code 1..1 MS
* code ^short = "Codice ATC della sostanza farmacologica"
* code.coding 1..* MS
* code.coding.system 1..1 MS
* code.coding.system = "http://purl.bioontology.org/ontology/ATC/" (exactly)
* code.coding.code 1..1 MS
* code.coding.display MS

// -----------------------------------------------------------------------------
// Status
// -----------------------------------------------------------------------------
// Dai sample tutte le sostanze hanno status = "active". Non imponiamo
// fixed value per consentire in futuro la rappresentazione di sostanze
// disattivate (es. per ritiro dal formulario aziendale o per errori
// di caricamento).

* status 1..1 MS
* status ^short = "Stato della sostanza nel formulario (active, inactive, entered-in-error)"

// -----------------------------------------------------------------------------
// Campi NON vincolati esplicitamente
// -----------------------------------------------------------------------------
// I seguenti campi dello standard FHIR Medication non vengono vincolati
// perché non emergono dalle fonti verificate:
//   - manufacturer
//   - form
//   - amount
//   - ingredient
//   - batch
//
// Note specifiche:
// - "manufacturer": non presente nei sample. Se in futuro il CVL registrerà
//   il produttore delle sostanze (per esempio per tracciabilità di lotto),
//   il campo potrà essere aggiunto e vincolato a Reference(Organization).
// - "form": non presente nei sample. La forma farmaceutica (compressa,
//   fiala, soluzione infusionale) non è modellata al livello della sostanza
//   ma è dedotta dal contesto della somministrazione.
// - "ingredient": non presente nei sample. Le sostanze del CVL sono
//   modellate come principi attivi singoli, senza composizione esplicita.
