class BlockBadSpider
  def initialize(app)
    @app = app
  end

  def call(env)
    bad_spider_keywords = ["Alibaba.Security.Heimdall"] # put more here is found other bad spider
    # how to test: `curl -A 'Alibaba.Security.Heimdall' "http://localhost:3000"`
    is_bad_spider = bad_spider_keywords.any? { |keyword| env["HTTP_USER_AGENT"].include?(keyword) }

    if env["HTTP_USER_AGENT"].downcase.include?("spider") &&
     env['CONTENT_TYPE'] == 'application/x-www-form-urlencoded' &&
     env['REQUEST_METHOD'] == 'GET' &&
     env['rack.input'] != nil &&
     env["rack.request.form_input"] == env["rack.input"] &&
     env["rack.request.form_vars"] != nil &&
     (env["rack.request.form_hash"] == nil) || (env["rack.request.form_vars"] == 'NULL') # use 'NULL' make it easy to test with `curl`
      acts_as_bad_spider = true
    else
      acts_as_bad_spider = false
   end

   if is_bad_spider or acts_as_bad_spider

      # return 406 error when some request header is invalid
      # https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#4xx_Client_Error
      # 406 Not Acceptable
      [406, {}, ["The requested resource is only capable of generating content not acceptable according to the Accept headers sent in the request (406)"]]
    else
      @app.call(env)
    end
  end
end
