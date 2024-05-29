# Changelog
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
