# Copyright 1-Oct-2018 ºDeme
# GNU General Public License - V3 <http://www.gnu.org/licenses/>

require "io"

def count_files(dir : String)
  n = 0
  Io.children(dir).each { n += 1 }
  n
end

describe Io do
  it "system" do
    Sys.init("basicTests")
    r = ""
    Io.children(Io.parent Sys.home).each { |f| r += f }
    r.includes?(Sys.app_name).should eq true

    Io.name("a/b/c.s").should eq("c.s")
    Io.parent("a/b/c.s").should eq("a/b")
    Io.extension("a/b/c.s").should eq(".s")
    Io.only_name("a/b/c.s").should eq("c")

    Io.del Sys.home
  end

  it "file" do
    tmp = Io.tmp "test"
    tmp.starts_with?("/tmp/test").should eq true
    tmp.size.should eq 19

    dpath = "#{tmp}/file"
    Io.mkdir dpath
    Io.directory?(dpath).should eq true
    count_files(dpath).should eq 0

    path = Io.join(dpath, "f1.txt")
    Io.exists?(path).should eq false
    Io.write(path, "")
    path = Io.join(dpath, "f2.txt")
    Io.write(path, "")
    Io.exists?(path).should eq true
    count_files(dpath).should eq 2

    info = Io.info dpath
    info.directory?.should eq true
    info = Io.info path
    info.file?.should eq true

    path0 = Io.join(dpath, "f0.txt")
    Io.write(path0, "")
    info = Io.info path0
    info.size.should eq 0
    text = Io.read(path0)
    text.size.should eq 0

    Io.append(path0, "ab")
    Io.append(path0, "123\n")
    Io.append(path0, "xx")
    Io.read(path0).should eq "ab123\nxx"

    path10 = Io.join(dpath, "f10.txt")
    Io.write(path10, "a")
    Io.read(path10).should eq "a"

    path11 = Io.join(dpath, "f11.txt")
    Io.write(path11, "a\nb")
    Io.read(path11).should eq "a\nb"

    path12 = Io.join(dpath, "f12.txt")
    Io.write(path12, "\n01234567890\n")
    Io.read(path12).should eq "\n01234567890\n"

    path2 = Io.join(dpath, "f2.txt")
    Io.write(path2, "aa\nb\n01234567890\n")
    Io.read(path2).should eq "aa\nb\n01234567890\n"

    path2b = Io.join(dpath, "f2.txt")
    bss = Bytes.new(0)
    Io.each_bytes(path2b) do |bs|
      bss = Io.cat_bytes(bss, bs)
    end

    f = Io.wopen path2b
    Io.write(f, bss)
    f.close
    Io.read(path2b).should eq "aa\nb\n01234567890\n"

    Io.copy(path11, path2)
    Io.read(path2).should eq "a\nb"

    path = Io.join(dpath, "f.txt")
    f = Io.wopen path
    Io.write(f, "1\n")
    f.close

    f = Io.aopen path
    Io.write(f, "2\n")
    f.close

    tx = ""
    Io.each_line(path) do |l|
      tx += l + '\n'
    end

    tx.should eq "1\n2\n"

    Io.del(tmp) if tmp.starts_with?("/tmp/")
  end
end
