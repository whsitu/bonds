require_relative '../benchmark'
require 'test/unit'

class BenchmarkTest < Test::Unit::TestCase
  def test_benchmark
    p1, p2 = 10.0, 13.0
    c1, g1 = 
      Bond.new('c1', 'corporate', '9 years', "#{p1}%"),
      Bond.new('g1', 'government', '11 years', "#{p2}%")
    benchmark_value = benchmark(c1, g1)
    assert_equal(benchmark_value, (p1 - p2).round(2))
  end

  def test_get_benchmark_with_bonds
    c1, g1, g2 = 
      Bond.new('c1', 'corporate', '9 years', '10.0%'),
      Bond.new('g1', 'government', '11 years', '13.0%'),
      Bond.new('g2', 'government', '10 years', '15.0%')
    bonds = [c1, g1, g2]

    benchmarks = get_benchmarks(bonds)
    assert_equal benchmarks.count, 1
    assert_not_nil benchmarks.first
    assert_equal benchmarks.first[:c], c1
    assert_equal benchmarks.first[:g], g2
  end

  def test_get_benchmark_no_government_bond
    bonds =[Bond.new('c1', 'corporate', '9 years', '10.0%')]
    benchmarks = get_benchmarks(bonds)
    assert_equal benchmarks.count, 0
  end

  def test_get_benchmark_no_corporate_bond
    bonds =[Bond.new('c1', 'government', '9 years', '10.0%')]
    benchmarks = get_benchmarks(bonds)
    assert_equal benchmarks.count, 0
  end
end