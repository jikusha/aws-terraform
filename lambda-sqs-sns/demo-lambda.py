import pandas as pd
 
def handler(event, context):
    print("Hello World")
    data = {
    "calories": [420, 380, 390],
    "duration": [50, 40, 45]
    }

    #load data into a DataFrame object:
    df = pd.DataFrame(data)

    print(df) 