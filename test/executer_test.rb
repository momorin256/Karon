require "minitest/autorun"
require "pathname"
require_relative "../src/executer.rb"

class ExecuterTest < Minitest::Test
  def setup
    @karon = Executer.new
    @file = Pathname(__dir__).join("test.json")
  end

  def init_data
    @karon.exec(["clear", "-f", @file])
    @karon.exec(["add", "Title01", "user-name", "-p", "password-01", "-k", "test_key", "-f", @file])
    @karon.exec(["add", "Second Title", "2nd user name", "-p", "second password", "-k", "test_key", "-f", @file])
    @karon.exec(["add", "(a[0]/2)+($e.#?)~!", "%%", "-p", "123456", "-k", "test_key", "-f", @file])
  end

  def test_list
    init_data

    expected = <<~TEXT
      \(0)      Title01       |   user-name   |
      \(1)    Second Title    | 2nd user name |
      \(2) (a[0]/2)+($e.#?)~! |      %%       |
    TEXT
    assert_output(expected) { @karon.exec(["list", "-f", @file]) }
  end

  def test_select
    init_data
    assert_output("password-01\n") { @karon.exec(["select", "0", "-k", "test_key", "-f", @file]) }
  end
end
