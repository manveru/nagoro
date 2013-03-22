module Nagoro
  module Pipe
    # Morph is a search and replace system based on parameters of opening
    # tags.
    #
    # Available morphs are at the time of writing:
    # each, filter, foreach, if, times, unless
    #
    # Please take care not to use multiple morphable parameters in one tag, due
    # to restrictions of the implementation of REXML and libxml there is no way
    # to find out which one came first and so the order would get messed up,
    # leading to unpredictable results.
    # You can, however, use any number of other parameter together with morphs.
    #
    # Example for each predefined morph:
    #   <a if="@address" href="#@address">#@address</a>
    #   # <?r if @address ?>
    #   #   <a href="#@address">#@address</a>
    #   # <?r end ?>
    #
    #   <a unless="logged_in?" href="/login">Login to your account</a>
    #   # <?r unless logged_in? ?>
    #   #   <a href="/login">Login to your account
    #   # <?r end ?>
    #
    #   <div foreach="tag in @tags" class="tag">#{tag}</div>
    #   # <?r for tag in @tags ?>
    #   #  <div class="tag">#{tag}</div>
    #   # <?r end ?>
    #
    #   <p filter="emoticonize">Hello there :)</p>
    #   # <p>#{emoticonize(%<Hello there :)>)}</p>
    #
    #   <div times="10" class="shout">I am innocent!</div>
    #   # <?r 10.times do |_t| ?>
    #   #   <div class="shout">I am innocent!</div>
    #   # <?r end ?>
    #
    #   <div each="@users">#{_e}</div>
    #   # <?r @users.each do |_e| ?>
    #   #   <div>#{_e}</div>
    #   # <?r end ?>
    #
    # How to add new morphs:
    #   Nagoro::Pipe::Morph['until'] = [
    #     '<?r %morph %expression ?>', '<?r end ?>' ]

    class Morph < Base
      MORPHS = {
        'each'    => [ '<?r %expression.%morph do |_e| ?>', '<?r end ?>' ],
        'times'   => [ '<?r %expression.%morph do |_t| ?>', '<?r end ?>' ],
        'filter'  => [ '<?r %expression(%<', '>) ?>' ],
        'if'      => [ '<?r %morph %expression ?>', '<?r end ?>' ],
        'unless'  => [ '<?r %morph %expression ?>', '<?r end ?>' ],
        'foreach' => [ '<?r for %expression ?>', '<?r end ?>' ],
      }

      def tag_start(tag, original_attrs, value_attrs)
        morphs = value_attrs.keys & MORPHS.keys
        return super if morphs.empty?

        if morphs.size > 1
          raise "Cannot transform multiple morphs: #{value_attrs.inspect} in <#{tag}>"
        elsif morphs.size == 1
          morph = morphs.first
          value = value_attrs.delete(morph)
          original_attrs.delete(morph)
          open = MORPHS[morph][0]

          append open.gsub(/%morph/, morph).gsub(/%expression/, value)
          @stack << [tag, morph]
          super
        end
      end

      def tag_end(tag)
        super
        prev, morph = @stack.last
        return unless prev == tag
        append(MORPHS[morph][1])
        @stack.pop
      end

      class << self
        def []=(key, value)
          MORPHS[key] = value
        end

        def [](key)
          MORPHS[key]
        end
      end
    end
  end
end
