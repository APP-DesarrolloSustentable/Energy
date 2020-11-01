import database

def Ver():
    result = database.Query("""
    SELECT
        texto
    FROM
        tip
    ORDER BY
        RAND()
    LIMIT 1
    """)
    return result
