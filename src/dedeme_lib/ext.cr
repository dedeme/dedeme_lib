# Copyright 06-Oct-2018 ºDeme
# GNU General Public License - V3 <http://www.gnu.org/licenses/>

require "dir"
require "file_utils"
require "file"

module DedemeLib

  module Ext
    extend self

    # `zip` compress 'source' in 'target'. It calls:
    # ```
    #   zip -q [-r] target source
    # ```
    # if 'target' already exists, 'source' will be added to it. If you require a
    # fresh target file, you have to delete it previously.
    #
    # Parameters:
    # * `source`: can be a file or directory,
    # * `target`: Zip file. If it is a relative path, it hangs on source parent.
    #
    # Throws exception if it fails.
    def zip(source : String, target : String)
      pwd = Io.pwd
      if !target.starts_with? '/'
        target = "#{pwd}/#{target}"
      end
      parent = File.dirname source
      name = File.basename source
      Io.cd parent
      args = ["-q", target,  name]
      args = ["-q", "-r", target,  name] if Io.directory? name
      Sys.exec("zip", args)
      Io.cd pwd
      if !Io.exists? target
        raise IO::Error.new("Fail zipping: {#source}")
      end
    end

    # `unzip` uncompress 'source' in 'target'. It calls:
    # ```
    #   unzip -q source -d target
    # ```
    #
    # Parameters:
    # * `source`: Zip file.
    # * `target`: A directory. Ii it does not exist, it is created.
    #
    # Throws exception.
    def unzip(source : String, target : String)
      if !Io.directory?(target)
        raise IO::Error.new("'#{target}' is not a directory")
      end
      r = Sys.exec("unzip", ["-q", "-o", source, "-d", target])
      if r.size > 0
        raise IO::Error.new(r)
      end
    end

  end
end
