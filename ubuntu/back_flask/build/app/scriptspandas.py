import pandas as pd

class ScriptsPandas:
    
    def __init__(self, url):
        self.url = url
        self.setDataFrame(url)

    def getDataFrame(self):
        return self.data
    
    def setDataFrame(self,url):
        self.data = pd.read_csv(url)

    def getFilter(self, column, value):
        return self.data[self.data[column].isin([value])]

    def toJson(self):
        return self.data.to_json(orient='index')
