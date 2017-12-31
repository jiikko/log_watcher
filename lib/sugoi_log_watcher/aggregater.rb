module SugoiLogWatcher
  class Aggregater
    def initialize
      @buffer = []
      @compited = []
    end

    def add(line)
      @buffer << line
    end

    def complated
      @compited
      [1]
    end

    def buffer
      @buffer
    end

    def aggregate
      # TODO
      # ここで
    end
  end
end
