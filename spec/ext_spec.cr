# Copyright 6-Oct-2018 ºDeme
# GNU General Public License - V3 <http://www.gnu.org/licenses/>

require "ext"

describe Ext do
  it "zip" do
    Sys.init("basicTests")
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
    Io.del Sys.home
  end

  it "zenity" do
    #m = Ext.zenity_entry("A Title", "Prompt:", "def")
    #Ext.zenity_msg("info", "You wrote '#{m}'")
  end

  it "wget" do
    Ext.wget("http://localhost").includes?("ºDeme").should eq true
  end

  it "puppeteer" do
    Ext.puppeteer("http://localhost").includes?("ºDeme").should eq true
  end


end
