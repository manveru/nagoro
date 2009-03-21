require 'open3'

module Nagoro
  module Pipe
    # Small wrapper that pipes the template through tidy.
    #
    # For configuration see the {Tidy::FLAGS}, it's an array of arguments
    # passed to the tidy command.
    #
    # We are not using the ruby tidy library to avoid memory-leaks and
    # dependencies. Please make sure you do have a binary called `tidy` in your
    # `PATH` before using this library.
    #
    # This pipe relies on open3 from the standard library.
    #
    # == Regarding Windows
    #
    # There have been numerous reports that open3 doesn't work on Windows,
    # since it relies on Kernel#fork, as syscall that is not supported on that
    # platform.
    #
    # Two possible solutions exist:
    # * There is a win32-popen implementation in RAA
    # * Kernel#fork works in cygwin.
    #
    # I don't have a copy of windows, so it's hard for me to try either of
    # these options.
    # Please send me a patch if you find a cross-platform way of implementing
    # this functionality.
    class Tidy < Base
      # Possible flags can be found in `tidy -help` and `tidy -help-config`
      FLAGS = %w[-utf8 -asxhtml -quiet -indent --tidy-mark no]

      def result
        @scanner.stream
        tidy(@body.join)
      end

      # Pipe given +string+ through the tidy binary.
      #
      # @param [#to_s] string
      # @return [String]
      # @author manveru
      def tidy(string)
        Nagoro::Tidy.tidy(string, FLAGS)
      end
    end
  end
end
