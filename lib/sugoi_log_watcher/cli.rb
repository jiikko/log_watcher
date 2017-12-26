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
      puts 'start'

      start_watching
    end

    def self.start_watching
      aggregater = SugoiLogWatcher::Aggregater.new
      f = File.open(@path, 'r')
      f.seek(0, IO::SEEK_END)

      loop do
        select([f]) # blockしない
        begin
          line = f.readline
        rescue EOFError => e
          sleep(1)
        end
        aggregater.add(line)
      end
    end
  end
end
