class ApplicationController < ActionController::Base
    include SessionsHelper
    require 'net/http'
    require 'uri'
    require 'json'
end
