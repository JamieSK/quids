require 'minitest/autorun'
require 'minitest/rg'

require_relative '../models/user'

class UserTest < MiniTest::Test
  def setup
    @test_user = User.new('name' => 'test mcTesting')
    @test_user.save
  end

  def test_name
    assert_equal('Test McTesting', @test_user.name)
  end

  def test_change_name
    @test_user.name = 'Mr. McTesting'
    @test_user.update
    assert_equal('Mr. McTesting', @test_user.name)
  end

  def test_find_by_id
    @user_from_db = User.find(@test_user.id)
    assert_equal(@user_from_db, @test_user)
  end

  def teardown
    @test_user.delete
  end
end
