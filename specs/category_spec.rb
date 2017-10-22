require 'minitest/autorun'
require 'minitest/rg'

require_relative '../models/category'

# Tests the category class for the quids budgeting app.
class CategoryTest < MiniTest::Test
  def setup
    @test_category = Category.new('name' => 'test')
    @test_category.save
  end

  def test_find_by_name
    assert_equal(@test_category.id, Category.find_name('Test'))
  end

  def test_not_found_by_name_adds_category
    num_categories = Category.find_all.length
    assert_instance_of(Integer, Category.find_name('Parachuting'))
    assert_equal(num_categories + 1, Category.find_all.length)
  end

  def test_find_wrong_case
    assert_equal(@test_category.id, Category.find_name('test'))
  end

  def test_colour_returned
    colour = Category.colours[@test_category.name]
    assert_match(/#\h{6}/, colour)
  end

  def teardown
    Category.find(Category.find_name('Parachuting')).delete
    @test_category.delete
    skipped?
  end
end
