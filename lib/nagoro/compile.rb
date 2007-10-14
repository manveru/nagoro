module Nagoro
  class Compiler
    def initialize(template, options = {})
      @template, @options = template, options
      @compiled = nil
    end

    def compile
      temp = @template.dup
      start_heredoc = "T" << Digest::SHA1.hexdigest(temp)
      start_heredoc = "\n<<#{start_heredoc}\n"
      end_heredoc = "\n#{start_heredoc}\n"
      bufadd = "_out_ << "

      temp.gsub!(/<\?r\s+(.*?)\s+\?>/m,
            "#{end_heredoc} \\1; #{bufadd} #{start_heredoc}")

      @compiled = "_out_ = ''
      #{bufadd} #{start_heredoc} #{temp} #{end_heredoc}
      _out_"
    end

    def eval(binding)
      compile unless compiled?
      eval(@compiled, binding, @options[:file]).strip
    end

    def compiled?
      !!@compiled
    end
  end
end
