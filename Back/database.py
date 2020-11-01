import pymysql
import _creds

def Query(query):
    conn = pymysql.connect(host=_creds.host, port=_creds.port, user=_creds.user, passwd=_creds.pasw, db=_creds.data, client_flag=_creds.client)
    conn_object = conn.cursor()

    conn_object.execute(query)
    str = conn_object.fetchall()

    conn.commit()
    conn.close()

    return str
