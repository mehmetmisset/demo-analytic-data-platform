import pandas as pd
url = 'https://finance.yahoo.com/quote/O/history/?period1=0&period2=1742674939&filter=history'
df = pd.read_html(url)[0]
print(df)