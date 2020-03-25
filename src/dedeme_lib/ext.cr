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
      args = ["-q", target, name]
      args = ["-q", "-r", target, name] if Io.directory? name
      r = Sys.exec("zip", args)
      Io.cd pwd
      if r[:error].size > 0
        raise IO::Error.new(r[:error])
      elsif !Io.exists? target
        raise IO::Error.new("Fail zipping: {#source}")
      end
    end

    # `unzip` uncompress 'source' in 'target'. It calls:
    # ```
    # unzip -q source -d target
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
      if r[:error].size > 0
        raise IO::Error.new(r[:error])
      end
    end

    # Reads a text using GUI. It calls:
    # ```text
    # zenity --entry --title='title' --text='prompt' --entry-text='default'
    # ```
    # - The return removes starting and trailing spaces.
    # - If user clicks on cancel, it returns an empty string.
    def zenity_entry(title, prompt : String, default = "") : String
      r = Sys.exec("zenity",
        ["--entry", "--title=#{title}", "--text=#{prompt}",
         "--entry-text=#{default}"]
      )
      if r[:error].size > 0
        raise IO::Error.new(r[:error])
      else
        return r[:output].strip
      end
    end

    # Shows a message box. It calls:
    # ```text
    # zenity --notification --window-icon='icon' --text='text'
    # ```
    # 'icon' is one of gnome icon stock. For example: info, dialog-warning,
    # dialog-error, dialog-information, face-wink, etc.
    def zenity_msg(icon, text : String)
      Sys.exec("zenity", ["--info", "--icon-name=#{icon}", "--text=#{text}"])
    end

    # Calls "wget -q -O - 'url'" and returns the text read.
    def wget(url : String) : String
      r = Sys.exec("wget", ["-q", "--no-cache", "-O", "-", url])
      if r[:error].size > 0
        raise IO::Error.new(r[:error])
      else
        return r[:output].strip
      end
    end

    # Reads an URL.
    #
    # Calls "node -e [script]" and returns the text read.
    #
    # [script] is a script which run a node library called "puppeteer". This
    # library must be downloaded (npm install puppeteer).
    def puppeteer(url : String) : String
      r = Sys.exec("node",
        ["-e",
         "const puppeteer = require('puppeteer');
          (async () => {
            try {
              const browser = await puppeteer.launch();
              const page = await browser.newPage();
              page.setDefaultNavigationTimeout(180000);
              await page.goto('#{url}');
              const ct = await page.content();
              console.log(ct);
              await browser.close();
            } catch (e) {
              console.error(e.toString());
              process.exit(1);
            }
          })();"]
      )
      if r[:error].size > 0
        raise IO::Error.new(r[:error])
      else
        return r[:output].strip
      end
    end
  end
end
