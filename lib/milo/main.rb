module Milo
  class Main
    attr_accessor :main_url, :format
    attr_reader :response_raw, :response

    def initialize(key, options = {})
      @key = key
      @options = options
      @format = 'json'
    end

    def main_url
      url_prefix    = @options[:ssl] ? "https://" : "http://"
      url_postfix   = "api.x.com/milo/v3/"
      url_prefix + url_postfix
    end

    def self.to_json(function_name, input)
      if input.is_a?(String)
        input
      else
        input.to_json({:root => function_name})
      end
    end

    def params_list(list)
      params = "?" + list.map do |k, v|
        if v.is_a?(Array)
          v.map do |val|
            "#{k}[]=#{val}"
          end.join("&")
        else
          "#{k}=#{v}"
        end
      end.join("&")
    end

    def make_request(end_url)
      result_key = end_url.include?("?") ? "&key=#{@key}" : "?key=#{@key}"
      curl = Curl::Easy.new(main_url + end_url + result_key)

      if curl.body_str == "<error>A friendly explanation of what went wrong</error>"
        return "string" #raise CouldNotAuthenticateYou
      end
      Response.new(curl, format)
    end

    class Response

      attr_reader :status, :body, :headers_raw, :headers, :curl, :url, :data

      def initialize(curl, format)
        @format=format
        @curl = curl
        @url = curl.url
        @status = curl.response_code
        @body = curl.body_str
        @headers_raw = curl.header_str
        parse_headers
      end

      def parse_headers
        hs={}
        return hs if headers_raw.nil? or headers_raw==""
        headers_raw.split("\r\n")[1..-1].each do |h|
#          Rails.logger.info h
          m=h.match(/([^:]+):\s?(.*)/)
          next if m.nil? or m[2].nil?
#          Rails.logger.info m.inspect
          hs[m[1]]=m[2]
        end
        @headers=hs
      end

    end

    include Milo::Product
  end
end