require_relative '../spread'
require 'test/unit'

class SpreadTest < Test::Unit::TestCase
  def test_government_bonds_segment
    c1, g1, g2 = 
      Bond.new('c1', 'corporate', '9 years', '10.0%'),
      Bond.new('g1', 'government', '8 years', '13.0%'),
      Bond.new('g2', 'government', '10 years', '15.0%')

    g_bonds = [g1, g2]
    segment = government_bonds_segment(g_bonds, c1)

    assert_equal(segment, g_bonds)
  end

  def test_government_bonds_segment_not_in_range
    c1, g1, g2 = 
      Bond.new('c1', 'corporate', '9 years', '10.0%'),
      Bond.new('g1', 'government', '7 years', '13.0%'),
      Bond.new('g2', 'government', '8 years', '15.0%')

    g_bonds = [g1, g2]

    assert_raise ArgumentError do
      segment = government_bonds_segment(g_bonds, c1)
    end
  end

  def test_government_bonds_segment_no_segment
    c1, g1, g2 = 
      Bond.new('c1', 'corporate', '9 years', '10.0%'),
      Bond.new('g1', 'government', '10 years', '13.0%'),
      Bond.new('g2', 'government', '11 years', '15.0%')

    g_bonds = [g1, g2]

    assert_raise ArgumentError do
      segment = government_bonds_segment(g_bonds, c1)
    end
  end

  def test_slope
    p1, p2 = 13.0, 15.0
    g1, g2 = 
      Bond.new('g1', 'government', '10 years', "#{p1}%"),
      Bond.new('g2', 'government', '11 years', "#{p2}%")

    bonds = [g1, g2]

    m = slope(bonds)

    assert_equal(m, (p2 - p1).round(2))
  end

  def test_slope_exception
    p1, p2 = 13.0, 15.0
    g1, g2 = 
      Bond.new('g1', 'government', '10 years', "#{p1}%"),
      Bond.new('g2', 'government', '10 years', "#{p2}%")

    bonds = [g1, g2]
    assert_raise ArgumentError do
      m = slope(bonds)
    end
  end

  def test_intercept
    y, p = 9, 10.0
    c1 = Bond.new('c1', 'corporate', "#{y} years", "#{p}")
    slope = 2.0

    int = intercept(slope, c1)
    assert_equal(int, ((p - slope * y) * Bond.buffer).round(2))
  end

  def test_expected_yield
    y1,y2,y3,p1,p2,p3 = 9, 8, 10, 11, 10, 12
    c1, g1, g2 = 
      Bond.new('c1', 'corporate', "#{y1} years", "#{p1}%"),
      Bond.new('g1', 'government', "#{y2} years", "#{p2}%"),
      Bond.new('g2', 'government', "#{y3} years", "#{p3}%")

    seg = [g1, g2]
    ey = expected_yield(seg, c1)

    assert_equal(ey, (p1 * Bond.buffer).round(2))
  end

  def test_expected_yield_on_point
    y1,y2,p1,p2 = 8, 10, 10, 12
    c1, g1, g2 = 
      Bond.new('c1', 'corporate', "#{y1} years", "#{p1}%"),
      Bond.new('g1', 'government', "#{y1} years", "#{p1}%"),
      Bond.new('g2', 'government', "#{y2} years", "#{p2}%")

    seg = [g1, g2]
    ey = expected_yield(seg, c1)

    assert_equal(ey, (p1 * Bond.buffer).round(2))
  end

  def spread_to_curve
    p1,p2 = 3.25 * Bond.buffer, 1.25 * Bond.buffer
    stc = spread_to_curve(p1, p2)

    assert_equal(stc, 2.0)
  end
end