# Copyright 25-Mar-2020 ºDeme
# GNU General Public License - V3 <http://www.gnu.org/licenses/>

describe Cryp do
  it "Cryp" do
    Cryp.genk(12).size.should eq(12)
    Cryp.key("deme", 6).should eq("wiWTB9")
    Cryp.key("Generaro", 5).should eq("Ixy8I")
    Cryp.key("Generara", 5).should eq("0DIih")
    Cryp.cryp("deme", "Cañón€%ç").should eq("v12ftuzYeq2Xz7q7tLe8tNnHtqY=")
    Cryp.decryp("deme", Cryp.cryp("deme", "Cañón€%ç")).should eq("Cañón€%ç")
    Cryp.decryp("deme", Cryp.cryp("deme", "1")).should eq("1")
    Cryp.decryp("deme", Cryp.cryp("deme", "")).should eq("")
    Cryp.decryp("", Cryp.cryp("", "Cañón€%ç")).should eq("Cañón€%ç")
    Cryp.decryp("", Cryp.cryp("", "1")).should eq("1")
    Cryp.decryp("", Cryp.cryp("", "")).should eq("")
  end
end
