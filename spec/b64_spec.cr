# Copyright 15-Aug-2017 ºDeme
# GNU General Public License - V3 <http://www.gnu.org/licenses/>

require "base64"

# puts B64.decodeBytes(B64.encode("Cañón€"));

describe B64 do
  it "B64" do
    B64.encode_bytes(B64.decode_bytes("AQIDBA==")).should eq("AQIDBA==")
    B64.decode(B64.encode("Cañón")).should eq("Cañón")
    B64.encode("Cañónç䍆").should eq("Q2HDscOzbsOn5I2G")
  end

  it "Cryp" do
    B64.genk(12).size.should eq(12)
    B64.key("deme", 6).should eq("wiWTB9")
    B64.key("Generaro", 5).should eq("Ixy8I")
    B64.key("Generara", 5).should eq("0DIih")
    B64.cryp("deme", "Cañón€%ç").should eq("v12ftuzYeq2Xz7q7tLe8tNnHtqY=")
    B64.decryp("deme", B64.cryp("deme", "Cañón€%ç")).should eq("Cañón€%ç")
    B64.decryp("deme", B64.cryp("deme", "1")).should eq("1")
    B64.decryp("deme", B64.cryp("deme", "")).should eq("")
    B64.decryp("", B64.cryp("", "Cañón€%ç")).should eq("Cañón€%ç")
    B64.decryp("", B64.cryp("", "1")).should eq("1")
    B64.decryp("", B64.cryp("", "")).should eq("")
  end
end
