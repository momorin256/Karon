require "minitest/autorun"
require_relative "../src/record.rb"

class RecordTest < Minitest::Test
  def test_load
    title = "title"
    user = "user"
    password = "password"
    r = Record.load({ title: title, user: user, password: password }, "")

    assert_equal "title", r.title
    assert_equal "user", r.user
    assert_equal "password", r.password
  end

  def test_format
    title = "title"
    user = "user"
    password = "password"
    r = Record.load({ title: title, user: user, password: password }, "")

    expected = "  title  |   user   |"
    assert_equal expected, r.format(7, 8)
  end

  def test_encrypt_password
    pass = "sample_password"
    key = "sample_key"
    enc = Record.encrypt_password(pass, key)
    dec = Record.decrypt_password(enc, key)
    assert_equal pass, dec
  end
end
