module SugoiLogWatcher
  class RenderingObject
    def initialize(params)
      @path = params[:path]
      @raw_data = params[:row_data]
      @msec = params[:msec]
      @pid = params[:pid]
    end
  end
end
