# Changelog
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
