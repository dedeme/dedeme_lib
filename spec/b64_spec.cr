# Copyright 15-Aug-2017 ºDeme
# GNU General Public License - V3 <http://www.gnu.org/licenses/>

describe B64 do
  it "B64" do
    B64.encode_bytes(B64.decode_bytes("AQIDBA==")).should eq("AQIDBA==")
    B64.decode(B64.encode("Cañón")).should eq("Cañón")
    B64.encode("Cañónç䍆").should eq("Q2HDscOzbsOn5I2G")
  end
end
