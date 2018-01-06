module SugoiLogWatcher
  class LineParser
    def initialize(line)
      @line = line
    end

    def parse
      params = {}
      # ANSI Escape Sequenceの削除
      params[:raw_data] = @line.gsub(/\e\[\d{1,3}[mK]/, '')
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

      klass_for(@line) do |klass|
        klass.new(params.merge(pid: pid))
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

    def klass_for(line)
      klass =
        case
        when line.include?('Load') && line.include?('SELECT')
          ParsedObject::SQL
        else
          ParsedObject::General
        end
      yield(klass)
    end
  end
end
