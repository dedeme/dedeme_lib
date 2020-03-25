# Copyright 15-Aug-2017 ºDeme
# GNU General Public License - V3 <http://www.gnu.org/licenses/>

require "base64"

module DedemeLib
  extend self

  # Encoder and decoder to/from Base 64.
  module B64
    extend self

    # Encodes a string to Base 64.
    def encode(s : String) : String
      Base64.strict_encode(s)
    end

    # Encodes a slice to Base 64.
    def encode_bytes(bs : Bytes) : String
      Base64.strict_encode(String.new(bs))
    end

    # Decode a string previously codified to Base 64.
    def decode(s : String) : String
      Base64.decode_string(s)
    end

    # Decode a slice previously codified to Base 641.
    def decode_bytes(s : String) : Bytes
      Base64.decode(s)
    end
  end
end
