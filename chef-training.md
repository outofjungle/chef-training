# Chef Workshop
### April 24, 2013

## Bootstrap
1. Install chef
2. git clone https://github.com/opscode/chef-repo.git
3. cd chef-repo
4. download credentials into .chef dir
5. knife bootstrap NODE.HOSTNAME

## Install apache
6. knife cookbook create apache
7. edit ./cookbooks/apache/recipes/default.rb

 		package "apache2" do
  			action :install
		end

		service "apache2" do
			action [ :start, :enable ]
		end

		cookbook_file "/var/www/index.html" do
			source "index.html"
  			mode "0644"
		end

8. edit ./cookbooks/apache/files/default/index.html
	
		<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML//EN">
		<html> <head>
		<title>Hello!</title>
		</head>
		<body>
		<h1></h1>
		Is that me you are looking for!
		<hr>
		<address></address>
		<!-- hhmts start -->Last modified: Wed Apr 24 13:23:38 PDT 2013 <!-- hhmts end -->
		</body> </html>

9. knife cookbook upload apache
10. knife cookbook list
11. knife node edit NODE.HOSTNAME

		{
  			"name": "NODE.HOSTNAME",
			"chef_environment": "_default",
  			"normal": {
		    	"tags": [
    			]
			},
		   "run_list": [
    			"recipe[apache]"
  			]
		}

12. `on node` sudo chef-client -Fdoc -lfatal
13. ohai, the command to show the system attributes

## Downloadable Cookbooks
14. knife cookbook site download chef-client
15. tar -zvxf chef-client-2.2.2.tar.gz -C cookbooks
16. knife cookbook upload chef-client [ERROR]
17. knife cookbook site download cron
18. tar -zvxf cron-1.2.2.tar.gz -C cookbooks
19. knife cookbook upload cron
20. knife cookbook upload chef-client

## Roles
21. edit roles/base.rb

		name "base"
		description "Base role applied to all node."
		run_list (
	    	"recipe[chef-client::delete_validation]"
		)

22. knife role from file base.rb
23. knife role show base
24. knife node list
25. knife node run_list add NODE.HOSTNAME "role[base]"
26. knife node show NODE.HOSTNAME
27. knife ssh role:base "sudo chef-client" -x USERNAME

## MOTD tail Cookbook
28. knife cookbook site download motd-tail
29. tar -zvxf motd-tail-1.2.0.tar.gz -C cookbooks
30. edit roles/base.rb

		name "base"
		description "Base role applied to all node."
		run_list [
	    	"recipe[chef-client::delete_validation]",
	    	"recipe[motd-tail]"
		]

31. edit chef-repo/cookbooks/motd-tail/templates/default/motd.tail.erb

		***
		Chef-Client - <%= node.name %>
		Hostname: <%= node['cloud'] ? node['cloud']['public_hostname'] : node['fqdn'] %>
		<% if ! Chef::Config[:solo] -%>
		Chef Server: <%= Chef::Config[:chef_server_url] %>
		<% end -%>
		<% if node.chef_environment != '_default' -%>
		Environment: <%= node.chef_environment %>
		<% end -%>
		Last Run: <%= ::Time.now %>

		Roles:
		<% node['roles'].each do |role| -%>
		  <%= role %>
		<% end -%>
		<% if node['tags'] && !node['tags'].empty? -%>

		Tags:
		<% node['tags'].each do |tag| -%>
		  <%= tag %>
		<% end -%>
		<% end -%>
		***

		<%= node['motd-tail']['additional_text'] %>

32. knife role from file base.rb
33. knife ssh role:base "sudo chef-client" -x opscode

## Sudo
34. knife cookbook site download sudo
35. tar -xvzf sudo-2.0.4.tar.gz -C cookbooks
36. knife cookbook upload sudo
37. edit roles/base.rb

		name "base"
		description "Base role applied to all node."
		run_list(
	    	"recipe[chef-client::delete_validation]",
	    	"recipe[motd-tail]",
	    	"recipe[sudo]"
		)
		
		default_attributes(
			"authorization" => {
        		"sudo" => {
            		"users" => ["opscode"],
		            "groups" => ["admin", "sudo"],
        		    "passwordless" => true
        		}
    		}
		)
		
37. knife role from file base.rb
38. knife ssh role:base "sudo chef-client" -x opscode

## users
39. knife cookbook site download users
40. tar -xvzf users-1.4.0.tar.gz -C cookbooks
41. knife cookbook upload users
42. add new file data_bags/users/ven.json

		{
    		"id": "ven",
		    "groups": ["sysadmin"],
		    "uid": 2001,
		    "shell": "/bin/bash",
		    "comment": "Ven"
		}

43. knife data bag create users
44. knife data bag from file users ven.json
45. knife data bag list
46. knife data bag show users
47. knife data bag show users ven
48. knife ssh role:base "sudo chef-client" -x opscode




