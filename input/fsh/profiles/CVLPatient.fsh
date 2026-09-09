// =============================================================================
// CVLPatient.fsh
// Profilo del paziente oncologico del Cancer Virtual Lab dell'IRCCS IRST.
// =============================================================================

Profile: CVLPatient
Parent: Patient
Id: cvl-patient
Title: "CVL Patient"
Description: """
Profilo Patient del Cancer Virtual Lab dell'IRCCS IRST "Dino Amadori".
Rappresenta un paziente oncologico arruolato negli studi del CVL.
I dati anagrafici sono pseudo-anonimizzati tramite tecniche di perturbazione
e hashing come descritto in Carbonaro et al. (2025).
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
// Dai sample osserviamo che ogni Patient ha almeno un
// identifier con il campo value valorizzato (hash pseudo-anonimizzato).
// Il campo system non e' presente nei sample analizzati, quindi non lo
// vincoliamo. Cardinalita' minima: 1 (deve esistere almeno un identifier).

* identifier 1..* MS
* identifier ^short = "Identificativo pseudo-anonimizzato del paziente nel CVL"
* identifier.value 1..1 MS
* identifier.value ^short = "Valore hash dell'identificativo originale"

// -----------------------------------------------------------------------------
// Gender
// -----------------------------------------------------------------------------
// Dai sample osserviamo valori "male" e "female", coerenti con lo standard
// FHIR AdministrativeGender. Non introduciamo binding aggiuntivi rispetto
// al binding standard di Patient.gender (required a AdministrativeGender).
// Cardinalita' 0..1 come da standard FHIR.

* gender MS
* gender ^short = "Sesso alla nascita del paziente"

// -----------------------------------------------------------------------------
// BirthDate
// -----------------------------------------------------------------------------
// Presente nei sample. La data e' perturbata per pseudo-anonimizzazione
// come descritto nel paper Carbonaro sezione sulla privacy.
// Cardinalita' 0..1 come da standard FHIR.

* birthDate MS
* birthDate ^short = "Data di nascita del paziente (perturbata per pseudo-anonimizzazione)"

// -----------------------------------------------------------------------------
// Deceased
// -----------------------------------------------------------------------------
// Il CVL contiene ESCLUSIVAMENTE pazienti deceduti (come dichiarato dal paper
// Carbonaro et al. 2025). Dai sample tutti i pazienti hanno deceasedDateTime
// valorizzato. Scegliamo di rendere il campo Must Support e di usare
// deceasedDateTime (non deceasedBoolean) come tipo specifico.
// La data e' perturbata per pseudo-anonimizzazione.

* deceased[x] MS
* deceased[x] only dateTime
* deceasedDateTime ^short = "Data di decesso del paziente (perturbata per pseudo-anonimizzazione)"

// -----------------------------------------------------------------------------
// Campi NON vincolati esplicitamente
// -----------------------------------------------------------------------------
// I seguenti campi dello standard FHIR Patient non vengono vincolati
// perche' non emergono dalle fonti verificate:
//   - active
//   - name
//   - telecom
//   - address
//   - maritalStatus
//   - multipleBirth[x]
//   - photo
//   - contact
//   - communication
//   - generalPractitioner
//   - managingOrganization
//   - link
//
// Restano quindi con le cardinalita' e i binding standard di FHIR base.
// Saranno aggiunti vincoli solo se emergono nuove informazioni dai sample
// ufficiali di Irene e Manuel o da chiarimenti successivi.
