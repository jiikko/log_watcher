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
      @line
      %r!\#(\d+?)\][^:]+?:   Rendered (.+?) \(([0-9.]+?)ms\)! =~ @line
      pid = $1
      path = $2
      msec = $3
      RenderingObject.new({
        pid: pid, path: path, msec: msec
      })
    end
  end
end
