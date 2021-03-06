class ApiConstraints
  def initialize(options)
    @version = options[:version]
    @default = options[:default]
  end

  def matches?(req)
    @default ||
      (req.respond_to?('headers') &&
       req.headers.key?('Accept') &&
       req.headers['Accept'].include?(
         "application/vnd.blog_api.v#{@version}"))
  end
end
