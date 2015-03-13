# What is this?

Creates a two-node cluster of RabbitMQ 3.5.0 with CentOS 6.6.

## Requirements

 - vagrant
 - vagrant cachier plugin
 - puppet, facter

## Installation

If you don't have requirements installed yet, you can do it like this:

### Install homebrew

`ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`

### Install homebrew cask

`brew install caskroom/cask/brew-cask`

### Install VirtualBox, vagrant, vagrant manager and vagrant cachier plugin

`brew cask install virtualbox`

`brew cask install vagrant`

`brew cask install vagrant-manager`

`vagrant plugin install vagrant-cachier`

## Usage

From the root of this repository, run the following command:

`vagrant up`

Now you have two vagrant boxes, both containing a RabbitMQ node, and the two nodes creating a cluster. You can reach the two machines at `rabbit1.vagrant.local` and `rabbit2.vagrant.local`