module SugoiLogWatcher
  class Notification
    def found_n1_queries
      puts 'Found N+1'
    end

    def notify(request)
      TerminalNotifier.notify("#{request.responsetime[:total]}ms かかったよ", :group => Process.pid)
    end
  end
end
