from contextlib import contextmanager


def _dict_factory(cursor, row):
    d = {}
    for idx,col in enumerate(cursor.description):
        d[col[0]] = row[idx]
    return d


@contextmanager
def _connection(config):
    conn = None
    try:
        if config.DB_BACKEND == 'mysql':
            from torndb import Connection
            conn = Connection(
                "%s:%s" % (config.DB_HOST, config.DB_PORT),
                config.DB_NAME,
                user=config.DB_USER,
                password=config.DB_PASS
            )
        elif config.DB_BACKEND == 'sqlite':
            import sqlite3
            conn = sqlite3.connect(config.DB_NAME)
            conn.row_factory = _dict_factory
        elif config.DB_BACKEND == 'postgres':
            import psycopg2
            from psycopg2.extras import DictConnection

            conn = psycopg2.connect(
                database=config.DB_NAME,
                user=config.DB_USER,
                password=config.DB_PASS,
                host=config.DB_HOST,
                port=config.DB_PORT,
                connection_factory=DictConnection,
            )
        else:
            raise ValueError("Unknown backend %r" % config.DB_BACKEND)

        yield conn
    finally:
        if conn is not None:
            conn.close()


def query(query, config):
    with _connection(config) as conn:
        if config.DB_BACKEND == 'mysql':
            return conn.query(query)
        else:
            cur = conn.cursor()
            cur.execute(query)
            return list(cur.fetchall())
