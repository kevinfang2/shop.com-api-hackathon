from urllib2 import Request, urlopen
from urllib import urlencode, quote_plus
url = 'https://api.shop.com:8443/AffiliatePublisherNetwork/v1/categories'
queryParams = '?' + urlencode({ quote_plus('publisherID') : 'TEST' ,quote_plus('locale') : 'en_US'  })
headers = {  'apikey':'l7xxa85a2511a8454491ac39f7a02cab7eb8'  }
request = Request(url + queryParams
, headers=headers)
request.get_method = lambda: 'GET'
response_body = urlopen(request).read()
print response_body
