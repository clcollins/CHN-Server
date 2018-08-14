from mhn import create_clean_db
from mhn import mhn, db
from sqlalchemy import create_engine
from sqlalchemy import inspect
import sys

if __name__ == '__main__':

    uwsgi_port = 8080

    uwsgi_init = ['uwsgi',
                  ('--http %d' % uwsgi_port),
                  '--module mhn:mhn',
                  '--buffer-size 04096']

    with mhn.test_request_context():
        inspector = inspect(db.engine)
        if 'user' in inspector.get_table_names():
            print("Database already initialized")
        else:
            print("Initializing new database")
            create_clean_db()
            
    print("Starting uwsgi...")
    print("Listening :%d" % uwsgi_port)
    os.execv('uwsgi', uwsgi_init)