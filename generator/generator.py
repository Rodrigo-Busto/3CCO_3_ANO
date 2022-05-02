import time
from datetime import datetime, timedelta
from sqlalchemy import create_engine
import pandas as pd
import logging
import json
import random
from os import environ
import memory_profiler as mp


def main():
    logging.basicConfig(format="%(asctime)s %(levelname)s: %(message)s")
    log = logging.getLogger()
    log.setLevel(logging.INFO)

    log.info("Gerando dados")
    dados = [gerar_dado(i) for i in range(10_000, 1_010_000, 10_000)]
    log.info("Enviando dados")
    enviar_dados(dados)


def gerar_dado(n):
    start = time.time()
    memory = 0

    country = random_country()
    gender = random.choice(["M", "F"])
    birthday = random_date_between(datetime(2005, 1, 1), datetime(2016, 12, 31))
    score = random.randint(1, 53)
    autism = random_autism_from_score(score)
    end = time.time()
    memory = round(mp.memory_usage()[0], 2)
    return {
        "score": score,
        "autism": autism,
        "gender": gender,
        "birthday": birthday,
        "country": country,
        "time_spent": ((end - start) * 1000),
        "memory_usage": memory,
    }


def random_country():
    with open("countries.json") as f:
        locations = json.load(f)
    return random.choice(locations)["code"]


def random_date_between(start_date: datetime, end_date: datetime):
    delta = end_date - start_date
    random_delta = random.randrange(delta.total_seconds())
    return start_date + timedelta(seconds=random_delta)


def random_autism_from_score(score):
    autism_possible = 14
    false_positive = random.randint(1, 100)
    false_positive_rate = 22
    if score > autism_possible and false_positive < false_positive_rate:
        autism = True
    elif score <= autism_possible:
        autism = False
    else:
        true_positive_rate = 90
        autism = random.randint(1, 100) < true_positive_rate
    return autism


def enviar_dados(dados):
    connection_str = "mysql+mysqlconnector://{user}:{password}@{host}/{db}"
    config = {
        "user": environ.get("DB_USER", "admin"),
        "password": environ.get("DB_PASSWORD", "admin"),
        "host": environ.get("DB_HOST", "localhost"),
        "db": environ.get("DB_NAME", "projeto_pi"),
    }
    con = create_engine(connection_str.format(**config))
    df = pd.DataFrame(dados)
    df.to_sql("autism_screening", con=con, if_exists="append", index=False)


if __name__ == "__main__":
    main()
