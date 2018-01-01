require 'websocket-client-simple'
require 'json'
require 'dotenv'

Dotenv.load

ACCESS_TOKEN = ENV['MASTODON_ACCESS_TOKEN']

url = "https://friends.nico/api/v1/streaming?access_token=#{ACCESS_TOKEN}&stream=public:local"

begin
  ws = WebSocket::Client::Simple.connect(url)
rescue => e
  puts "error: #{e}"
else
  ws.on :message do |msg|
    toot = JSON.parse(msg.data)
    if toot['event'] == "update"
      body = JSON.parse(toot["payload"])
      d_name = body['account']['display_name']
      content = body['content']
      puts d_name + " : " + content[3...-4] # <p>content</p>のpタグを削除
    end
  end

  ws.on :open do
    puts "streaming open"
  end

  ws.on :close do |e|
    puts "close"
    p e
    exit 1
  end

  ws.on :error do |e|
    p e
  end
end

loop do
 sleep 1
end
