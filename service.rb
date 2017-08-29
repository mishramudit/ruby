require 'rubygems'
require 'sinatra'
require 'json'
require 'net/http'
require 'sqlite3'


set :port, 6055
before do
content_type :json
headers 'Access-Control-Allow-Origin' => '*',
'Access-Control-Alow-Methods' => ['OPTIONS','GET']
end

set :protection, false

# get request for list of all restaurants
get '/getList' do
@key = params[:key]
@page = params[:page]
if @key == "qwerty12345asdfghjkl12345zxcvbn12"
db = SQLite3::Database.new $dbPath          #Opening Database
db = SQLite3::Database.open $dbPath
db.results_as_hash = true
queryOutData = db.execute(String.new("select a.* from (select id, seq, name, description, rating, address from restaurents LIMIT '#{@page}'*2) a order by seq desc limit 2
"))

for i in 0..5
queryOutData[0].delete(i)
queryOutData[1].delete(i)
end
queryOutData[0].delete("seq")
queryOutData[1].delete("seq")

else
	queryOutData = {"error" =>"invalid key"}
end
return JSON.pretty_generate(queryOutData)

end

#get request for get perticular restaurant details
get '/getDetails' do
@id = params[:id]
@key = params[:key]

if @key == "qwerty12345asdfghjkl12345zxcvbn12"
db = SQLite3::Database.new $dbPath          #Opening Database
db = SQLite3::Database.open $dbPath
queryOutData = db.execute(String.new("select * from restaurents where id = '#{@id}'"))

else
	queryOutData = {"error" =>"invalid key"}
	return JSON.pretty_generate(queryOutData)
end

return JSON.pretty_generate({"id"=>queryOutData[0][0],"name"=>queryOutData[0][1],"description"=>queryOutData[0][2],"menu category"=>queryOutData[0][5],"tags"=>queryOutData[0][6]})
end


class RestDetailsLogic
def initialize
  
  $dbPath = "restaurants.db"

end
end
RestDetailsLogic.new