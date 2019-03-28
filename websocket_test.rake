puts "websocket-client-simple v#{WebSocket::Client::Simple::VERSION}"

url = ARGV.shift || 'wss://ws.blockchain.info/inv'

ws = WebSocket::Client::Simple.connect url

ws.on :message do |msg|
  puts ">> #{msg.data}"
end

ws.on :open do
  puts "-- websocket open (#{ws.url})"
end

ws.on :close do |e|
  puts "-- websocket close (#{e.inspect})"
  exit 1
end

ws.on :error do |e|
  puts "-- error (#{e.inspect})"
end

ws.send( '{"op":"unconfirmed_sub"}')



