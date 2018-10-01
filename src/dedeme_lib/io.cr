# Copyright 1-Feb-2018 ºDeme
# GNU General Public License - V3 <http://www.gnu.org/licenses/>

require "dir"
require "file_utils"
require "file"

module DedemeLib
  extend self

  module Io
    extend self

    # Changes the current working directory of the process to the given string
    # *path*.
    def cd(path : String)
      Dir.cd path
    end

    # Changes the current working directory of the process to the given string
    # *path* and invoked the block, restoring the original working directory
    # when the block exits.
    #
    # ```
    # Io.cd("/tmp") { ... } # => "/tmp".
    # ```
    def cd(path : String)
      Dir.cd(path) { yield }
    end

    # Returns the current working directory.
    def pwd : String
      Dir.current
    end

    # Returns true if the given path exists and is a directory.
    def directory?(path : String) : Bool
      Dir.exists? path
    end

    # Creates a new directory at the given path. The linux-style permission
    # mode can be specified, with a default of 755 (0o755).
    def mkdir(path : String, mode = 0o755)
      Dir.mkdir_p path
    end

    # Calls the block once for each entry except for `.` and `..` in
    # *directory*, passing the file name of each entry as a parameter to the
    # block.
    #
    # ```
    # d.each_entry "src" { |x| puts "Got #{x}" }
    # ```
    def each_child(directory : String)
      Dir.new(directory).each_child { |f| yield f }
    end

    # Removes the file or recursively the directory at the given path.
    def del(path : String)
      FileUtils.rm_r path
    end

    # Returns `true` if *path* is executable by the real user id of this
    # process else returns `false`.
    def exists?(path : String) : Bool
      File.exists? path
    end

    # Copies the file *src_path* to the file or directory *dest*.
    #
    # If *dest* is a directory, a file with the same basename as *src_path* is
    # created in *dest*
    #
    # Permission bits are copied too.
    def copy(source : String, target : String)
      FileUtils.cp(source, target)
    end

    # Copies a file or directory *src_path* to *dest_path*
    #
    # If *src_path* is a directory, this method copies all its contents
    # recursively
    def copy_r(source : String, target : String)
      FileUtils.cp_r(source, target)
    end

    # Moves *old_filename* to *new_filename*.
    def rename(old_name : String, new_name : String)
      File.rename(old_name, new_name)
    end

    # Returns information about a file or directory. The information returned
    # has, among others, next params:
    # ```text
    # directory?
    # file?
    # symlink?
    # owner
    # group
    # size
    # permisions
    # modification_time
    def info(path : String) : File::Info
      File.info path
    end

    # Returns a new file path whose template is: /tmp/*prefix*xxxxxxxxxx,
    # where xxxxxxxxxx is an aleatory sequence of characters.
    def tmp(prefix : String) : String
      r = ""
      while true
        name = B64.genk(10).sub('/', '_')
        r = "/tmp/#{prefix}#{name}"
        break if !exists? r
      end
      r
    end

    # Opens *path* in append mode
    def aopen(path : String) : File
      File.new(path, "a")
    end

    # Opens *path* in write mode
    def wopen(path : String) : File
      File.new(path, "w")
    end

    # Writes *text* in *file*
    def write(f : File, text : String)
      f.print(text)
    end

    # Write *bytes* in *file*
    def write(f : File, bytes : Bytes)
      f.write(bytes)
    end

    # Append *text* to *path*
    def append(path : String, text : String)
      File.open(path, "a") do |file|
        file.print(text)
      end
    end

    # Writes *text* to *path*
    def write(path : String, text : String)
      File.write(path, text)
    end

    # Yields each line in *path* to the given block. Lines are stripped of
    # the character `end of line`
    #
    # ```
    # File.each_line("foo") do |line|
    #   # loop
    # end
    # ```
    def each_line(path : String)
      File.open(path, "r") do |file|
        file.each_line do |line|
          yield line
        end
      end
    end

    SIZE = 8192
    def each_bytes(path)
      slice : Bytes = Bytes.new(SIZE)
      File.open(path, "r") do |file|
        n = file.read(slice)
        while n > 0
          if n < SIZE
            slice2 = Bytes.new(slice.to_unsafe, n)
            yield slice2
          else
            yield slice
          end
          n = file.read(slice)
        end
      end
    end

    # Adds *bs1* to *bs2*
    def cat_bytes(bs1 : Bytes, bs2 : Bytes) : Bytes
      r = Bytes.new(bs1.size + bs2.size)
      r.copy_from(bs1)
      r[bs1.size, bs2.size].copy_from(bs2)
      r
    end

    # Returns the content of *filename* as a string.
    def read(path : String) : String
      File.read path
    end

    # Returns all components of the given *path* except the last one.
    #
    # ```
    # Io.dirname("/foo/bar/file.cr") # => "/foo/bar"
    # ```
    def parent(path : String) : String
      File.dirname path
    end

    # Returns the last component of the given *path*.
    #
    # ```
    # Io.name("/foo/bar/file.cr") # => "file.cr"
    # ```
    def name(path) : String
      File.basename(path)
    end

    # Returns *path*'s extension, or an empty string if it has no extension.
    #
    # ```
    # Io.extension("a/foo.cr") # => ".cr"
    # ```
    def extension(path : String) : String
      File.extname(path)
    end

    # Returns the last component of the given *path* without extension.
    #
    # ```
    # Io.name("/foo/bar/file.cr") # => "file"
    # ```
    def only_name(path) : String
      nm = name(path)
      nm[0...nm.size - extension(nm).size]
    end

    # Returns a new string formed by joining the strings using
    # `File::SEPARATOR`.
    #
    # ```
    # Io.join("foo", "bar", "baz")       # => "foo/bar/baz"
    # Io.join("foo/", "/bar/", "/baz")   # => "foo/bar/baz"
    # Io.join("/foo/", "/bar/", "/baz/") # => "/foo/bar/baz/"
    # ```
    def join(*parts) : String
      File.join(parts)
    end
  end
end
