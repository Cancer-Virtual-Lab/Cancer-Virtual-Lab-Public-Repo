// =============================================================================
// CVLDepartment.fsh
// Profilo del reparto/unità organizzativa del Cancer Virtual Lab
// dell'IRCCS IRST "Dino Amadori".
// =============================================================================

Profile: CVLDepartment
Parent: Organization
Id: cvl-department
Title: "CVL Department"
Description: """
Profilo Organization del Cancer Virtual Lab dell'IRCCS IRST "Dino Amadori"
per la rappresentazione dei reparti e delle unità organizzative dell'istituto.
Il profilo modella le strutture organizzative multi-sede dell'IRST (Meldola,
Forlì, Cesena, Ravenna) che erogano prestazioni cliniche e servizi di
supporto ai pazienti oncologici del CVL.
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
// Dai sample tutti i reparti hanno un identifier con il solo campo value
// valorizzato, contenente il codice interno del reparto (es. I510, CE2980).
// Il campo system non è presente, quindi non lo vincoliamo.

* identifier 1..1 MS
* identifier ^short = "Codice identificativo interno del reparto IRST"
* identifier.value 1..1 MS
* identifier.value ^short = "Codice del reparto (es. I510, CE2980)"

// -----------------------------------------------------------------------------
// Name
// -----------------------------------------------------------------------------
// Dai sample tutti i reparti hanno name valorizzato. In alcuni casi il nome
// è una stringa descrittiva del reparto (es. "ONCOLOGIA AMBULATORIO - CESENA"),
// in altri casi (id con prefisso "CE") il campo è valorizzato con la stringa
// "unknown" come placeholder per reparti privi di descrizione anagrafica.
// Rendiamo il campo obbligatorio poiché sempre presente nei dati.

* name 1..1 MS
* name ^short = "Nome descrittivo del reparto (o 'unknown' per reparti senza descrizione)"

// -----------------------------------------------------------------------------
// Campi NON vincolati esplicitamente
// -----------------------------------------------------------------------------
// I seguenti campi dello standard FHIR Organization non vengono vincolati
// perché non emergono dalle fonti verificate:
//   - active
//   - type
//   - alias
//   - telecom
//   - address
//   - partOf
//   - contact
//   - endpoint
//
// Nota specifica su "type": nello standard FHIR sarebbe naturale utilizzare
// il campo type con un codice del CodeSystem "organization-type" per
// classificare i reparti come "dept" (dipartimenti). Nei sample il campo
// non è valorizzato, coerentemente con la scelta implementativa della
// pipeline di rappresentare i reparti come Organization generiche.
//
// Nota specifica su "partOf": nello standard FHIR sarebbe naturale utilizzare
// partOf per rappresentare la gerarchia organizzativa (per esempio, il
// reparto di "ONCOLOGIA AMBULATORIO - CESENA" come partOf dell'IRCCS IRST
// come organizzazione madre). Nei sample il campo non è valorizzato, quindi
// non lo vincoliamo. La gerarchia organizzativa potrebbe essere aggiunta
// in fasi successive dell'evoluzione della IG.
