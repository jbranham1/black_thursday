require './test/test_helper'
require './lib/repo_helper'
require 'mocha/minitest'

class ItemDouble
  def id
    1
  end

  def name
    'Test'
  end

  def update
    {

    }
  end
end

class MockRepository
  include RepoHelper
  attr_reader :all

  def item
    ItemDouble.new
  end

  def all
    [
      item
    ]
  end
end

class RepoHelperTest < Minitest::Test
  def setup
    @repo = MockRepository.new
  end

  def test_it_exists
    assert_instance_of MockRepository, @repo
  end

  def test_can_find_by_id
    assert_equal 1, @repo.find_by_id(1).id
    assert_nil @repo.find_by_id(99)
  end

  def test_can_find_by_name
    assert_equal 'Test', @repo.find_by_name('Test').name
    assert_nil  @repo.find_by_name('Potato')
  end

  def test_can_update
    skip
    record = @repo.find_by_id(1)
    attributes = { name: 'Test Updated' }
    @repo.update(1, attributes)

    assert_equal 'Test Updated', record.name
  end
end
