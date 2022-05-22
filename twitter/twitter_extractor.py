from datetime import datetime
import requests
import os
from typing import Generator
import concurrent.futures
import os
import uuid
import json
import pathlib

class TwitterClient():
    def __init__(self, max_pages: int, query: str, start_time: datetime=None, end_time: datetime=None) -> None:
        self.max_pages = max_pages
        self.query = query
        self.start_time = start_time
        self.end_time = end_time
        self.default_date_format = "%Y-%m-%dT%H:%M:%SZ"

    def __auth(self):
        # To set your enviornment variables in your terminal run the following line:
        # export 'BEARER_TOKEN'='<your_bearer_token>'
        return os.environ.get("BEARER_TOKEN")

    def __create_url(self):
        tweet_fields = "tweet.fields=author_id,conversation_id,created_at,id,in_reply_to_user_id,public_metrics,text"
        user_fields = "expansions=author_id&user.fields=id,name,username,created_at"
        if self.start_time and self.end_time:
            filters = f"&start_time={self.start_time.strftime(self.default_date_format)}&end_time={self.end_time.strftime(self.default_date_format)}"
        else:
            filters = ""
        return f"https://api.twitter.com/2/tweets/search/recent?query={self.query}&{tweet_fields}&{user_fields}{filters}"


    def __create_headers(self, bearer_token: str) -> dict:
        return {"Authorization": f"Bearer {bearer_token}"}


    def __connect_to_endpoint(self, url: str, headers: dict) -> dict:
        response = requests.request("GET", url, headers=headers)
        if response.status_code != 200:
            raise Exception(response.status_code, response.text)
        return response.json()

    def __paginate(self, url: str, headers: dict, next_token="") -> Generator[dict, None, None]:
        full_url = f'{url}&next_token={next_token}' if next_token else url
        data = self.__connect_to_endpoint(full_url, headers)
        yield data
        if "next_token" in data.get("meta", {}):
            yield from self.__paginate(url, headers, data["meta"]["next_token"])

    def request_data(self):
        bearer_token = self.__auth()
        url = self.__create_url()
        headers = self.__create_headers(bearer_token)
        for page, json_response in enumerate(self.__paginate(url, headers)):
            print("Data extracted successfully")
            yield json_response
            if page == self.max_pages:
                break


class FileSink:
    def __init__(self, shard_size = 1 << 20, path_prefix="./data", shard_prefix="part", sink_id = uuid.uuid4().hex) -> None:
        self.shard_size = shard_size
        self.path_prefix = os.path.abspath(path_prefix)
        self.shard_prefix = shard_prefix
        self.sink_id = sink_id
        self.current_shard_number = 0
        pathlib.Path(self.path_prefix).mkdir(parents=True, exist_ok=True)
        self.create_shard()
    
    def write_data(self, content):
        if os.path.getsize(self.current_shard) >= self.shard_size:
            self.create_shard()
        with open(self.current_shard, "a") as f:
            f.write(f"{content}\n")
        print(f"Saved {self.current_shard}")
    
    def create_shard(self):
        self.current_shard_number += 1
        filename = f"{self.shard_prefix}-{self.sink_id}{self.current_shard_number}.json"
        path = os.path.join(self.path_prefix, filename)
        self.current_shard = path
        open(self.current_shard, "x").close()

def extract_data(num_pages):
    c = TwitterClient(max_pages=num_pages, query="autism")
    s = FileSink()

    for page in c.request_data():
        s.write_data(json.dumps(page))

def split_tasks(ntasks, tasks_per_worker):
    count = 0
    for _ in range(tasks_per_worker, ntasks, tasks_per_worker):
        count += tasks_per_worker
        yield tasks_per_worker
    yield ntasks - count

def main():
    max_pages = 10
    max_num_workers = 2
    tasks_per_worker = max_pages // max_num_workers
    tasks = split_tasks(max_pages, tasks_per_worker)
    with concurrent.futures.ThreadPoolExecutor(max_workers=max_num_workers) as e:
        futures = [e.submit(lambda : extract_data(t)) for t in tasks]
        for f in concurrent.futures.as_completed(futures):
            print("Done")


if __name__ == "__main__":
    main()