# frozen_string_literal: true

require 'google_drive'
require './column'
require './sheet'

session = GoogleDrive::Session
          .from_config('client_secrets.json')

sheet = Sheet.new(session, '1qkMlrCTPyVs0pmnXi4dPJxnAwDTL869LdHijnUjIttE', 0)

#### 1.
# p sheet.array
# pp sheet.to_array
#### 2.
# # ispisi red sa indeksom 1
# pp sheet.row(1)
# pp sheet.row(1)[1]
#### 3.
# # ispisi sa leva na desno, sadrzaj tabele
# sheet.each do |cell|
#   p cell
# end
#### 4.
# vodi
#### 5.
# moguce je pristupiti celoj koloni po imenu kolone
# ignorise razmake i case-insensitive je
# pp sheet['prva Kolona']
# puts sheet['prvakolona']
# p sheet['prvakolona'].cells
# p sheet['prvakolona'].name
# puts "Pre promene"
# p sheet['prvakolona'][1]
# sheet['prvakolona'][1] = 100
# puts "Posle promene"
# p sheet['prvakolona'][1]
#### 6.
# t.prvaKolona, t.prvaKolona.sum itd.
# pp sheet.prvakolona
# pp sheet.prvakolona.sum
# p sheet.prvakolona.avg
# p sheet.drugaKolona
# p sheet.indeks.rn9922
# p sheet.indeks.asdf

#### 6. iii map primer, duplira sve brojeve, sta nije bice 0
# test = sheet.prvaKolona.map do |e|
#   e.to_i * 2 if e.to_i != 0
# end
# p test

#### 6. iii select primer, uzima sve parne "brojeve"
# test = sheet.drugaKolona.select do |e|
#   e.to_i % 2 == 0 && e.to_i != 0
# end
# p test
#### 6. iii reduce primer
# test = sheet.drugakolona.reduce(:+)
# p test

#### 7. ignorise redove koji sadrze rec total i subtotal

#### 8. sabiranje tabela
# sheet2 = Sheet.new(session, '1qkMlrCTPyVs0pmnXi4dPJxnAwDTL869LdHijnUjIttE', 1)
# pp sheet + sheet2

#### 9. oduzimanje tabela
# pp sheet - sheet2

#### 10. biblioteka prepoznaje prazne redove i ignorise
