== Solution
# Install
- gem install test-unit

# CSV
- csv library is used to convert input from file into bonds

# test_unit
- For testing core functions

# Assumptions
1. Bond
  - Input contains valid name, type, term, and yield
  - Term and Yield has less than 5 decimal places (Detail on Bond::Buffer)
2. Benchmark
  - The yield to use doesn't matter if Government Bonds with same term occurs
3. Spread
  - Government bonds terms are all unique

# Exceptions
- A few functions raises ArgumentException when certain conditions are met
- These exceptions will raise if some of the assumptions are not met

# Bond
1. Buffer
  - A buffer of 10000 is used to turn term and yield values into integers (Bond Assumption)
  - The reason behind is that calculating with float will result in some weird rounding errors
  - Using integers prevents such problem
2. Sorting Government Bonds by Term
  - Government bonds are sorted by term when they are fetched
  - This sorting allows Benchmark and Spread to have simpler logic
  - Not sorting will break the code
3. Test
  - ruby test/bond_test.rb 

# Challenge 1
1. Execution
  - ruby benchmark.rb <input_file_name>
  - Example: ruby benchmark.rb sample_input.csv
2. Test
  - ruby test/benchmark_test.rb 

# Challenge 2
1. Execution
  - ruby spread.rb <input_file_name>
  - Example: ruby spread.rb sample_input.csv
2. Test
  - ruby test/spread_test.rb

# Improvements
- Create a class for bonds[] or use ActiveRecord to dry up the code
- Use a bindary tree for Government Bonds instead of a sorted array to reduce time for Benchmark from O(n^2) to O(nlog(n))