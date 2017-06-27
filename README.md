# Intro

Putting the fun in the FaunaDB client functional API ...

## MO

I'm using the new and kewl FaunaDB in a small personal project.  And using the Python client lib to boot.

But Python does not really do justice to the FaunaDB fuctional style API aka it really SHOUTS use a Lisp.

My first inclination was to start a small proj to hackup a quick Scheme based one.

ButButBut it then hit me that maybe this is perfect for Hy the lispy Python. 

I've not used Hy before and was keen to try it so double rainbow here.

## Hy/Lisp bene

### FaunaDB python

This is the basic style I got from the FaunaDB tutorial.

```python
# get/match by title'
rt = client.query(
    q.get(
        q.match(
            q.index(idx),
            title
        )
    ))
```

### Hy

Equiv Hy code -- much prettier eh?

```hy
(setv rt
      (-> (q.index idx)
          (q.match title)
          (q.get)
          (self.client.query)))
```

And using the fancy threading macro (ala Clojure) probably makes it more readable to boot.

## Notes

1. This just a basic Proof of Concept and is not a complete set of FaunaDB ops in Hy.
2. Thus minimally tested.
3. The FdbOps class should be a child class of a generic db class but for this demo ok.

## Run demo
```bash
python faunadb-hylisp/fdbhy-demo.py  <dbname> <dbclass>
```

### Sample run
```bash
python faunadb-hylisp/fdbhy-demo.py  dbhy3 dishes100
Get dbname ...
dbhy3
Creat db ...
debug:  dbcreat: begin
warning: dbcreat  <function % at 0x7ff289227ed8> Instance is not unique.
debug:  dbcreat: end
Creat db class ...
debug:  dbcreat_class: begin
debug:  client_factory: begin
debug:  client_factory: end
warning: dbcreat_class  <function % at 0x7ff289227ed8> Instance is not unique.
debug:  dbcreat_class: end
Creat db index ...
debug:  dbcreat_index: begin
warning: dbcreat_index  <function % at 0x7ff289227ed8> Instance is not unique.
debug:  dbcreat_index: end
Creat db index w/tags ...
debug:  dbcreat_index: begin
warning: dbcreat_index  <function % at 0x7ff289227ed8> Instance is not unique.
debug:  dbcreat_index: end
Put entry in db ...
debug:  put: begin
debug:  put: end
{u'data': {u'name': u'eightball', u'url': u'ig:djpoo', u'price': u'$11', u'rest': u'crackWeAreDonutz', u'address': u'decatr', u'desc': u'crack its not just for breakfast'}, u'ref': Ref(u'classes/dishes100/170213319484899854'), u'class': Ref(u'classes/dishes100'), u'ts': 1498586921095000}
Put tags on entry in db ...
debug:  update-tags: begin
debug:  update-tags: end
{u'data': {u'name': u'eightball', u'tags': [u'tagmemaybe'], u'url': u'ig:djpoo', u'price': u'$11', u'rest': u'crackWeAreDonutz', u'address': u'decatr', u'desc': u'crack its not just for breakfast'}, u'ref': Ref(u'classes/dishes100/170213319484899854'), u'class': Ref(u'classes/dishes100'), u'ts': 1498586921304000}
Get entry in db ...
debug:  get: begin
debug:  get: end
{u'data': {u'name': u'eightball', u'tags': [u'tagmemaybe'], u'url': u'ig:djpoo', u'price': u'$11', u'rest': u'crackWeAreDonutz', u'address': u'decatr', u'desc': u'crack its not just for breakfast'}, u'ref': Ref(u'classes/dishes100/170123027939328517'), u'class': Ref(u'classes/dishes100'), u'ts': 1498500812516000}
Get entrys by tag in db ...
debug:  get_by_tag: begin
{u'data': [Ref(u'classes/dishes100/170123027939328517'), Ref(u'classes/dishes100/170132688033808900'), Ref(u'classes/dishes100/170132903383007747'), Ref(u'classes/dishes100/170132957929931269'), Ref(u'classes/dishes100/170213319484899854')]}
```
