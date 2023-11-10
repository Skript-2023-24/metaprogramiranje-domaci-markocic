class Sheet
  include Enumerable
  attr_reader(:worksheet, :array)

  def initialize(session, key, index)
    @worksheet = session.spreadsheet_by_key(key).worksheets[index]
    @worksheet_index = index
    create_array
  end

  def row(index)
    arr = []

    (@array.length).times do |i|
      arr << @array[i][index]
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
        if @array[i].cells[j].include? "total"
          remove_row(j)
          break
        end
      end
    end
  end

  def find_table
    worksheet.num_cols.times do |i|
      worksheet.num_rows.times do |j|
        return [i + 1, j + 1] unless worksheet[i + 1, j + 1].empty?
      end
    end
  end

  def each
    (@array[0].cells.length - 1).times do |i|
      row(i).each do |cell|
        yield cell
      end
    end
  end

  def[](col_name)
    column_by_name(col_name)
  end

  def method_missing(key, *_args)
    column_by_name(key.to_s)
  end

  def remove_row(index)
    array.each do |col|
      col.cells.delete_at(index)
    end
  end

  private

  def column_by_name(col_name)
    col_name = normalize_name(col_name)
    array.each do |column|
      return column if col_name == normalize_name(column.name)
    end
    nil
  end

  def normalize_name(name)
    name.gsub! ' ', ''
    name.downcase
  end
end
