require "openssl"

module Cipher
  class << self
    def encrypt(data, pass, salt)
      self.execute(:encrypt, data, pass, salt)
    end

    def decrypt(data, pass, salt)
      self.execute(:decrypt, data, pass, salt)
    end

    def execute(proc, data, pass, salt)
      cipher = OpenSSL::Cipher.new(self.cipher_name)
      proc.to_proc.call(cipher)

      key_len = cipher.key_len
      iv_len = cipher.iv_len
      key_iv = OpenSSL::PKCS5.pbkdf2_hmac_sha1(pass, salt, self.iter_cnt, key_len + iv_len)
      cipher.key = key_iv[0, key_len]
      cipher.iv = key_iv[key_len, iv_len]

      cipher.update(data) + cipher.final
    end

    def cipher_name
      "aes-256-cbc"
    end

    def iter_cnt
      2048
    end
  end
end
