require "base64"
require "pathname"
require_relative "./cipher.rb"

class Record
  attr_reader :title, :user, :password

  def initialize(hash)
    @title = hash[:title]
    @user = hash[:user]
    @password = hash[:password]
  end

  def self.load(hash, key)
    hash[:password] = decrypt_password(hash[:password], key) if !key.empty?
    self.new(hash)
  end

  def format(title_width, user_width)
    " #{@title.center(title_width)} | #{@user.center(user_width)} |"
  end

  def to_hash(key)
    { title: @title, user: @user, password: Record.encrypt_password(@password, key) }
  end

  def self.encrypt_password(pass, key)
    salt = get_salt
    enc = Cipher::encrypt(pass, key, salt)
    Base64.encode64(salt + enc)
  end

  def self.decrypt_password(pass, key)
    decoded = Base64.decode64(pass)
    salt = decoded[0..(salt_len - 1)]
    data = decoded[salt_len..]
    Cipher::decrypt(data, key, salt)
  end

  def self.get_salt
    OpenSSL::Random.random_bytes(salt_len)
  end

  def self.salt_len
    8
  end
end
