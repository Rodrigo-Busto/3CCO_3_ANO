import json
from typing import List
import apache_beam as beam
from apache_beam.options.pipeline_options import PipelineOptions
from apache_beam.typehints import Dict, Any, Generator

def run():
    stopwords = load_stopwords()
    lexicon = load_lexicon()
    output_header = "classification,count"
    options = PipelineOptions()
    with beam.Pipeline(options=options) as p:
        (
            p
            | "Reading files" >> beam.io.ReadFromText("./data/part-*.json")
            | "Parsing lines" >> beam.ParDo(ParserFn())
            | "Remove unused fields" >> beam.ParDo(SelectFieldsFn())
            | "Tokenize words" >> beam.ParDo(TokenizeFn())
            | "Remove special characters" >> beam.ParDo(RemoveSpecialCharacters())
            | "Filter stopwords" >> beam.ParDo(FilterStopWordsFn(stopwords=stopwords))
            | "Classify words" >> beam.ParDo(ClassifyFn(lexicon=lexicon))
            | "Count classifications" >> beam.combiners.Count.PerKey()
            | "Parse to CSV" >> beam.ParDo(ParseToCsvFn())
            | "Save result" >> beam.io.WriteToText("./data/gold/sentiment-analysis", file_name_suffix=".csv", header=output_header)
        )

class ParserFn(beam.DoFn):
    def process(self, element: str) -> Generator[dict, None, None]:
        yield json.loads(element)

class SelectFieldsFn(beam.DoFn):
    def process(self, element: Dict[str, Any]) -> Generator[dict, None, None]:
        yield from element["data"]

class TokenizeFn(beam.DoFn):
    def process(self, element: Dict[str, Any]) -> Generator[tuple, None, None]:
        yield element["text"].split()

class RemoveSpecialCharacters(beam.DoFn):
    def process(self, element):
        for word in element:
            yield ''.join(w for w in word.lower() if w.isalnum()) 
class FilterStopWordsFn(beam.DoFn):
    def __init__(self, stopwords: List):
        super().__init__()
        self.stopwords = stopwords

    def process(self, element):
        if element not in self.stopwords:
            yield element

def load_stopwords():
    with open("./stopwords.txt", "r") as f:
        lines = f.readlines()
    return [l.replace("\n", "") for l in lines]

class ClassifyFn(beam.DoFn):
    def __init__(self, lexicon: dict):
        super().__init__()
        self.lexicon = lexicon
    
    def process(self, element):
        polarity = self.lexicon.get(element, "neutral")
        yield (polarity, element)

def load_lexicon():
    with open("./lexicon.txt") as f:
        lines = f.readlines()
    lexicon = {}
    for l in lines:
        splited = l.split()
        word, polarity = splited[2], splited[5]
        word, polarity = word.split("=")[1], polarity.split("=")[1]
        lexicon[word] = polarity
    return lexicon

class ParseToCsvFn(beam.DoFn):
    def process(self, element):
        yield ",".join([str(e) for e in element])

if __name__ == "__main__":
    run()