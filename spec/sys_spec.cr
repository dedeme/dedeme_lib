# Copyright 1-Oct-2018 ºDeme
# GNU General Public License - V3 <http://www.gnu.org/licenses/>

require "system"

describe Sys do
  it "system" do
    Sys.init("basicTests")
    sleep 0.10
    Io.del(Sys.home) if Sys.home.starts_with? "/home/"
  end

  it "exec" do
    #    puts(Sys.exec("pdfPrinter"))
  end
end
