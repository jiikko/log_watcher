module SugoiLogWatcher
  module Cli
    def self.start(cmd_args)
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
    end
  end
end
