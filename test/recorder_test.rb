require "pathname"
require "minitest/autorun"

require_relative "../src/record.rb"
require_relative "../src/recorder.rb"

class RecordTest < Minitest::Test
  def setup
    test_json = Pathname(__dir__).join("test.json")
    test_key = "test_key"
    @recorder = Recorder.new(test_json, test_key)

    File.exist?(test_json) && File.delete(test_json)
    add_test_data
  end

  def init_data
    @recorder.clear
    add_test_data
  end

  def add_test_data
    @recorder.add("Title01", "user-name", "password-01")
    @recorder.add("Second Title", "2nd user name", "second password")
    @recorder.add("(a[0]/2)+($e.#?)~!", "%%", "123456")
  end

  def test_clear
    @recorder.clear
    assert_output("\n") { @recorder.list }
  end

  def test_list
    init_data

    expected = <<~TEXT
      \(0)      Title01       |   user-name   |
      \(1)    Second Title    | 2nd user name |
      \(2) (a[0]/2)+($e.#?)~! |      %%       |
    TEXT

    assert_output(expected) { @recorder.list }
  end

  def test_remove
    init_data
    @recorder.remove(0)

    expected = <<~TEXT
      \(0)    Second Title    | 2nd user name |
      \(1) (a[0]/2)+($e.#?)~! |      %%       |
    TEXT

    assert_output(expected) { @recorder.list }
  end

  def test_select
    init_data
    idx = 1
    assert_output("second password\n") { @recorder.select(idx) }
  end
end
