Coord = Struct.new(:x, :y) do
  def self.cardinal_dirs = [
    Coord[0, -1],
    Coord[1, 0],
    Coord[0, 1],
    Coord[-1, 0]
  ]

  def self.[](x, y)
    Coord.new(x, y)
  end

  def +(other)
    Coord.new(x + other.x, y + other.y)
  end

  def -(other)
    Coord.new(x - other.x, y - other.y)
  end

  def rotate_clockwise
    Coord.new(-y, x)
  end

  def rotate_anticlockwise
    Coord.new(y, -x)
  end

  def to_s
    "(#{x},#{y})"
  end

  def inspect
    "Coord[#{x},#{y}]"
  end
end

class Grid2D
  def initialize(cells, visualizations = nil)
    @cells = cells
    @visualizations = visualizations
  end

  def width
    if @cells.empty?
      0
    else
      @cells[0].size
    end
  end

  def height
    @cells.size
  end

  def [](coord)
    @cells[coord.y][coord.x]
  end

  def []=(coord, value)
    @cells[coord.y][coord.x] = value
  end

  def each_coord(&block)
    return enum_for(:each_coord) unless block_given?

    height.times do |y|
      width.times do |x|
        yield Coord.new(x, y)
      end
    end
  end

  def in_bounds?(coord)
    coord.y >= 0 && coord.y < height && coord.x >= 0 && coord.x < width
  end

  def to_s
    @cells.map do |row|
      row.map do |cell|
        if @visualizations.nil?
          cell
        else
          @visualizations[cell]
        end
      end.join('')
    end.join("\n")
  end
end