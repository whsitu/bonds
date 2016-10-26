require_relative 'bond'

# Function: Gets the benchmark for all the corporate bonds
# Input:
# => bonds: array of bonds including corporate bonds and government bonds
# Output:
# => Array containing hash of {c: corporate_bond, p: government_bond}
# => Where corporate_bond is of type corporate, and government_bond
# => is the corresponding benchmark
def get_benchmarks(bonds)
  corporate_bonds = Bond.corporate bonds
  government_bonds = Bond.government bonds

  return [] if government_bonds.count == 0 || corporate_bonds.count == 0

  benchmarks = []
  corporate_bonds.each do |c_bond|
    best_g_bond = nil
    best_term_diff = nil
    government_bonds.each do |g_bond|
      new_term_diff = (c_bond.term - g_bond.term).abs
      if !best_term_diff.nil? && new_term_diff > best_term_diff
        break
      else
        best_term_diff = new_term_diff
        best_g_bond = g_bond
      end
    end
    benchmarks.push({c: c_bond, g: best_g_bond})
  end
  return benchmarks
end

def benchmark(c_bond, g_bond)
  return (c_bond.yield_percent - g_bond.yield_percent).to_f / Bond.buffer
end

# Function: Prints a benchmark for a corporate bond
# Input:
# => benchmarks: a hash of {c: corpoate_bond, g: government_bond}
# Output: 
# => prints in the benchmark format
def print_bechmarks(benchmarks)
  puts 'bond,benchmark,spread_to_benchmark'
  benchmarks.each do |bm|
    benchmark_value = benchmark(bm[:c], bm[:g])
    puts "#{bm[:c].name},#{bm[:g].name},#{benchmark_value}%"
  end
end

# Only run the benchmark when an argument is given
if ARGV[0]
  bonds = Bond.create_from_file(ARGV[0])
  benchmarks = get_benchmarks(bonds)
  print_bechmarks(benchmarks)
end