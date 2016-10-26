require 'csv'

# The Bond Class
class Bond
  attr_accessor :name, :type, :term, :yield_percent

  # array containing the accepted bond types
  @@types = ['corporate', 'government']

  # Buffer for turning yield and term to integer
  @@buffer = 10000

  def initialize(name, type, term, yield_percent)
    raise(ArgumentError, "Invalid Type: #{type}", caller) if !@@types.include?(type) || type.nil?
    raise(ArgumentError, "Name is required", caller) if name.nil?
    raise(ArgumentError, "Term is required", caller) if term.nil?
    raise(ArgumentError, "Yield is required", caller) if yield_percent.nil?

    @name = name
    @type = type
    @term = (term.gsub(' years', '').to_f * @@buffer).to_i
    @yield_percent = (yield_percent.gsub('%', '').to_f * @@buffer).to_i
  end

  # For my own use of manual testing
  def print
    puts "Bond: #{@name}, Type: #{@type}, Term: #{@term}, Yield: #{@yield_percent}"
  end

  @@types.each do |type|
    # function: provide methods that check if a bond is specific type
    # Example: bond.corporate? and bond.government?
    define_method "#{type}?" do
      return type == @type
    end
  end

  class << self
    # access Buffer
    def buffer
      @@buffer
    end

    @@types.each do |type|
      # function: provide methods that gets a specific type of bonds from array
      # example: 'Bond.corporate bonds' returns array of corporate bonds
      define_method "#{type}" do |bonds|
        typed_bonds = bonds.select{|bond| bond.send("#{type}?")}
        if type == 'government'
          # government bonds are sorted
          return typed_bonds.sort_by{|bond| bond.term}
        else
          return typed_bonds
        end
      end
    end

    # function: create an array of bonds from given file
    # input: 
    # => input: file name
    # output:
    # => array of bonds
    def create_from_file(input)
      bonds = []
      CSV.foreach(File.path(input), headers: true) do |row|
        bonds.push Bond.new(row['bond'], row['type'], row['term'], row['yield'])
      end
      return bonds
    end
  end
end