# Changelog

## v1.46.0 (2025-06-12)

### General

- Update form of LEKP - Fietspaden [DL-6612]

### Deploy Notes

```
drc restart migrations && drc logs -ft --tail=200 migrations
drc up -d enrich-submission
```

## v1.45.1 (2025-05-28)

### General

- Fix municipalities not able to reference worship service document when the CKB is inactive [DL-6614]

### Deploy instructions

```
drc up -d worship-decisions-cross-reference
```

## v1.45.0 (2025-05-07)

- Add new form 'melding interne beslissing tot samenvoeging' [DL-6361]

### Deploy Notes

**For updating the forms**

```
drc restart migrations && drc logs -ft --tail=200 migrations
drc up -d enrich-submission
```

## v1.44.0 (2025-04-25)

- Update multiple forms. [DL-6602] [DL-6486] [DL-6487] [DL-6488]

### Deploy Notes

**For updating the forms**

```
drc restart migrations && drc logs -ft --tail=200 migrations
drc up -d enrich-submission
```

## v1.43.0 (2025-04-02)

- Bump `migrations` and `mock-login` services.
- frontend [v0.29.1](https://github.com/lblod/frontend-toezicht-abb/blob/127bafb7a8e54f69a935435a098f52ac3b909749/CHANGELOG.md#v0291-2025-03-11)
- Update op consumer config to avoid accidental deletes
- Bump several services. [DL-6492]

### Deploy Notes

- Remove the frontend override from the docker-compose.override.yml file (QA only, PROD still requires a different -prod image, for now)

When deploying on servers not using mock-login:
```
drc restart migrations
```

When deploying locally and on servers using mock-login:
```
drc restart migrations; drc up -d mocklogin
```

- OP consumer update:
```
drc up -d op-public-consumer
```

**For bumping services**
```
drc up -d identifier dispatcher database login cache resource file search deltanotifier
```

**For upgrading virtuoso**
Follow the instructions listed here: [https://github.com/Riadabd/upgrade-virtuoso](https://github.com/Riadabd/upgrade-virtuoso).

## v1.42.1 (2025-03-25)

- Bump `op-public-consumer` to `v0.1.4`.

### Deploy Notes

```
drc up -d op-public-consumer
```

## v1.42.0 (2025-02-27)

- Sync from OP public [DL-6394]
- Add migration that removes two submissions from Gemeente Beveren that should have been submitted under the new fusie gemeent [DL-6431]
- Update semantic forms with `Opdrachthoudende vereniging met private deelname` classification. [DL-6447]

### Deploy notes

WARNING The sync should be deployed after https://github.com/lblod/app-digitaal-loket/pull/631

```
drc down;
```
Update `docker-compose.override.yml` to remove the config of `op-public-consumer` and replace it by:
```
  op-public-consumer:
    environment:
      DCR_SYNC_BASE_URL: "https://organisaties.abb.vlaanderen.be" # or another endpoint
      DCR_LANDING_ZONE_DATABASE: "virtuoso" # for the initial sync, we go directly to virtuoso
      DCR_REMAPPING_DATABASE: "virtuoso" # for the initial sync, we go directly to virtuoso
      DCR_DISABLE_INITIAL_SYNC: "false"
      DCR_DISABLE_DELTA_INGEST: "true"
```

Then:

```
drc up -d virtuoso migrations
drc up -d database op-public-consumer
# Wait until success of the previous step
```

Then, update `docker-compose.override.yml` to:

```
  op-public-consumer:
    environment:
      DCR_SYNC_BASE_URL: "https://organisaties.abb.vlaanderen.be" # or another endpoint
      DCR_LANDING_ZONE_DATABASE: "database"
      DCR_REMAPPING_DATABASE: "database"
      DCR_DISABLE_DELTA_INGEST: "false"
      DCR_DISABLE_INITIAL_SYNC: "false"
```

```
drc up -d
```

Then run the following script to reindex the data

```
#!/bin/bash
echo "Warning this will run queries on the triplestore and delete containers, you have 3 seconds to press ctrl+c"
sleep 3
docker compose rm -fs elasticsearch search
sudo rm -rf data/elasticsearch/
docker-compose exec -T virtuoso isql-v <<EOF
SPARQL DELETE WHERE { GRAPH <http://mu.semte.ch/authorization> { ?s ?p ?o. } };
exec('checkpoint');
exit;
EOF
docker compose up -d
```

#### Update Semantic Forms

The changes here will automatically be picked up by the `op-public-consumer` changes above since the stack will be down-ed completely and started up again from scratch.

## v1.41.0 (2025-01-23)
- Add cross referencing service and config [DL-6352]

### Deploy notes
#### docker-compose.override.yml
##### worship-decisions-cross-reference
Ensure the environment variables are correctly set for `worship-decisions-cross-reference`, e.g. :

```
worship-decisions-cross-reference:
  environment:
    WORSHIP_DECISIONS_BASE_URL: "https://databankerediensten.lokaalbestuur.vlaanderen.be/search/submissions/"
```
The following links;
- DEV: "https://dev.databankerediensten.lokaalbestuur.lblod.info/search/submissions/"
- QA: "https://databankerediensten.lokaalbestuur.lblod.info/search/submissions/"
- PROD: "https://databankerediensten.lokaalbestuur.vlaanderen.be/search/submissions/"

#### Docker Commands
- `drc restart migrations dispatcher`
- `drc up -d toezicht-abb worship-decisions-cross-reference`

## v1.40.9 (2025-01-22)
- Add Jaarrekening PEVA form [DL-6284]

## v1.40.8 (2024-12-13)
- New semantic form `Kerkenbeleidsplan`
- New semantic forms for cross referencing
## 1.40.7 (2024-11-14)
### Toezicht
 - Frontend [v0.28.2](https://github.com/lblod/frontend-toezicht-abb/blob/master/CHANGELOG.md#v0282-2024-11-14) (DL-5435)
# Changelog
## 1.40.6 (2024-11-13)
### Toezicht
 - Update URI form "Aangewezen Burgemeester" [DL-6298]
### Deploy notes
```
drc restart migrations ; drc up -d enrich-submission
```
## 1.40.5 (2024-11-08)

- Remove more eredienst besluittypes. (DL-6234)

### Deploy notes

Make sure migrations are properly run.

## 1.40.4 (2024-10-09)

- Bumped `enrich-submission-service` and add new form file (DL-5930)

### Deploy Notes

Make sure that at least https://github.com/lblod/app-digitaal-loket/pull/596 is
deployed as well. Otherwise, the migration in these last releases needs to be
re-executed.

## 1.40.3 (2024-09-03)
 - Fix duplicate URI for IBEG migration. (DL-5770)
### Deploy Notes
#### Docker Commands
 - `drc restart migrations && drc logs -ft --tail=200 migrations`
 - `drc restart resource cache`
## 1.40.2 (2024-09-03)
 - Remove duplicate URI for IBEG. (DL-5770)
### Deploy Notes
#### Docker Commands
 - `drc restart migrations && drc logs -ft --tail=200 migrations`
 - `drc restart resource cache`
## 1.40.1 (2024-08-12)
 - Add missing `restart`, `labels` and `logging` keys. [DL-6095]
### Deploy Notes
#### Docker Commands
 - `drc up -d search tika elasticsearch`
## 1.40.0 (2024-06-14)
 - Remove multiple besluittypes that don't belong in this application. [DL-5861]
## 1.39.1 (2024-05-29)
  - Fix custom info label field in forms LEKP-rapport - Melding correctie authentieke bron and LEKP-rapport - Toelichting Lokaal Bestuur (DL-5934)
### Deploy Notes
  - `drc up -d enrich-submission; drc restart migrations resource cache`
## 1.39.0 (2024-05-16)

### General
- Update forms
  - Adjust LEKP rapport Klimaattafels (DL-5832)
  - Add new LEKP rapport Wijkverbeteringscontract (DL-5829)

### Deploy Notes
- `drc up -d enrich-submission; drc restart migrations resource cache`

## 1.38.0 (2024-03-14)
- Update forms
  - Adding new form Aanduiding en eedaflegging van de aangewezen burgemeester (DL-5669)
  - Adding new form Strandconcessies - reddingsdiensten kustgemeenten (DL-5625)
  - Adding new form Melding onvolledigheid inzending eredienstbestuur (DL-5643)
  - Adding new form Opstart beroepsprocedure naar aanleiding van een beslissing (DL-5646)
  - Adding informational text to forms to minimize usage of the wrong forms (DL-5665)
  - Adding new form Afschrift erkenningszoekende besturen (DL-5670)
- Frontend [v0.28.0](https://github.com/lblod/frontend-toezicht-abb/blob/master/CHANGELOG.md#v0280-2024-03-13) (DL-5735)
### Deploy instructions
- drc up -d enrich-submission toezicht-abb; drc restart migrations resource cache
## 1.37.0 (2024-01-12)
- Update forms
    - New forms LEKP Collectieve Energiebesparende Renovatie, Fietspaden, Sloopbeleidsplan
    - New forms Niet-bindend advies op statuten and Niet-bindend advies op oprichting
    - Change form LEKP Melding correctie authentieke bron, removed field "type correctie"
### Deploy instructions
- drc up -d enrich-submission; drc restart migrations resource cache
## 1.36.0 (2023-11-15)
- update forms
### deploy instructions
- drc up -d enrich-submission; drc restart migrations resource cache
## 1.35.0 (2023-10-17)
- update forms
- bump frontend

### deploy instructions
- drc up -d toezicht-abb ; drc restart migrations
## 1.34.0 (2023-08-30)
- migration to add bestuurseenheden to selectbox
## 1.33.0 (2023-07-01)
- new forms
- bump frontend
### deploy instructions
```
drc restart migrations enrich-submission resource cache; drc up -d
```
## 1.32.2 (2023-06-26)
- bump frontend to 0.26.2

## 1.32.1 (2023-06-23)
- bump search to 0.9.0-beta.7

## 1.32.0 (2023-06-20)
- bump search to 0.9.0-beta.6
- bump frontend to 0.26.1
## 1.31.1 (2023-05-15)
- fix migration
## 1.31.0 (2023-05-15)
- migrations to fix labels
- migrations to fix issues vendor-data-distribution-service
## 1.30.0 (2023-04-24)
- update forms
## 1.29.1 (2023-04-08)
 - bump frontend
 - adjusted schorsing beslissing eredienstbesturen form for deputatie
## 1.29.0 (2023-02-07)
 - Update forms
## 1.28.0 (2023-01-24)
 - Update forms (going to prod with erediensten)
## 1.27.1 (2022-12-20)
### submissions
 - Due to various issues after a batch sent in prod of automatic submission, we removed them to try again
## 1.27.0 (2022-11-29)
- update file model `dct:created`
- update forms
- added Welzijnsvereniging de Wijngaard
## 1.26.0 (2022-10-07)
- update forms
## 1.25.2 (2022-10-06)
### :bug: Bug fix
- Allow users to load more "bestuurseenheden" in the select filter
## 1.25.1 (2022-09-29)
- Update OVO Kabinet Somers
## 1.25.0 (2022-07-27)
- Added new forms
## 1.24.0 (2022-05-03)
- Added new forms (for erediensten)
- bump frontend (so ember-submission-form-fields gets updated to latest)
- bump enrich-submission (with update validation libaries)
## 1.23.2 (2022-02-24)
- update form
## 1.23.1 (2022-02-23)
- update form
## 1.23.0 (2022-02-18)
- Added new forms
## 1.22.0 (2022-01-25)
### :house: Internal
- Re-organize migrations
- Added new forms
- bumped enrich-submissions

## 1.21.3 (2021-12-14)
### :house: Internal
- Bump virtuoso to the latest version used in house

## 1.21.2 (2021-12-13)
### :house: Internal
- Bump mu-search to counter CVE-2021-44228

## 1.21.1 (2021-12-06)
### :house: Internal
- Updated some bestuurseenheden which were not available in the select boxes

## 1.21.0 (2021-10-27)

### :house: Internal
- Update login service which contains some error handling improvements.
- Added extra OVO number for kabinet
