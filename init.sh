#!/bin/bash

if [[ $USER != "root" ]]; then
    echo "This script must be run as root!"
    exit 1
fi

ask() {
    # http://djm.me/ask
    while true; do

        if [ "${2:-}" = "Y" ]; then
            prompt="Y/n"
            default=Y
        elif [ "${2:-}" = "N" ]; then
            prompt="y/N"
            default=N
        else
            prompt="y/n"
            default=
        fi

        # Ask the question
        read -p "$1 [$prompt] " REPLY

        # Default?
        if [ -z "$REPLY" ]; then
            REPLY=$default
        fi

        # Check if the reply is valid
        case "$REPLY" in
            Y*|y*) return 0 ;;
            N*|n*) return 1 ;;
        esac

    done
}

echo "Please enter the following values:"

read -e -p "Nodename (hostname): " nodename
read -e -p "Cluster nodes: " cluster_nodes
ask "Would you like to install Graphite?" N;
install_graphite=$?
if [[ $install_graphite -eq 0 ]]
then
    install_graphite="true"
else
    install_graphite="false"
fi

ask "Would you like to monitor RabbitMQ data to Graphite?" Y;
monitor_to_graphite=$?

if [[ $monitor_to_graphite -eq 0 ]]
then
    read -e -p "Graphite host to report: " graphite_host
    read -e -p "Graphite port to report: " graphite_port
    monitor_to_graphite="true"
else
    monitor_to_graphite="false"
    graphite_host=""
    graphite_port=0
fi

ask "Would you like to enable DataDog integration?" Y;
datadog_enabled=$?

if [[ $datadog_enabled -eq 0 ]]
then
    datadog_enabled="true"
    read -e -p "Datadog API key: " datadog_api_key
else
    datadog_enabled="false"
    datadog_api_key=""
fi


echo PATH=$PATH:/usr/local/bin > /etc/profile.d/rubypath.sh
export PATH=$PATH:/usr/local/bin
echo "Installing puppet..."
gem install puppet --no-ri --no-rdoc

command="FACTER_nodename=$nodename FACTER_cluster_nodes=$cluster_nodes FACTER_install_graphite=$install_graphite FACTER_monitor_to_graphite=$monitor_to_graphite FACTER_graphite_host=$graphite_host FACTER_graphite_port=$graphite_port FACTER_datadog_enabled=$datadog_enabled FACTER_datadog_api_key=$datadog_api_key puppet apply --modulepath=./modules manifests/default.pp"
echo "Running command:"
echo $command
eval $command