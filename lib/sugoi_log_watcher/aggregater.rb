module SugoiLogWatcher
  class Request
    attr_accessor :valid, :logs, :pid
    def initialize
      self.logs = []
    end

    def remove_pid_from_logs
      self.pid = logs.first.pid.to_i
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
      line_parser = SugoiLogWatcher::LineParser.new(line)
      if line_parser.valid?
        @buffer << line_parser.parse
      end
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
          if object.type == :start
            request.valid = true
          end
          request.logs.push(object) if request.valid
          # 他のプロセスのendのみが残っている場合、削除する
          if !request.valid && object.type == :end
            request.logs = []
          end
          # ログの探索を終了する
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
