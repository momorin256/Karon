require "minitest/autorun"
require_relative "../src/cipher.rb"

class CipherTest < Minitest::Test
  def setup
    @data = "test message"
    @pass = "test_password"
    @salt = "test_salt"
  end

  def test_encrypt
    enc = Cipher::encrypt(@data, @pass, @salt)
    dec = Cipher::decrypt(enc, @pass, @salt)
    assert_equal @data, dec
  end
end
