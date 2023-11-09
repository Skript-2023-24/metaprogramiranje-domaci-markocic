require 'google_drive'

session = GoogleDrive::Session
          .from_config('client_secrets.json')

class Row
  attr_reader(:cells)

  def initialize(cells)
    @cells = cells
  end

  def add_cell(cell)
    cells << cell
  end

  def[](index)
    puts "here1"
    cells[index]
  end

  def each
    cells.each do |cell|
      yield cell
    end
  end

  def each_with_index
    cells.each_with_index { |e, i| yield e, i }
  end

  def []=(index, value)
    puts "here2"
    cells[index] = value
  end
end

class Cell
  attr_reader(:value)

  def initialize(value)
    @value = value
  end

  def to_s
    @value
  end
end

class Sheet
  include Enumerable
  attr_reader(:worksheet, :session, :array, :map)

  def initialize(session, key)
    @session = session
    @worksheet = session.spreadsheet_by_key(key).worksheets[0]
    @array = create_array
  end

  def row(index)
    arr = []
    i = 0
    for row in array do
      arr[i] = row[index].dup
      i += 1
    end
    arr
  end

  def create_array
    temp = []
    coords = find_sheet_dimensions

    for i in 1..coords[0] do
      row = Row.new([])
      for j in 1..coords[1] do
        row.add_cell(Cell.new(worksheet[i, j]))
      end
      temp << row
    end

    temp
  end

  def each(&block)
    array.each do |row|
      row.each(&block)
    end
  end

  def[](col_name)
    puts "here 3"
    row_by_name(col_name)
  end

  private

  def row_by_name(col_name)
    col_name.gsub! ' ', ''
    col_name.downcase!
    index = 0
    array[0].each_with_index do |cell, i|
      normalized_cell = cell.value.gsub ' ', ''
      normalized_cell.downcase!
      index = i if normalized_cell == col_name
    end
    row(index)
  end

  def normalize_name(name)
    name.gsub! ' ', ''
    name.downcase
  end

  def strip_name(arr)
    temp = arr
    temp.shift
    temp
  end

  def find_sheet_dimensions
    i = 1
    until worksheet[1, i].empty?
      p worksheet[1, i]
      i += 1
    end
    y = i - 1
    i = 1
    until worksheet[i, 1].empty?
      p worksheet[i, 1]
      i += 1
    end
    x = i - 1

    [x, y]
  end
end

sheet = Sheet.new(session, '1qkMlrCTPyVs0pmnXi4dPJxnAwDTL869LdHijnUjIttE')

p sheet.array[0].class
p sheet.array[0][0].class


puts "asdf"
p sheet['prvakolona']
puts "asdf"
p sheet['prvakolona'][1]
puts "asdf"
p sheet['prvakolona'][1] = 100
puts "asdf"
p sheet['prvakolona'][1]
puts "asdf"

# puts "asdf"
# p sheet.row(1)
# puts "asdf"
# sheet.row(1)[1] = 100
# p sheet.row(1)
