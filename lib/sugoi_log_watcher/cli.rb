module SugoiLogWatcher
  module Cli
    def self.start(cmd_args)
      @path = cmd_args.first
      if cmd_args.empty?
        raise(SugoiLogWatcher::EmptyCmdArgs, '引数を指定してください')
      end
      if cmd_args.first == '--help'
        puts <<~EOH
          usage: log_watcher [log_file] [--help]
        EOH
        return
      end
      if cmd_args[1] == '--debug'
        @debug_mode = true
      end
      if @debug_mode
        puts 'start(debug)'
      else
        puts 'start'
      end

      start_watching
    end

    def self.start_watching
      aggregater = SugoiLogWatcher::Aggregater.new
      f = File.open(@path, 'r')
      f.seek(0, IO::SEEK_END)

      t = Thread.start do
        loop do
          aggregater.aggregate
          sleep(0.5)
        end
      end

      loop do
        select([f]) # blockしない
        begin
          line = f.readline
          aggregater.add(line)
        rescue EOFError => e
          sleep(0.5)
        end
      end
      t.join
    end
  end
end
