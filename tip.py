import database

def Ver(arquetipo):
    result = database.Query("""
    SELECT
        texto
    FROM
        tip
    WHERE arquetipo='""" + arquetipo + """' 
    ORDER BY
        RAND()
    LIMIT 3
    """)
    return result
