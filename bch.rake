
url = "http://47.75.7.181:8332/rest/chaininfo.json"
r = Typhoeus.get(url)
data = JSON.parse(r.response_body)


header = data["headers"]
block = data["block"]
block_hash = data["bestblockhash"]
difficulty = data["difficulty"]



url_block = "http://47.75.7.181:8332/rest/block/notxdetails/#{block_hash}.json"


b_r = Typhoeus.get(url_block)
block_data = JSON.parse(b_r.response_body)
