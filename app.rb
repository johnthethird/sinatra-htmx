## The App ##
# The meat of your little app goes here.

# Grab some sample data and keep it around in memory to search against
USERS = YAML.load_file('users.yaml')['results'].map{|u|
  {
    name: "#{u['name']['first']} #{u['name']['last']}",
    email: u['email'],
    avatar: u['picture']['medium']
  }
}.sort{|a,b| a[:name] <=> b[:name]}

# Serve main index page
get '/' do
  erb :index
end

# Do a search and return HTML snippet of the results
post '/q' do
  selected_users = params['q'] ? (USERS.select{|u| u[:name] =~ /#{Regexp.quote(params['q'])}/i}) : []
  erb :_results, {locals: {selected_users: selected_users}}
end
