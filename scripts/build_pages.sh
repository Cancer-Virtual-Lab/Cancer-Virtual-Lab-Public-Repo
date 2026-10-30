#!/usr/bin/env bash
# =============================================================================
# Build the GitHub Pages site in docs/ (Settings -> Pages -> main, /docs):
#   docs/index.html       project landing page   (pages/index.html)
#   docs/ontology/        CVL-O page             (pages/ontology/index.html)
#                         + WIDOCO documentation and WebVOWL graph (doc/)
#                         + downloads            (download/cvl-ontology.*)
#                         + validation reports   (validation/)
#
# The ontology and its validation reports are read from the CVL-O folder of the
# Zenodo deposit, so the site always shows the deposited version.
#
# Usage (from any folder):
#   CVLO_PACKAGE="/path/to/CVL-O Ontology" WIDOCO_JAR=/path/widoco.jar scripts/build_pages.sh
# Optional: JAVA (default: java).
# Requires WIDOCO 1.4.25 (widoco-1.4.25-jar-with-dependencies_JDK-17.jar), Java 17+ and Python 3.
# =============================================================================
set -euo pipefail
cd "$(dirname "$0")/.."

JAVA="${JAVA:-java}"
WIDOCO_JAR="${WIDOCO_JAR:?set WIDOCO_JAR to the WIDOCO 1.4.25 jar (JDK 17 build)}"
PKG="${CVLO_PACKAGE:?set CVLO_PACKAGE to the CVL-O folder of the Zenodo deposit}"
OUT=docs
TMP=.pages-build

# Java on Windows needs native paths (Git Bash passes /d/... otherwise)
native() { if command -v cygpath >/dev/null; then cygpath -w "$1"; else echo "$1"; fi; }

echo "== 1. Documentation (WIDOCO)"
rm -rf "$TMP"
# UTF-8 is required on Windows, otherwise WebVOWL data are written in the platform encoding
"$JAVA" -Dfile.encoding=UTF-8 -Dsun.jnu.encoding=UTF-8 -Xmx4g -jar "$(native "$WIDOCO_JAR")" \
  -ontFile "$(native "$PKG/ontology/cvl_ontology.ttl")" -outFolder "$TMP" \
  -confFile pages/ontology/widoco.properties \
  -lang en-it -webVowl -uniteSections -excludeIntroduction -ignoreIndividuals -rewriteAll
# WebVOWL hides low-degree nodes by default above 50 nodes, which detaches e.g. ECOG and ESAS
# from Patient: open the full graph instead (the filter stays available in the Filter menu)
sed -i 's/NODE_COUNT_LIMIT_FOR_AUTO_ENABLING = 50;/NODE_COUNT_LIMIT_FOR_AUTO_ENABLING = 100000;/' \
  "$TMP/doc/webvowl/js/webvowl.js"
# Value classes are also declared as individuals of themselves (OWL 2 punning, used by the
# queries): WebVOWL draws each as an "is a" self-loop. Hide them in the graph only.
python3 - "$TMP/doc/webvowl/data/ontology.json" <<'PY'
import json, sys
path = sys.argv[1]
with open(path, encoding="utf-8") as f:
    data = json.load(f)
types = {p["id"]: p["type"] for p in data["property"]}
loops = {a["id"] for a in data["propertyAttribute"]
         if types.get(a["id"]) == "rdf:Property" and a.get("domain") == a.get("range")}
data["property"] = [p for p in data["property"] if p["id"] not in loops]
data["propertyAttribute"] = [a for a in data["propertyAttribute"] if a["id"] not in loops]
with open(path, "w", encoding="utf-8") as f:
    json.dump(data, f, ensure_ascii=False)
print(f"WebVOWL: hid {len(loops)} punning self-loops")
PY

echo "== 2. Site -> $OUT/"
rm -rf "$OUT"
mkdir -p "$OUT/ontology/validation"
cp pages/index.html "$OUT/"
cp -r pages/assets "$OUT/assets"
cp pages/ontology/index.html "$OUT/ontology/"
cp -r "$TMP/doc" "$OUT/ontology/doc"
# Downloads: the deposited Turtle and RDF/XML files, plus the JSON-LD and N-Triples written by WIDOCO
mkdir -p "$OUT/ontology/download"
cp "$PKG/ontology/cvl_ontology.ttl" "$OUT/ontology/download/cvl-ontology.ttl"
cp "$PKG/ontology/cvl_ontology.owl" "$OUT/ontology/download/cvl-ontology.owl"
cp "$TMP/doc/ontology.jsonld" "$OUT/ontology/download/cvl-ontology.jsonld"
cp "$TMP/doc/ontology.nt" "$OUT/ontology/download/cvl-ontology.nt"
cp "$PKG"/validation/{robot_report.html,robot_report.tsv,owl2_dl_profile.txt,reasoner_hermit.log} \
  "$OUT/ontology/validation/"
# Serve files as they are (no Jekyll processing)
touch "$OUT/.nojekyll"
rm -rf "$TMP"

echo "Done."
