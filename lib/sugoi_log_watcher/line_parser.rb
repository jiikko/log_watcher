module SugoiLogWatcher
  class LineParser
    def initialize(line)
      @line = line
    end

    def parse
      case
        when rendering_log?
          parse_rendering_log
        when sql_log?
          parse_query_log
        else
          raise "unknown log"
        end
    end

    def rendering_log?
      true
    end

    def sql_log?
    end

    def parse_rendering_log
      RenderingObject.new({})
    end
  end
end
