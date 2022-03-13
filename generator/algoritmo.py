import time
from sqlalchemy import create_engine
import pandas as pd
import logging
import psutil
import os

def main():
    logging.basicConfig(format='%(asctime)s %(levelname)s: %(message)s')
    log = logging.getLogger()
    log.setLevel(logging.INFO)

    log.info("Gerando dados")
    dados = [gerar_dado(i) for i in range(10_000, 1_010_000, 10_000)]
    log.info("Enviando dados")
    enviar_dados(dados)

def gerar_dado(n):
    start = time.time()
    acumul = 0
    for i in range(1, n+1):
        acumul += i
    end = time.time()
    memory = psutil.Process(os.getpid()).memory_info().rss
    return { 'iterador': i, 'acumul': acumul, 'time_spent': ((end - start)*1000), 'memory_usage': (memory / 1024) }

def enviar_dados(dados):
    connection_str = "mysql+mysqlconnector://{user}:{password}@{host}/{db}"
    config = {
        "user": "admin",
        "password": "admin",
        "host": "localhost",
        "db":"projeto_pi"
    }
    con = create_engine(connection_str.format(**config))
    df = pd.DataFrame(dados)
    df.to_sql("acumul_acelerate", con=con, if_exists="append", index=False)

if __name__ == "__main__":
    main()