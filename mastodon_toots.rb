require 'mastodon'
require 'dotenv'

Dotenv.load

FRIENDS_NICO_URL = 'https://friends.nico'
ACCESS_TOKEN = ENV['MASTODON_ACCESS_TOKEN']
ID = 8712
LIMIT = 40

client = Mastodon::REST::Client.new(base_url: FRIENDS_NICO_URL, bearer_token: ACCESS_TOKEN)

# 全tootを取得
options = {limit: LIMIT}
loop do
  response = client.statuses(ID, options)
  response.each do |res|
    puts res.created_at + res.content
  end

  min = response.min {|a, b| a.id <=> b.id }
  puts "next_id: #{min.id}"
  options = {max_id: min.id, limit: LIMIT} 

  break if response.size < LIMIT
end

