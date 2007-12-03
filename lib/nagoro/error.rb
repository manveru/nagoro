module Nagoro
  class Error < RuntimeError
  end

  class Warning < Error
  end

  class ParseWarning < Warning
  end

  class ParseError < Error
  end

  # Process Instruction: <? ?>

  class ParsePI < ParseError
  end

  class ParseFatalError < ParseError
  end
end
