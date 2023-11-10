class Sheet
  include Enumerable
  attr_reader(:worksheet, :session, :array)

  def initialize(session, key, index)
    @session = session
    @worksheet = session.spreadsheet_by_key(key).worksheets[index]
    @worksheet_index = index
    create_array
  end

  def row(index)
    arr = []

    (0..array.length - 1).each do |i|
      arr << array[i][index]
    end

    arr
  end

  def create_array
    @array = []

    (1..worksheet.num_cols).each do |i|
      next if worksheet[1, i] == ''

      @array << Column.new(self, [])
    end

    (1..worksheet.num_rows).each do |i|
      (1..worksheet.num_cols).each do |j|
        @array[j - 1].add_cell(worksheet[i, j])
      end
    end
  end

  def each(&block)
    array.each do |row|
      row.each(&block)
    end
  end

  def[](col_name)
    column_by_name(col_name)
  end

  def method_missing(key, *args)
    column_by_name(key.to_s)
  end

  private

  def column_by_name(col_name)
    col_name = normalize_name(col_name)
    array.each do |column|
      return column if col_name == normalize_name(column.name)
    end
  end

  def normalize_name(name)
    name.gsub! ' ', ''
    name.downcase
  end
end
