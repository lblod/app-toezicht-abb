# Toezicht ABB
## Running the application
```
docker-compose up
```
The stack is built starting from [mu-project](https://github.com/mu-semtech/mu-project).
The stack however, contains some anachronisms, in order to run the application you should create a `docker-compose.overide.yaml` including:
```
services:
	identifier:
		ports:
			- 4206:80
```

## Trigger import-export flow from app-digitaal-loket

The `app-toezicht-abb` consumes information produced by `app-digitaal-loket`.
Currently, it is old style data sharing: a dump is produced by loket in a first step. In the second step, the dump is ingested by the `app-toezicht-abb`.

### Step 0: Update export information
The app will mount a folder used by `app-digitaal-loket`. Therefore, a specific config in docker is needed. Append the following to `docker-compose.override.yml` of `app-toezicht-abb`.
```
 file:
    volumes:
      - /absolute/path/to/app-digitaal-loket-qa/data/files:/share
  search:
    environment:
      NUMBER_OF_THREADS: 2
      JRUBY_OPTIONS: "-J-Xmx2g"
    volumes:
      - /absolute/path/to/app-digitaal-loket-qa/data/files:/data
  import:
    volumes:
      - /absolute/path/to/app-digitaal-loket-qa/data/exports/submissions:/data/imports
  enrich-submission:
    volumes:
      - /absolute/path/to/app-digitaal-loket-qa/data/files/submissions:/share/submission
```

#### Step 1: Export
Start `app-digitaal-loket` and connect to the container of `export-submissions`. 
```
cd app-digitaal-loket

docker-compose up -d

docker-compose exec export-submissions bash
```
In the container, trigger the export:
```
wget --post-data='' http://localhost/export-tasks
```
The export will be saved in /data/exports/submissions/ , however make sure that you had created some submissions in the `toezicht` module of the application. Note that running above command may throw an error, but this should not be a problem. 

You should also make sure that the file is at least 30 min old.
```
cd app-digitaal-loket

touch -d "2 hours ago" ./data/exports/submissions/submissions-[the-latest-timestamp].ttl`
```

During this process we discovered that a change is needed to the  `rules.js` file of the `delta-notifier` of  `app-digitaal-loket`.
This should be handled in another issue shortly after. If export still doesn't work, please replace `rules.js` by:

```
export default [
  {
    match: {
      subject: {}
    },
    callback: {
      url: 'http://resource/.mu/delta',
      method: 'POST'
    },
    options: {
      resourceFormat: 'v0.0.1',
      gracePeriod: 250,
      ignoreFromSelf: true,
      optOutMuScopeIds: [ "http://redpencil.data.gift/id/concept/muScope/deltas/initialSync" ]
    }
  },
  {
    match: {
      predicate: {
        type: 'uri',
        value: 'http://www.w3.org/ns/adms#status'
      },
      object: {
        type: 'uri',
        value: 'http://lblod.data.gift/file-download-statuses/ready-to-be-cached'
      }
    },
    callback: {
      url: 'http://download-url/process-remote-data-objects',
      method: 'POST'
    },
    options: {
      resourceFormat: 'v0.0.1',
      gracePeriod: 1000,
      ignoreFromSelf: true,
      optOutMuScopeIds: [
                          "http://redpencil.data.gift/id/concept/muScope/deltas/initialSync",
                          "http://redpencil.data.gift/id/concept/muScope/deltas/publicationGraphMaintenance"
                        ]
    }
  },
  {
    match: {
      predicate: {
        type: 'uri',
        value: 'http://www.w3.org/ns/adms#status'
      },
      object: {
        type: 'uri',
        value: 'http://lblod.data.gift/file-download-statuses/success'
      }
    },
    callback: {
      url: 'http://import-submission/delta',
      method: 'POST'
    },
    options: {
      resourceFormat: 'v0.0.1',
      gracePeriod: 1000,
      ignoreFromSelf: true,
      optOutMuScopeIds: [
                          "http://redpencil.data.gift/id/concept/muScope/deltas/initialSync",
                          "http://redpencil.data.gift/id/concept/muScope/deltas/publicationGraphMaintenance"
                        ]
    }
  },
  {
    match: {
      predicate: {
        type: 'uri',
        value: 'http://www.w3.org/ns/adms#status'
      },
      object: {
        type: 'uri',
        value: 'http://lblod.data.gift/automatische-melding-statuses/ready-for-enrichment'
      }
    },
callback: {
      url: 'http://enrich-submission/delta',
      method: 'POST'
    },
    options: {
      resourceFormat: 'v0.0.1',
      gracePeriod: 1000,
      ignoreFromSelf: true,
      optOutMuScopeIds: [
                          "http://redpencil.data.gift/id/concept/muScope/deltas/initialSync",
                          "http://redpencil.data.gift/id/concept/muScope/deltas/publicationGraphMaintenance"
                        ]
    }
  },
  {
    match: {
      predicate: {
        type: 'uri',
        value: 'http://www.w3.org/ns/adms#status'
      },
      object: {
        type: 'uri',
        value: 'http://lblod.data.gift/automatische-melding-statuses/ready-for-validation'
      }
    },
    callback: {
      url: 'http://validate-submission/delta',
      method: 'POST'
    },
    options: {
      resourceFormat: 'v0.0.1',
      gracePeriod: 1000,
      ignoreFromSelf: true,
      optOutMuScopeIds: [
                          "http://redpencil.data.gift/id/concept/muScope/deltas/initialSync",
                          "http://redpencil.data.gift/id/concept/muScope/deltas/publicationGraphMaintenance"
                        ]
    }
  },
  {
    match: {
      predicate: {
        type: 'uri',
        value: 'http://www.w3.org/ns/adms#status'
      },
      object: {
        type: 'uri',
        value: 'http://lblod.data.gift/concepts/f6330856-e261-430f-b949-8e510d20d0ff' // Inzendbaar
      }
    },
    callback: {
      url: 'http://toezicht-flattened-form-data-generator/delta',
      method: 'POST'
    },
    options: {
      resourceFormat: 'v0.0.1',
      gracePeriod: 1000,
      ignoreFromSelf: true,
      optOutMuScopeIds: [
                          "http://redpencil.data.gift/id/concept/muScope/deltas/initialSync",
                          "http://redpencil.data.gift/id/concept/muScope/deltas/publicationGraphMaintenance"
                        ]
    }
  },
  {
    match: {
      // anything
    },
    callback: {
      url: 'http://prepare-submissions-for-export/delta',
      method: 'POST'
    },
    options: {
      resourceFormat: 'v0.0.1',
      gracePeriod: 1000,
      ignoreFromSelf: true,
      optOutMuScopeIds: [
                          "http://redpencil.data.gift/id/concept/muScope/deltas/initialSync",
                          "http://redpencil.data.gift/id/concept/muScope/deltas/publicationGraphMaintenance"
                        ]
    }
  },
  {
    match: {
      predicate: {
        type: 'uri',
        value: 'http://www.w3.org/ns/adms#status'
      },
      object: {
        type: 'uri',
        value: 'http://lblod.data.gift/automatische-melding-statuses/successful-sent'
      }
    },
    callback: {
      url: 'http://toezicht-flattened-form-data-generator/delta',
      method: 'POST'
    },
    options: {
      resourceFormat: 'v0.0.1',
      gracePeriod: 1000,
      ignoreFromSelf: true,
      optOutMuScopeIds: [
                          "http://redpencil.data.gift/id/concept/muScope/deltas/initialSync",
                          "http://redpencil.data.gift/id/concept/muScope/deltas/publicationGraphMaintenance"
                        ]
    }
  },
  {
    match: {
      predicate: {
        type: 'uri',
        value: 'http://www.w3.org/ns/adms#status'
      },
      object: {
        type: 'uri',
        value: 'http://lblod.data.gift/automatische-melding-statuses/successful-concept'
      }
    },
    callback: {
      method: 'POST',
      url: 'http://toezicht-flattened-form-data-generator/delta'
    },
    options: {
      resourceFormat: 'v0.0.1',
      gracePeriod: 1000,
      ignoreFromSelf: true,
      optOutMuScopeIds: [
                          "http://redpencil.data.gift/id/concept/muScope/deltas/initialSync",
                          "http://redpencil.data.gift/id/concept/muScope/deltas/publicationGraphMaintenance"
                        ]
    }
  },
  {
    match: {
      predicate: {
        type: 'uri',
        value: 'http://www.w3.org/ns/adms#status'
      }
    },
    callback: {
      method: 'POST',
      url: 'http://jobs-controller/delta'
    },
    options: {
      resourceFormat: 'v0.0.1',
      gracePeriod: 1000,
      ignoreFromSelf: true,
      optOutMuScopeIds: [
                          "http://redpencil.data.gift/id/concept/muScope/deltas/initialSync",
                          "http://redpencil.data.gift/id/concept/muScope/deltas/publicationGraphMaintenance"
                        ]
    }
  }
];
```

**Note:** This is a work-around!

#### Step 2: Import
Start `app-toezicht-abb` and connect to the container of `import`. 
```
cd app-toezicht-abb

docker-compose up -d

docker-compose exec export-submissions bash
```
In the containter, run the following:
```
/bin/bash import.sh
```
Restart the application and logging is as `editeur` via `mock-login`, should make the submissions visible.


### (Optional) Step 3: Trigger elastic index
So there is another view, that uses mu-search (a wrapper around elastic). You can see when you log in as `lezer`.

To make it work, the index should be triggered, you can run and re-run the following script
```
#!/bin/bash
echo "Warning this will run queries on the triplestore and delete containers, you have 3 seconds to press ctrl+c"
sleep 3
docker-compose rm -fs elasticsearch search
sudo rm -rf data/elasticsearch/
docker-compose exec -T virtuoso isql-v <<EOF
SPARQL DELETE WHERE {   GRAPH <http://mu.semte.ch/authorization> {     ?s ?p ?o.   } };
exec('checkpoint');
exit;
EOF
```