# Copyright 6-Oct-2018 ºDeme
# GNU General Public License - V3 <http://www.gnu.org/licenses/>

require "ext"

describe Ext do
  Sys.init("basicTests")

  it "zip" do
    f = "#{Sys.home}/source.txt"
    fzip = "#{Sys.home}/target.zip"

    Io.write(f, "A test text")
    Ext.zip(f, fzip)
    (Io.exists? fzip).should eq true
    Io.del f
    (Io.exists? f).should eq false
    Ext.unzip(fzip, Sys.home)
    (Io.exists? f).should eq true
    tx = Io.read f
    tx.should eq "A test text"
    Io.del f
    Io.del fzip
  end
end
