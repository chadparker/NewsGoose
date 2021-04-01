import os
from datetime import date
from datetime import timedelta
import json
import requests

ignore_existing_files = True
js_dir = 'js'

os.makedirs(js_dir, exist_ok=True)

def saveFile(path_temp, path):
    print(f'Saving {filepath}')
    with open(path_temp, 'w') as tmp:
        tmp.write(response.text)
        tmp.flush()
        os.fsync(tmp.fileno())
    os.rename(path_temp, path)

currentDay = date.today()
oldestDay = date(2010, 6, 9)
while currentDay >= oldestDay:
    dateStr = currentDay.strftime('%Y%m%d')
    url = f'https://hckrnews.com/data/{dateStr}.js'
    filepath_temp = f'{js_dir}/{dateStr}.temp'
    filepath =      f'{js_dir}/{dateStr}.js'

    if ignore_existing_files:
        if not os.path.exists(filepath):
            response = requests.get(url)
            if response.status_code == 200:
                saveFile(filepath_temp, filepath)
            else:
                print(f'Finding newest existing .js file ({response.status_code})')
    else: # updating existing files
        response = requests.get(url)
        if response.status_code == 200:
            try:
                with open(filepath) as f:
                    if json.load(f) == response.json():
                        print(f'{filepath} exists, new data is equal')
                    else:
                        print(f'{filepath} exists, new data differs, saving to file')
                        saveFile(filepath_temp, filepath)
            except FileNotFoundError:
                saveFile(filepath_temp, filepath)
        else:
            print(f'Finding newest existing .js file ({response.status_code})')


    currentDay = currentDay - timedelta(days=1)

    