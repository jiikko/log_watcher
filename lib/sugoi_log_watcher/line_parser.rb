module SugoiLogWatcher
  class SQLObject
    attr_accessor :path, :raw_data, :msec, :pid, :type

    def initialize(params)
      @raw_data = params[:raw_data]
      @pid = params[:pid]
      @type = params[:type]
    end
  end

  class LineParser
    def initialize(line)
      @line = line
    end

    def parse
      params = {}
      params[:raw_data] = @line
      params[:type] =
        case
        when /INFO -- : Started/ =~ @line
          :start
        when /INFO -- : Completed/ =~ @line # TODO 302
          :end
        else
          :message
        end
      %r!\[(.+?)\s\#(\d+?)\]! =~ @line
      timestamp = $1
      pid = $2

      case instance_of(@line)
      when :sql
        SQLObject.new(
          params.merge(pid: pid)
        )
      else
        PersedObject.new(
          params.merge(pid: pid)
        )
      end
    end

    def valid?
      ignore_patterns = [
        /rack-timeou/,
        ]
      ignore_patterns.each do |pattern|
        if pattern =~ @line
          return false
        end
      end
      return true
    end

    private

    def instance_of(line)
      case
      when line.include?('Load') && line.include?('SELECT')
        :sql
      else
        :other
      end
    end
  end
end
