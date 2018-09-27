class ErrorReport
  attr_accessor :line_number, :json, :exception

  def initialize(params = {})
    self.line_number = params[:line_number]
    self.json = params[:json]
    self.exception = params[:exception]
  end
end
