module SugoiLogWatcher
  class Notification
    def notify(request)
      unless request.n1_queries.empty?
        TerminalNotifier.notify(message_n1_queries(request), group: Process.pid)
      end
    end

    private

    def message_n1_queries(request)
      <<~EOH
        #{request.request_path} で N+1 がみつかりました
      EOH
    end
  end
end
