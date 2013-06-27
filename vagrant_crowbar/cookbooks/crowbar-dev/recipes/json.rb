
bash "sudo json gem install" do
	environment node["my_env"]
	#user node.props.guest_username
	cwd "/home/#{node.props.guest_username}"
	code <<-EOH
gem install json
EOH
	not_if "gem list json | grep json"
end	
#source $HOME/.rvm/scripts/rvm
#env > /tmp/juddjson
