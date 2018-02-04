# Copyright 1-Feb-2018 ºDeme
# GNU General Public License - V3 <http://www.gnu.org/licenses/>

require "system"

describe Sys do
  it "system" do
    Sys.init("basicTests")
    Io.del(Sys.home) if Sys.home.starts_with? "/home/"
  end

  it "exec" do
    #    puts(Sys.exec("pdfPrinter"))
  end
end
