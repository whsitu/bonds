require_relative 'bond'

# function: Get the segment of government bonds containing the corporate bond
# input:
# => government_bonds: array of government bonds
# => corporate_bond: a bond of corporate type
# ouput:
# => a segment of two government bonds where the the term is consercutive
# => consecutive means no other bonds has a term within the two bonds
def government_bonds_segment(government_bonds, corporate_bond)
  first_greater_gov_bond = government_bonds.find_index{|bond| bond.term >= corporate_bond.term}

  raise(ArgumentError, 'All government bonds have lesser term', caller) if first_greater_gov_bond.nil?

  segment = government_bonds[first_greater_gov_bond-1, 2]

  raise(ArgumentError, "Government bonds doesn't have a segment containing the corporate_bond") if segment.size < 2

  return segment
end

# function: gets the slope of a segment
# input:
# => seg: a segment containing two bonds
# output:
# => the slope calculated using yield_percent as Y and term as X
def slope(seg)
  bond1, bond2 = seg[0], seg[1]
  yield_diff = bond2.yield_percent - bond1.yield_percent
  term_diff = bond2.term - bond1.term

  raise(ArgumentError, 'Divide by zero', caller) if term_diff == 0

  slope = yield_diff.to_f / term_diff.to_f
end

# function: gets the intercept of the linear function
# input:
# => slope: the slope of the linear function
# => bond: the point in the linear function
# output:
# => the intercept of the linear function of bonds
def intercept(slope, bond)
  bond.yield_percent - bond.term * slope 
end

# function: gets the expected value of the corporate bond
# input:
# => seg: the segment containing two government bonds
# => c_bond: the corporate bond
# output:
# => The expected yield value of the corporate bond within the segment
def expected_yield(seg, c_bond)
  g_slope = slope(seg)
  g_intercept = intercept(g_slope, seg[0])
  g_yield = g_slope * c_bond.term + g_intercept
end

# function: gets the spread
# input:
# => c_yield: yield of the corporate bond
# => expected_yield: expected yield of the corporate bond
# output:
# => The spread for the corporate bond
def spread_to_curve(c_yield, expected_yield)
  ((c_yield - expected_yield) / Bond.buffer).round(2)
end

# function: prints out the spread of all the corporate bonds
# input:
# => bonds: bonds containing coporate and government bonds
# output:
# => prints the spread for corporate bonds
def spread(bonds)
  corporate_bonds = Bond.corporate bonds
  government_bonds = Bond.government bonds

  puts 'bond,spread_to_curve'
  return if government_bonds.count == 0

  corporate_bonds.each do |c_bond|
    seg = government_bonds_segment(government_bonds, c_bond)
    c_expected_yield = expected_yield(seg, c_bond)
    c_spread_to_curve = spread_to_curve(c_bond.yield_percent, c_expected_yield)
    puts "#{c_bond.name},#{c_spread_to_curve}%"
  end
end

# Only run the benchmark when an argument is given
if ARGV[0]
  bonds = Bond.create_from_file(ARGV[0])
  spread(bonds)
end