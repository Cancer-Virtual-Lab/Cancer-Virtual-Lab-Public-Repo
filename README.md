# Cancer-Virtual-Lab-Public-Repo

Public materials of the Cancer Virtual Lab (CVL) of IRCCS IRST "Dino Amadori".

Website: <https://cancer-virtual-lab.github.io/Cancer-Virtual-Lab-Public-Repo/>

## Contents

| Folder | Content |
| --- | --- |
| `input/fsh/` | FSH sources of the CVL FHIR Implementation Guide profiles |
| `docs/` | GitHub Pages site (generated, do not edit by hand) |
| `pages/` | Sources of the site: landing page and CVL-O ontology page, WIDOCO configuration |
| `scripts/build_pages.sh` | Builds `docs/` from `pages/` and the CVL-O folder of the Zenodo deposit |

## Rebuilding the site

Requires Java 17+ and WIDOCO 1.4.25
(`widoco-1.4.25-jar-with-dependencies_JDK-17.jar`):

```bash
CVLO_PACKAGE="/path/to/CVL-O Ontology" WIDOCO_JAR=/path/to/widoco.jar scripts/build_pages.sh
```

`CVLO_PACKAGE` is the CVL-O folder of the reproducibility package
(<https://doi.org/10.5281/zenodo.23762955>), which contains `ontology/` and
`validation/`. Set `JAVA` if `java` is not on the `PATH`.

GitHub Pages serves the `docs/` folder of the `main` branch
(*Settings → Pages → Deploy from a branch → main, /docs*).
