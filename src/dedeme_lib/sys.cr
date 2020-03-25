# Copyright 1-Feb-2018 ºDeme
# GNU General Public License - V3 <http://www.gnu.org/licenses/>

require "env"
require "io"

module DedemeLib
  extend self

  class Sys
    # Returns the user directory
    def self.user_home : String
      ENV.fetch("HOME")
    end

    # Initializes the application. It creates the application directory.
    # Successive calls with same _app_name_ have not effect.
    def self.init(app_name : String)
      @@app_name = app_name
      Io.mkdir "#{Sys.user_home}/.dmCrystal/#{app_name}"
    end

    # Resturns the application name set with *init*
    def self.app_name : String
      a = @@app_name
      if a
        a
      else
        raise "Sys.init has not been called"
      end
    end

    # Returns the application dir creates with *init*
    def self.home : String
      a = @@app_name
      if a
        "#{Sys.user_home}/.dmCrystal/#{a}"
      else
        raise "Sys.init has not been called"
      end
    end

    def self.exec(
      cmd : String, args : Array(String) | Nil = nil
    ) : {output: String, error: String}
      ioOutput = IO::Memory.new
      ioError = IO::Memory.new
      Process.run(cmd, args: args, output: ioOutput, error: ioError)
      r = {output: ioOutput.to_s, error: ioError.to_s}
      ioOutput.close
      ioError.close
      r
    end
  end
end
