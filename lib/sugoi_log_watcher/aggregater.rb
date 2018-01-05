module SugoiLogWatcher
  class Request
    attr_accessor :logs, :pid, :queries_count, :aggregation_status
    def initialize
      self.logs = []
    end

    def remove_pid_from_logs
      self.pid = logs.first.pid.to_i
      logs.each do |log_line|
        log_line.pid = nil
      end
    end

    def count_sql_calls
      return @queryes_map if @queryes_map
      queryes = logs.find_all { |x| x.is_a?(SugoiLogWatcher::ParsedObject::SQL) }
      queries_count = queryes.count
      queryes_map = {}
      queryes.each do |q|
        queryes_map[q.sql] ||= 0
        queryes_map[q.sql] += 1
      end
      @queryes_map = queryes_map
    end

    def started?
      aggregation_status == :start
    end

    def end?
      aggregation_status == :end
    end

    def valid?
      # TODO loop減らせる
      !logs.detect { |l| l.type == :start }.nil? && !logs.detect { |l| l.type == :end }.nil?
    end

    def n1_queries
      threshold = 3
      count_sql_calls.find_all do |sql, count|
        count > threshold
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
        valid_requests << request
        objects.each do |object|
          if object.type == :start
            request.aggregation_status = :start
          end
          request.logs.push(object) if request.started?
          # 他のプロセスのendのみが残っている場合、削除する
          if !request.started? && object.type == :end
            request.logs = []
          end
          # ログの探索を終了する
          if request.started? && object.type == :end
            request.remove_pid_from_logs
            request.count_sql_calls
            break
          end
        end
      end
      valid_requests.find_all(&:valid?).each { |x| complated << x }
    end
  end
end
