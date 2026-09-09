// =============================================================================
// CVLVariant.fsh
// Profilo delle varianti genetiche identificate nei pazienti oncologici
// del Cancer Virtual Lab dell'IRCCS IRST "Dino Amadori".
// =============================================================================

Profile: CVLVariant
Parent: Observation
Id: cvl-variant
Title: "CVL Variant"
Description: """
Profilo Observation del Cancer Virtual Lab dell'IRCCS IRST "Dino Amadori"
per la registrazione delle varianti genetiche identificate nei pazienti
oncologici. Il profilo modella l'identificazione del gene coinvolto tramite
codifica HGNC, l'interpretazione clinica della variante secondo le categorie
ACMG (Pathogenic, Likely pathogenic, Uncertain significance, Likely benign,
Benign) e la descrizione molecolare della variante nucleotidica e
aminoacidica secondo la nomenclatura HGVS. Le varianti registrate nel CVL
sono prevalentemente relative a geni driver del carcinoma polmonare
(EGFR, ALK, ROS1, PIK3CA), coerentemente con la specializzazione di
oncologia toracica di precisione dell'IRST.
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
* status ^short = "Stato della registrazione della variante"

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
// Code (gene HGNC)
// -----------------------------------------------------------------------------
// Il code identifica il GENE coinvolto nella variante attraverso il
// vocabolario HGNC (HUGO Gene Nomenclature Committee), lo standard
// internazionale per la nomenclatura dei geni umani. Il codice è l'ID
// numerico HGNC e il display è il simbolo del gene (es. ALK, EGFR, ROS1,
// PIK3CA). Non impostiamo fixed value sul codice specifico perché il
// vocabolario dei geni è aperto: il CVL può registrare varianti su
// qualunque gene del genoma umano.

* code 1..1 MS
* code ^short = "Gene coinvolto nella variante (codifica HGNC)"
* code.coding 1..1 MS
* code.coding.system 1..1 MS
* code.coding.system = "http://identifiers.org/hgnc/" (exactly)
* code.coding.code 1..1 MS
* code.coding.display MS

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
* effectiveDateTime ^short = "Data della rilevazione della variante (perturbata)"

// -----------------------------------------------------------------------------
// ValueCodeableConcept (significato clinico ACMG)
// -----------------------------------------------------------------------------
// Il valore dell'Observation esprime l'interpretazione clinica della
// variante secondo le categorie ACMG. Il binding required al ValueSet
// CVLVariantSignificanceValueSet impone che il codice appartenga alle
// cinque categorie standard (Pathogenic, Likely pathogenic, Uncertain
// significance, Likely benign, Benign).

* value[x] 1..1 MS
* value[x] only CodeableConcept
* valueCodeableConcept from CVLVariantSignificanceValueSet (required)
* valueCodeableConcept ^short = "Interpretazione clinica ACMG della variante"

// -----------------------------------------------------------------------------
// Component (descrizione molecolare HGVS)
// -----------------------------------------------------------------------------
// Dai sample ogni variante contiene esattamente 2 component:
//   - Slice "nucleotide": codice SNOMED CT 64195000 "Genetic variation",
//     valueString con la descrizione HGVS della variazione nucleotidica
//     (es. "c.3467G>A" - cambio nucleotidico in coordinate cDNA)
//   - Slice "aminoAcid": codice SNOMED CT 250574005 "Amino acid finding",
//     valueString con la descrizione HGVS della variazione aminoacidica
//     (es. "p.(Cys1156Tyr)" - cambio aminoacidico nella proteina)
// La nomenclatura HGVS è lo standard internazionale per la descrizione
// delle varianti genetiche a livello di DNA, RNA e proteina.

* component 2..* MS
* component ^slicing.discriminator.type = #value
* component ^slicing.discriminator.path = "code.coding.code"
* component ^slicing.rules = #open
* component contains
    nucleotide 1..1 MS and
    aminoAcid 1..1 MS

// -- Component variazione nucleotidica --
* component[nucleotide] ^short = "Descrizione HGVS della variazione nucleotidica"
* component[nucleotide].code.coding.system = "http://snomed.info/sct" (exactly)
* component[nucleotide].code.coding.code = #64195000 (exactly)
* component[nucleotide].value[x] 1..1 MS
* component[nucleotide].value[x] only string
* component[nucleotide].valueString ^short = "Nomenclatura HGVS nucleotidica (es. c.3467G>A)"

// -- Component variazione aminoacidica --
* component[aminoAcid] ^short = "Descrizione HGVS della variazione aminoacidica"
* component[aminoAcid].code.coding.system = "http://snomed.info/sct" (exactly)
* component[aminoAcid].code.coding.code = #250574005 (exactly)
* component[aminoAcid].value[x] 1..1 MS
* component[aminoAcid].value[x] only string
* component[aminoAcid].valueString ^short = "Nomenclatura HGVS aminoacidica (es. p.(Cys1156Tyr))"

// -----------------------------------------------------------------------------
// Note (marker documentativo di pipeline)
// -----------------------------------------------------------------------------
// Come CVLBiomarker, dai sample tutte le varianti contengono un campo
// note con testo "variation", utilizzato dalla pipeline per marcatura
// interna del tipo di Observation. Il profilo non lo vincola formalmente.

// -----------------------------------------------------------------------------
// Campi NON vincolati esplicitamente
// -----------------------------------------------------------------------------
// I seguenti campi dello standard FHIR Observation non vengono vincolati:
//   - identifier, basedOn, partOf, focus, encounter, issued, performer,
//     dataAbsentReason, interpretation, bodySite, method, specimen, device,
//     referenceRange, hasMember, derivedFrom
