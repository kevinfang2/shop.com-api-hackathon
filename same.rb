require 'rubygems'
require 'rest_client'
require 'cgi'
url = 'https://api.shop.com/AffiliatePublisherNetwork/v1/categories'
headers  = { 'apikey' => 'l7xxa85a2511a8454491ac39f7a02cab7eb8' , :params => { CGI::escape('publisherID') => 'TEST',CGI::escape('locale') => 'en_US' } }
response = RestClient::Request.execute :method => 'GET', :url => url , :headers => headers
puts response
