module Nagoro
  class Error < RuntimeError
    class Warning < self; end

    class Parse < self
      class Warning < self; end
      class Severe < self; end
      class PI < self; end 
      class StartTag < self; end
    end
  end
end
