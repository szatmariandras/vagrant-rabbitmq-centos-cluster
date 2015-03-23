# What is this?

Creates a two-node cluster of RabbitMQ 3.5.0 with CentOS 6.6, including monitoring to Graphite and Datadog.

## Requirements

 - vagrant
 - vagrant cachier plugin
 - vagrant hostmanager plugin
 - puppet, facter

## Installation

If you don't have requirements installed yet, you can do it like this:

##### 1. Install homebrew

`ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`

##### 2. Install homebrew cask

`brew install caskroom/cask/brew-cask`

##### 3. Install VirtualBox, vagrant, vagrant manager and vagrant cachier and hostmanager plugins

`brew cask install virtualbox`

`brew cask install vagrant`

`brew cask install vagrant-manager`

`vagrant plugin install vagrant-cachier`

`vagrant plugin install vagrant-hostmanager`

##### 4. Usage

Clone the repository.
Change the default config if you need: copy `config.local.example` as `config.example`, and update the config values you can see in `Vagrantfile`.
From the root of this repository, run the following command:

`vagrant up`

Now you have two vagrant boxes, both containing a RabbitMQ node, and the two nodes creating a cluster. You can reach the two machines at `rabbit1.vagrant.local` and `rabbit2.vagrant.local`

## Installing a cluster of Amazon Linux nodes on EC2

##### 1. Create the instances
Assign elastic IPs to all instances, then create a CNAME for the instances, because the IP or the Public DNS, which also contains the ip is harder to manage or just keep in mind.
Then on each instance, do the following steps:
##### 2. Install puppet on the instances
 - needed for run to run puppet installed from rubygems: `sudo sh -c 'echo PATH=$PATH:/usr/local/bin > /etc/profile.d/rubypath.sh'`
 - yum installs puppet 2 and facter 1.6, which is too old for us, so let's install it from rubygems: `sudo gem install puppet`

##### 3. Install git, and clone this repository
 - `sudo yum install git`
 - clone this repository somewhere, like `~/puppet`

##### 4. From the root of the repository, apply puppet manifest to the server

 - `sudo -s`
 - `./init.sh`
 
Just enter the values for the parameters, and puppet will handle to others. You can see some additional description on the parameters below.

##### You can also run puppet manually, if you prefer entering 500 character long commands:

Parameterize the command using the following parameters. All parameters must passed before the `puppet` command with `FACTER_` prefix. For example:

 - `FACTER_nodename=#NODENAME# FACTER_cluster_nodes=#CLUSTER_NODES# puppet apply --modulepath=./modules manifests/default.pp`

The following parameters exist:

 - nodename: the FQDN of the server, the CNAME you gave it in first step, like `rabbitmq-001.your.domain.com`. This one will vary from server to server.
 - cluster_nodes: the comma separated list of the FQDNs of all the servers you want in the cluster, like `rabbitmq-001.your.domain.com,rabbitmq-002.your.domain.com,rabbitmq-003.your.domain.com`. This one will be the same for all the servers.
 - install_graphite (optional): pass `true` to install Graphite on the current server
 - monitor_to_graphite (optional): pass `true` to enable monitoring to Graphite
 - graphite_host (optional): if monitoring to Graphite enabled, pass the host name of Graphite server to report stats to (if use passed `true` as `install_graphite`, it will be the current hostname)
 - graphite_port (optional): if monitoring to Graphite enabled, pass the port of the Graphite server (if you installed Graphite with this repo, you want to pass `2003` here)
 - datadog_enabled (optional): pass `true`, if you want to enable reporting to [DataDog](https://www.datadoghq.com/)
 - datadog_api_key optional): if `datadog_enabled` is `true`, pass here your DataDog API key.