# frozen_string_literal: true

# Comment to satisfy rubocop
class Sheet
  include Enumerable
  attr_reader(:worksheet, :array)

  def initialize(session, key, index)
    @worksheet = session.spreadsheet_by_key(key).worksheets[index]
    @worksheet_index = index
    create_array
  end

  def row(index)
    to_array.transpose[index]
  end

  def to_array
    arr = []
    @array.each do |column|
      col = []
      column.each do |cell|
        col << cell
      end
      arr << col
    end
    arr
  end

  def create_array
    @array = []

    table = find_table

    (worksheet.num_cols - table[1] + 1).times do
      @array << Column.new(self, [])
    end

    (table[1]..worksheet.num_cols).each do |i|
      (table[0]..worksheet.num_rows).each do |j|
        @array[i - table[1]].add_cell(worksheet[j, i]) unless worksheet[j, i] == ''
      end
    end
    filter_total
  end

  def filter_total
    @array.length.times do |i|
      @array[0].cells.length.times do |j|
        if @array[i].cells[j].include? 'total'
          remove_row(j)
          break
        end
      end
    end
  end

  def +(other)
    raise ArgumentError, "Headers are not the same" unless operable?(other)

    @array.length.times do |i|
      @array[i] += other.array[i]
    end
    self
  end

  def -(other)
    raise ArgumentError, "Headers are not the same" unless operable?(other)

    @array.length.times do |i|
      @array[i] -= other.array[i]
    end
    self
  end

  def operable?(other)
    return false unless other.is_a? Sheet

    @array.length.times do |i|
      return false unless @array[i].name == other.array[i].name
    end
    true
  end

  def find_table
    worksheet.num_cols.times do |i|
      worksheet.num_rows.times do |j|
        return [i + 1, j + 1] unless worksheet[i + 1, j + 1].empty?
      end
    end
  end

  def each(&)
    (@array[0].cells.length - 1).times do |i|
      row(i).each(&)
    end
  end

  def[](col_name)
    column_by_name(col_name)
  end

  def method_missing(key, *_args)
    column_by_name(key.to_s)
  end

  def respond_to_missing?
    true
  end

  def remove_row(index)
    array.each do |col|
      col.cells.delete_at(index)
    end
  end

  private

  def column_by_name(col_name)
    col_norm = normalize_name(col_name)
    array.each do |column|
      return column if col_norm == normalize_name(column.name)
    end
    raise ArgumentError, "Column with the name #{col_name} could not be found"
  end

  def normalize_name(name)
    (name.gsub ' ', '').downcase
  end
end
