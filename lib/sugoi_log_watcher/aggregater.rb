module SugoiLogWatcher
  class Request
    attr_accessor :valid, :logs, :pid
    def initialize
      self.logs = []
    end

    def remove_pid_from_logs
      self.pid = logs.first.pid
      logs.each do |log_line|
        log_line.pid = nil
      end
    end
  end

  class Aggregater
    attr_accessor :complated, :buffer
    def initialize
      @buffer = []
      self.complated = []
    end

    def add(line)
      @buffer << SugoiLogWatcher::LineParser.new(line).parse
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
          # 他のプロセスのendのみが残っている場合、削除する
          if !request.valid && object.type == :end
            request.logs = []
          end
          if request.valid && object.type == :end
            request.remove_pid_from_logs
            break
          end
        end
      end
      valid_requests.find_all(&:valid).each { |x| complated << x }
    end
  end
end
