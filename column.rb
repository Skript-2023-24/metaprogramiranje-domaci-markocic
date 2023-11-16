# frozen_string_literal: true

# comment
class Column
  include Enumerable
  attr_reader(:cells)

  def initialize(sheet, cells)
    @sheet = sheet
    @cells = cells
  end

  def add_cell(cell)
    cells << cell
  end

  def name
    cells[0]
  end

  def[](index)
    cells[index + 1]
  end

  def each(&block)
    cells.each(&block)
  end

  def each_with_index(&block)
    cells.each_with_index(&block)
  end

  def []=(index, value)
    cells[index + 1] = value
  end

  def method_missing(key, *_args)
    i = 0

    cells.each do |cell|
      break if key.to_s == cell.to_s

      i += 1
    end

    @sheet.row(i)
  end

  def respond_to_missing?(name, _include_private = false)
    name != :to_ary
  end

  def to_s
    cells.to_s
  end

  def sum
    cells.map(&:to_i).reduce(:+)
  end

  def avg
    sum / (cells.length - 1).to_f
  end

  def +(other)
    @cells + other.cells
  end

  def -(other)
    @cells - other.cells
  end
end
