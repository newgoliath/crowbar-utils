# install extra packages
node.props.attribute?('guest_extra_packages') && node.props.guest_extra_packages.split.each do | p |
	package "#{p}" do
		action :upgrade
	end
end

envhash = { "LOGNAME" => "#{node.props.guest_username}", 'HOME' => "/home/#{node.props.guest_username}" }

# install lots of vim stuff that Judd likes:
execute "vim installs pathogen" do
  environment envhash
	user node.props.guest_username
	command "mkdir -p ~/.vim/autoload ~/.vim/bundle; curl -Sso ~/.vim/autoload/pathogen.vim https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim"
	creates "/home/#{node.props.guest_username}/.vim/autoload/pathogen.vim"
	action :run
end

{
	'vim-fugitive' => 'https://github.com/tpope/vim-fugitive.git',
	'nerdtree' => 'https://github.com/scrooloose/nerdtree.git',
  'vim-nerdtree-tabs' => 'https://github.com/jistr/vim-nerdtree-tabs',
}.each_pair do | name, repo |
	execute "vim install #{name}" do
    environment envhash
		user node.props.guest_username
		command "cd ~/.vim/bundle; git clone #{repo}"
		action :run
		creates "/home/#{node.props.guest_username}/.vim/bundle/#{name}"
	end
end

template "/home/#{node.props.guest_username}/.vimrc" do
	source "vimrc"
	mode 0777
	owner "#{node.props.guest_username}"
	variables ({
		:username => node.props.guest_username
	})
end


