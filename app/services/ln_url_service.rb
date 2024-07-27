# frozen_string_literal: true

class LnUrlService
  VERSION = '1.2.0'.freeze
  # Maximum integer size
  # Useful for max_length when decoding
  MAX_INTEGER = 2**31 - 1

  HRP = 'lnurl'.freeze

  attr_reader :uri

  def initialize(uri)
    @uri = URI(uri)
  end

  def to_bech32
    Bech32.encode(HRP, data, Bech32::Encoding::BECH32).upcase
  end
  alias encode to_bech32

  def data
    self.class.convert_bits(uri.to_s.codepoints, 8, 5, true)
  end

  def self.valid?(value)
    return false unless value.to_s.downcase.match?(Regexp.new("^#{HRP}", 'i')) # false if the HRP does not match
    decoded = decode_raw(value) rescue false # rescue any decoding errors
    return false unless decoded # false if it could not get decoded

    return decoded.match?(URI.regexp) # check if the URI is valid
  end

  def self.decode(ln_url, max_length = MAX_INTEGER)
    LnUrlService.new(decode_raw(ln_url, max_length))
  end

  def self.decode_raw(lnurl, max_length = MAX_INTEGER)
    ln_url = ln_url.gsub(/^lightning:/, '')
    hrp, data, sepc = Bech32.decode(lnurl, max_length)
    # raise 'no ln_url' if hrp != HRP
    convert_bits(data, 5, 8, false).pack('C*').force_encoding('utf-8')
  end


  # FROM: https://github.com/azuchi/bech32rb/blob/master/lib/bech32/segwit_addr.rb
  def self.convert_bits(data, from, to, padding=true)
    acc = 0
    bits = 0
    ret = []
    maxv = (1 << to) - 1
    max_acc = (1 << (from + to - 1)) - 1
    data.each do |v|
      return nil if v < 0 || (v >> from) != 0
      acc = ((acc << from) | v) & max_acc
      bits += from
      while bits >= to
        bits -= to
        ret << ((acc >> bits) & maxv)
      end
    end
    if padding
      ret << ((acc << (to - bits)) & maxv) unless bits == 0
    elsif bits >= from || ((acc << (to - bits)) & maxv) != 0
      return nil
    end
    ret
  end

  def self.auth(uri, callback_uri)
    @k1 = SecureRandom.random_bytes(32)
    params = {
      tag: 'login',
      k1: @k1,
      callback: callback_uri
    }
    LnUrlService.new([uri, '?', URI.encode_www_form(params)].join)
  end
end
