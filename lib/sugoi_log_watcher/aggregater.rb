module SugoiLogWatcher
  class Request
    attr_accessor :valid, :logs
    def initialize
      self.logs = []
    end
  end

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
      valid_requests = []
      chunk.each do |pid, objects|
        request = Request.new
        request.valid = false
        valid_requests << request
        objects.each do |object|
          request.logs.push(object)
          if object.type == :start
            request.valid = true
          end
          if object.type == :end
            break
          end
        end
      end
      valid_requests.find_all(&:valid)
    end
  end
end
