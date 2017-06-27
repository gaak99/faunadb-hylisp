
;;; Basic FaunaDB ops class in Hy lang.
;;; Probably certainly not a complete set of FaunaDB ops.

(import sys)
(import os)
(import json)
(import itertools)

(import [faunadb.client [FaunaClient]])
(import [faunadb.objects
         [FaunaTime Ref SetRef _Expr]])
(import [faunadb
         [query :as q]])
(import [faunadb.errors [UnexpectedError]])
(import [faunadb.errors
         [BadRequest NotFound]])

(defclass FdbOps [object]
  "Basic Faunadb Ops, probably not a complete set."

  (defn --init-- [self debug dbname dbclass key]
    (setv self.debug debug)
    (setv self.dbname dbname)
    (setv self.dbclass dbclass)
    (setv self.key key)
    (setv self.adminClient (FaunaClient key))
    (setv self.client None))

  (defn get-dbname [self]
    "Return our copy of x"
    self.dbname)

  (defn _debug [self s]
    "Return our copy of x"
    (print "debug: " s))

  (defn client-factory [self]
    "get fdb client handle"
    (self._debug "client_factory: begin")
    (setv dbdct {})
    (assoc dbdct
           "database" (q.database self.dbname)
           "role" "server")
    (setv self.client
          (-> (q.create_key dbdct)
              (self.adminClient.query)
              (get "secret")
              (FaunaClient)))
    (self._debug "client_factory: end"))

  (defn put [self dct]
    (self._debug "put: begin")
    (if-not self.client
            (self.client_factory))
    (setv rt None)
    (setv datadct {})
    (assoc datadct
           "data" dct)
    (try
     (setv rt
          (-> (q.class_expr self.dbclass)
              (q.create datadct)
              (self.client.query)))
     (except [e [BadRequest]]
       (print "warning: put  " % e))
     (except [e [UnexpectedError]]
       (print "error: put " % e)
       (sys.exit)))
    (self._debug "put: end")
    rt)

  (defn update-tags [self ref tags]
    (self._debug "update-tags: begin")
    (if-not self.client
            (self.client_factory))
    (setv rt None)
    (setv datadct {})
    (assoc datadct
           "data" {"tags" tags})
    (try
     (setv rt
          (self.client.query
           (q.update ref datadct)))
     (except [e [NotFound]]
       (print "warning: update-tags " % e))
     (except [e [UnexpectedError]]
       (print "error: update-tags " % e)
       (sys.exit)))
    (self._debug "update-tags: end")
    rt)

  (defn get [self idx string]
    (self._debug "get: begin")
    (if-not self.client
            (self.client_factory))
    (try
     (setv rt
          (-> (q.index idx)
              (q.match string)
              (q.get)
              (self.client.query)))
     (except [e [NotFound]]
       (print "warning: get " % e))
     (except [e [UnexpectedError]]
       (print "error: dbcreat " % e)
       (sys.exit)))
    (self._debug "get: end")
    rt)

  (defn get_by_tag [self idx string size]
    (self._debug "get_by_tag: begin")
    (if-not self.client
            (self.client_factory))
    (setv rt None)
    (try
     (setv rt
           (-> (q.index idx)
               (q.match string)
               (q.paginate)
               (self.client.query)))
     (except [e [NotFound]]
       (print "warning: get_by_tag " % e))
     (except [e [UnexpectedError]]
       (print "error: get_by_tag " % e)
       (sys.exit)))
    rt)

  (defn dbcreat [self]
    (self._debug "dbcreat: begin")
    (setv rt None)
    (setv dbdct {})
    (assoc dbdct "name" self.dbname)
    (try
     (setv rt
           (self.adminClient.query (q.create_database dbdct)))
     (except [e [BadRequest]]
       (print "warning: dbcreat " % e))
     (except [e [UnexpectedError]]
       (print "error: dbcreat " % e)
       (sys.exit)))
    (self._debug "dbcreat: end")
    rt)

  (defn dbcreat_class [self]
    (self._debug "dbcreat_class: begin")
    (if-not self.client
            (self.client_factory))
    (setv rt None)
    (setv dbdct {})
    (assoc dbdct "name" self.dbclass)
    (try
     (setv rt
           (self.client.query (q.create_class dbdct)))
     (except [e [BadRequest]]
       (print "warning: dbcreat_class " % e))
     (except [e [UnexpectedError]]
       (print "error: dbcreat_class " % e)
       (sys.exit)))
    (self._debug "dbcreat_class: end")
    rt)

  (defn dbcreat_index [self name terms values]
    (self._debug "dbcreat_index: begin")
    (if-not self.client
            (self.client_factory))
    (setv rt None)
    (setv dbdct {})
    (assoc dbdct
           "name" name
           "source" (q.class_expr self.dbclass)
           "terms" terms)
    (try
     (setv rt
           (self.client.query (q.create_index dbdct)))
     (except [e [BadRequest]]
       (print "warning: dbcreat_index " % e))
     (except [e [UnexpectedError]]
       (print "error: dbcreat_index " % e)
       (sys.exit)))
    (self._debug "dbcreat_index: end")
    rt))
