// =============================================================================
// CVLTNMComponent.fsh
// Profilo delle singole valutazioni componenti del sistema TNM di
// stadiazione tumorale del Cancer Virtual Lab dell'IRCCS IRST.
//
// Il profilo rappresenta una singola Observation che documenta uno dei tre
// elementi del sistema TNM (T, N o M) in una delle sue due forme (clinical
// o pathological), per un totale di sei possibili varianti: cT, cN, cM,
// pT, pN, pM. La discriminazione tra le sei varianti avviene attraverso il
// campo category che utilizza un doppio pattern SNOMED CT.
// =============================================================================

Profile: CVLTNMComponent
Parent: Observation
Id: cvl-tnm-component
Title: "CVL TNM Component"
Description: """
Profilo Observation del Cancer Virtual Lab dell'IRCCS IRST "Dino Amadori"
per la registrazione di una singola valutazione componente del sistema TNM
di stadiazione tumorale. Il profilo copre le sei varianti possibili
(clinical/pathological × T/N/M) attraverso un pattern di doppia
categorizzazione SNOMED CT. Il valore della componente è espresso nel
campo code utilizzando i CodeSystem locali del CVL per T, N e M.
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
// Dai sample tutte le valutazioni componenti hanno status = "registered".

* status 1..1 MS
* status ^short = "Stato della valutazione"

// -----------------------------------------------------------------------------
// Category (doppio pattern SNOMED CT)
// -----------------------------------------------------------------------------
// Dai sample ogni valutazione componente ha DUE elementi in category:
//   - Slice "specificCategory": codice SNOMED CT che identifica una delle
//     sei varianti (cT, cN, cM, pT, pN, pM) tramite codici specifici
//   - Slice "genericCategory": codice SNOMED CT 399566009 "TNM category"
//     come classificazione generica
//
// Codici SNOMED CT osservati per specificCategory:
//   - 399504009 cT category (Clinical T)
//   - 399534004 cN category (Clinical N)
//   - 399387003 cM category (Clinical M)
//   - 384625004 pT category (Pathological T)
//   - 371494008 pN category (Pathological N)
//   - 371497001 pM category (Pathological M)

* category 2..* MS
* category ^slicing.discriminator.type = #value
* category ^slicing.discriminator.path = "coding.code"
* category ^slicing.rules = #open
* category contains
    specificCategory 1..1 MS and
    genericCategory 1..1 MS

* category[specificCategory] ^short = "Categoria specifica (cT/cN/cM/pT/pN/pM)"
* category[specificCategory].coding 1..1 MS
* category[specificCategory].coding.system 1..1 MS
* category[specificCategory].coding.system = "http://snomed.info/sct" (exactly)
* category[specificCategory].coding.code 1..1 MS

* category[genericCategory] ^short = "Categoria generica TNM"
* category[genericCategory].coding 1..1 MS
* category[genericCategory].coding.system 1..1 MS
* category[genericCategory].coding.system = "http://snomed.info/sct" (exactly)
* category[genericCategory].coding.code 1..1 MS

// -----------------------------------------------------------------------------
// Code (valore della componente)
// -----------------------------------------------------------------------------
// Il code contiene il valore effettivo della componente (T2, N0, M1, ecc.)
// utilizzando i CodeSystem locali del CVL. Nei sample il campo system è
// assente; il profilo lo dichiara obbligatorio per allinearsi allo standard
// FHIR
//
// La determinazione di quale ValueSet vincolare al code (CVLTValueSet vs
// CVLNValueSet vs CVLMValueSet) dipende dalla categoria specifica dichiarata
// in category[specificCategory], ma FHIR R4 non supporta binding condizionali.
// Il profilo dichiara quindi un binding esteso che accetta codici dai tre
// ValueSet, delegando alla logica applicativa la verifica di coerenza tra
// categoria e valore.

* code 1..1 MS
* code ^short = "Valore della componente TNM (T2, N0, M1, ecc.)"
* code.coding 1..* MS
* code.coding.system 1..1 MS
* code.coding.code 1..1 MS

// -----------------------------------------------------------------------------
// Subject
// -----------------------------------------------------------------------------
// Applicazione del pattern architetturale sistematico dell'IG.

* subject 1..1 MS
* subject only Reference(CVLPatient)
* subject ^short = "Riferimento al paziente CVL valutato"

// -----------------------------------------------------------------------------
// Campi NON vincolati esplicitamente
// -----------------------------------------------------------------------------
// I seguenti campi dello standard FHIR Observation non vengono vincolati
// perché non emergono dalle fonti verificate:
//   - identifier, basedOn, partOf, focus, encounter, effective[x], issued,
//     performer, value[x], dataAbsentReason, interpretation, note, bodySite,
//     method, specimen, device, referenceRange, hasMember, derivedFrom, component
//
// Nota specifica su "effective[x]": nei sample delle valutazioni componenti
// il campo effective non è valorizzato. La data della valutazione è tipicamente
// documentata nell'Observation di raggruppamento (CVLTNMGrouping) che aggrega
// le tre componenti T/N/M.
