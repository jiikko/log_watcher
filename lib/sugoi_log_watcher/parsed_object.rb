module SugoiLogWatcher
  class PersedObject
    attr_accessor :path, :raw_data, :msec, :pid, :type

    def initialize(params)
      @raw_data = params[:raw_data]
      @pid = params[:pid]
      @type = params[:type]

      perse!
    end

    def perse!
      %r!Rendered (.+?) \(([0-9.]+?)ms\)! =~ @raw_data
      @path = $1
      @msec = $2
    end
  end
end
