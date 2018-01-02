module SugoiLogWatcher
  class PersedObject
    attr_accessor :path, :raw_data, :msec, :pid, :type

    def initialize(params)
      @path = params[:path]
      @raw_data = params[:raw_data]
      @msec = params[:msec]
      @pid = params[:pid]
      @type = params[:type]
    end
  end
end
