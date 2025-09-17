;;;;;;;;;;;;;;;;;;;
;;; delta messenger
(in-package :delta-messenger)

(add-delta-logger)
(add-delta-messenger "http://deltanotifier/")

;;;;;;;;;;;;;;;;;
;;; configuration
(in-package :client)
(setf *log-sparql-query-roundtrip* t)
(setf *backend* "http://virtuoso:8890/sparql")

(in-package :server)
(setf *log-incoming-requests-p* nil)

;;;;;;;;;;;;;;;;;
;;; access rights
(in-package :acl)

(defparameter *access-specifications* nil
  "All known ACCESS specifications.")

(defparameter *graphs* nil
  "All known GRAPH-SPECIFICATION instances.")

(defparameter *rights* nil
  "All known GRANT instances connecting ACCESS-SPECIFICATION to GRAPH.")

;; Prefixes used in the constraints below (not in the SPARQL queries)
(define-prefixes
  :adms "http://www.w3.org/ns/adms#"
  :besluit "http://data.vlaanderen.be/ns/besluit#"
  :ext "http://mu.semte.ch/vocabularies/ext/"
  :foaf "http://xmlns.com/foaf/0.1/"
  :mu "http://mu.semte.ch/vocabularies/core/"
  :myexp "http://rdf.myexperiment.org/ontologies/base/"
  :nfo "http://www.semanticdesktop.org/ontologies/2007/03/22/nfo#"
  :org "http://www.w3.org/ns/org#"
  :prov "http://www.w3.org/ns/prov#"
  :schema "http://schema.org/"
  :session "http://mu.semte.ch/vocabularies/session/"
  :skos "http://www.w3.org/2004/02/skos/core#")

(type-cache::add-type-for-prefix "http://mu.semte.ch/sessions/" "http://mu.semte.ch/vocabularies/session/Session")

(define-graph public ("http://mu.semte.ch/graphs/public")
  ("foaf:Person" -> _)
  ("foaf:OnlineAccount" -> _)
  ("besluit:Bestuurseenheid" -> _))

(define-graph readers ("http://mu.semte.ch/graphs/organizations/")
  ("foaf:Person" -> _)
  ("foaf:OnlineAccount" -> _)
  ("adms:Identifier" -> _)
  ("ext:DocumentStatus" -> _)
  ("nfo:FileDataObject" -> _)
  ("nfo:RemoteDataObject" -> _)
  ("prov:Location" -> _)
  ("ext:BestuurseenheidClassificatieCode" -> _)
  ("besluit:Bestuursorgaan" -> _)
  ("ext:BestuursorgaanClassificatieCode" -> _)
  ("besluit:Bestuurseenheid" -> _)
  ("ext:ChartOfAccount" -> _)
  ("ext:AuthenticityType" -> _)
  ("ext:TaxType" -> _)
  ("ext:SubmissionDocumentStatus" -> _)
  ("skos:ConceptScheme" -> _)
  ("skos:Concept" -> _)
  ("foaf:Document" -> _)
  ("myexp:Submission" -> _)
  ("ext:SubmissionDocument" -> _)
  ("http://lblod.data.gift/vocabularies/besluit/TaxRate" -> _)
  ("http://lblod.data.gift/vocabularies/automatische-melding/FormData" -> _)
  ("ext:Vendor" -> _)
  ("ext:SubmissionReviewStatus" -> _)
  ("schema:Review" -> _)
  ("ext:supervision/InzendingVoorToezicht" -> _) ; still needed to be able to redirect old URLs correctly
  ("http://lblod.data.gift/vocabularies/search-queries-toezicht/SearchQuery" -> _)
  ("org:Site" -> _))

(define-graph users ("http://mu.semte.ch/graphs/organizations/")
  ("foaf:Person" -> _)
  ("http://lblod.data.gift/vocabularies/search-queries-toezicht/SearchQuery" -> _))


(define-graph editors ("http://mu.semte.ch/graphs/organizations/")
  ("schema:Review" -> _))

(supply-allowed-group "public")

(supply-allowed-group "session-group"
  :parameters ("session_group")
  :query "PREFIX ext: <http://mu.semte.ch/vocabularies/ext/>
          PREFIX mu: <http://mu.semte.ch/vocabularies/core/>
          SELECT DISTINCT ?session_group WHERE {
            <SESSION_ID> ext:sessionGroup/mu:uuid ?session_group
            }")

(supply-allowed-group "session-group-editor"
  :parameters ("session_group")
  :query "PREFIX ext: <http://mu.semte.ch/vocabularies/ext/>
          PREFIX mu: <http://mu.semte.ch/vocabularies/core/>
          SELECT DISTINCT ?session_group WHERE {
            <SESSION_ID> ext:sessionGroup/mu:uuid ?session_group ;
                ext:sessionRole ?role .
            VALUES ?role { \"ABBDatabankToezicht-DatabankToezichtEditeur\" }
            }")

(grant (read)
  :to-graph (public)
  :for-allowed-group "public")

(grant (read)
  :to-graph (readers)
  :for-allowed-group "session-group")

(grant (write)
  :to-graph (users)
  :for-allowed-group "session-group")

(grant (write)
  :to-graph (editors)
  :for-allowed-group "session-group-editor")