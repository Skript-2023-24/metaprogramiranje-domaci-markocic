require 'google_drive'
require './Column'
require './Sheet'

session = GoogleDrive::Session
          .from_config('client_secrets.json')

sheet = Sheet.new(session, '1qkMlrCTPyVs0pmnXi4dPJxnAwDTL869LdHijnUjIttE', 0)

p sheet.array

p sheet['prvakolona']
p sheet['prvakolona'][1]
p sheet['prvakolona'][1] = 100
p sheet['prvakolona'][1]

# p sheet.prvakolona
# p sheet.prvakolona.sum
# p sheet.prvakolona.avg
# p sheet.drugaKolona
#
p sheet.indeks.rn9922
p sheet.indeks.asdf

p sheet.worksheet.num_cols
p sheet.worksheet.num_rows
