# Copyright 25-Mar-2020 ºDeme
# GNU General Public License - V3 <http://www.gnu.org/licenses/>

module DedemeLib
  extend self

  # Encription functions.
  module Cryp
    extend self

    # Generates a B64 random key of a length _lg_
    def genk(lg : Int) : String
      arr = Bytes.new(lg)
      rnd = Random.new
      (0...lg).each { |i| arr[i] = rnd.rand(256).to_u8 }
      return B64.encode_bytes(arr)[0...lg]
    end

    # Returns _k_ codified in irreversible way, using _lg_ B64 digits.
    # ```text
    # k     : String to codify
    # lg    : Length of result
    # return: _lg_ B64 digits
    def key(k : String, lg : Int) : String
      dt = B64.decode_bytes(B64.encode(
        k + "codified in irreversibleDeme is good, very good!\n\r8@@"
      ))

      lenk = dt.size
      sum = 0_u32
      (0...lenk).each { |i| sum += dt[i] }
      lg2 = lg + lenk
      r = Bytes.new(lg2)
      r1 = Bytes.new(lg2)
      r2 = Bytes.new(lg2)

      ik = 0
      (0...lg2).each do |i|
        v1 : UInt32 = dt[ik].to_u32
        v2 = v1 + dt[v1 % lenk]
        v3 = v2 + dt[v2 % lenk]
        v4 = v3 + dt[v3 % lenk]
        sum += i + v4
        r1[i] = (sum & 255).to_u8
        r2[i] = (sum & 255).to_u8
        ik += 1
        ik = 0 if ik == lenk
      end

      (0...lg2).each do |i|
        v1 = r2[i].to_u32
        v2 = v1 + r2[v1 % lg2]
        v3 = v2 + r2[v2 % lg2]
        v4 = v3 + r2[v3 % lg2]
        sum += v4
        r2[i] = (sum & 255).to_u8
        r[i] = ((sum + r1[i]) & 255).to_u8
      end

      return B64.encode_bytes(r)[0...lg]
    end

    # Encodes _m_ with key _k_.
    # ```text
    # k     : Key for encoding
    # m     : Message to encode
    # return: 'm' codified in B64 digits.
    def cryp(k : String, m : String) : String
      m = B64.encode(m)
      lg = m.size
      k = key(k, lg)
      mb = m.to_slice
      kb = k.to_slice
      r = Bytes.new(lg)
      (0...lg).each { |i| r[i] = mb[i] + kb[i] }
      return B64.encode_bytes(r)
    end

    # Decodes _c_ using key _k_. _c_ was codified with cryp().
    # ```text
    # k     : Key for decoding
    # c     : Text codified with cryp()
    # return: 'c' decoded.
    def decryp(k : String, c : String) : String
      mb = B64.decode_bytes(c)
      lg = mb.size
      k = key(k, lg)
      kb = k.to_slice
      r = Bytes.new(lg)
      (0...lg).each { |i| r[i] = mb[i] - kb[i] }
      return B64.decode(String.new r)
    end
  end
end
