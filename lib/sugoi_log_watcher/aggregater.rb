module SugoiLogWatcher
  class Aggregater
    def initialize
      @buffer = []
      @compited = []
    end

    def add(line)
      @buffer << SugoiLogWatcher::LineParser.new(line).parse
    end

    def complated
      @compited
      [1]
    end

    def buffer
      @buffer
    end

    def aggregate
      chunk = {}
      @buffer.each { |object| (chunk[object.pid] ||= []); chunk[object.pid] << object }
      valid_request = {}
      chunk.each do |pid, objects|
      end
    end
  end
end
