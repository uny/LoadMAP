import csv
import json
import random

def main():
  target_name = '日本百名湯'
  target_in_file = 'onsen02.csv'
  target_out_file = 'onsen.json'
  colors = (0xFF0000, 0x00FF00, 0x0000FF)
  rows = []
  with open(target_in_file) as f:
    reader = csv.reader(f)
    for row in reader:
      rows.append(row)
  rows = rows[1:]
  result = {
    'name': target_name,
    'places': [{'name': row[1], 'latitude': float(row[2]), 'longitude': float(row[3]), 'address': row[4], 'color': random.choice(colors)} for row in rows]
  }
  with open(target_out_file, 'w') as f:
    json.dump(result, f, ensure_ascii=False)
main()
