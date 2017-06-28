
### Q&D driver to demo Faundadb client Hy code

import sys
import os
import ConfigParser
import hy

from fdbops import FdbOps

try:
    dbname = sys.argv[1]
except:
    dbname = 'myfdb'

try:
    dbclas = sys.argv[2]
except:
    dbclas = 'myfdbclass'

def _get_conf(conf, key):
    path = os.path.expanduser(conf)
    if not os.path.isfile(path):
        sys.exit('error: conf file not found: %s' % conf)
    cf = ConfigParser.RawConfigParser()
    cf.read(path)
    return cf.get('misc', key)

def main(dbname, dbclas):
    key = _get_conf('~/.fdbhyconf', 'admin_key')
    fdb = FdbOps(False, dbname, dbclas, key)
    print('Get dbname ...')
    n = fdb.get_dbname()
    print(n)
    print('Creat db ...')
    rt = fdb.dbcreat()
    if rt:
        print(rt)
    print('Creat db class ...')
    rt = fdb.dbcreat_class()
    if rt:
        print(rt)
    print('Creat db index ...')
    rt=fdb.dbcreat_index('dishes100_by_rest',
                         [{"field": ["data", "rest"]}],
                         None,)
    if rt:
        print(rt)
    print('Creat db index w/tags ...')
    rt=fdb.dbcreat_index('dishes100_by_tags_with_rest',
                         [{"field": ["data", "tags"]}],
                         [{"field": ["data", "rest"]}])
    if rt:
        print(rt)
    #fdb.client_factory()
    dish = dict([('rest', 'crackWeAreDonutz'),
    		 ('url',  'ig:djpoo'),
    		 ('name', 'eightball'),
    		 ('price', '$11'),
    		 ('address', 'decatr'),
    		 ('desc', 'crack its not just for breakfast'),
                 ])
    print('Put entry in db ...')
    rt=fdb.put(dish)
    print(rt)
    print('Put tags on entry in db ...')
    rt=fdb.update_tags(rt['ref'], ['tagmemaybe'])
    print(rt)
    print('Get entry in db ...')
    rt=fdb.get("dishes100_by_rest", "crackWeAreDonutz")
    print(rt)
    print('Get entrys by tag in db ...')
    rt=fdb.get_by_tag("dishes100_by_tags_with_rest", "tagmemaybe", 25)
    print(rt)
    
if __name__ == '__main__':
    main(dbname, dbclas)

