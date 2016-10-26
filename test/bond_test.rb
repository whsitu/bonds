require_relative '../bond'
require 'test/unit'

class BondTest < Test::Unit::TestCase
  def test_initialize_with_params
    name = 'c1'
    type = 'corporate'
    year = 9.0
    percent = 10.0
    b = Bond.new('c1', 'corporate', "#{year} years", "#{percent}%")
    assert(b.name == name)
    assert(b.type == type)
    assert(b.term == (year * Bond.buffer).to_i)
    assert(b.yield_percent == (percent * Bond.buffer).to_i)
  end

  def test_init_no_name
    assert_raise ArgumentError do
      b = Bond.new(nil, 'corporate', "9 years", '10.0%')
    end
  end

  def test_init_no_type
    assert_raise ArgumentError do
      b = Bond.new('c1', nil, "9 years", '10.0%')
    end
  end

  def test_init_wrong_type
    assert_raise ArgumentError do
      b = Bond.new('c1', 'asdasd', "9 years", '10.0%')
    end
  end

  def test_init_no_year
    assert_raise ArgumentError do
      b = Bond.new('c1', 'corporate', "9 years", nil)
    end
  end

  def test_init_no_percent
    assert_raise ArgumentError do
      b = Bond.new('c1', 'corporate', nil, '10.0%')
    end
  end

  def test_corporate_or_government
    b1 = Bond.new('c1', 'corporate', '9 years', '10.0%')
    b2 = Bond.new('c1', 'government', '9 years', '10.0%')
    assert(b1.corporate?)
    assert(b2.government?)
  end

  def test_buffer
    assert_equal(Bond.buffer, 10000)
  end

  def test_corporate_and_government_bonds
    b1 = Bond.new('c1', 'corporate', '9 years', '10.0%')
    b2 = Bond.new('c1', 'government', '9 years', '10.0%')
    bonds = [b1, b2]

    c_bonds = Bond.corporate bonds
    g_bonds = Bond.government bonds

    assert_equal(c_bonds, [b1])
    assert_equal(g_bonds, [b2])
  end

  def test_create_from_file
    file_name = 'sample_input_2.csv'
    bonds = Bond.create_from_file(file_name)

    assert_equal(bonds.count, 5)
  end
end