#!/bin/bash

# Get all cluster nodes and format
nodes=$(kubectl get nodes -o jsonpath='{.items[*].metadata.name}')

for node in $nodes; do
    # get node ip
    node_ip=$(kubectl get node "$node" -o jsonpath='{.status.addresses[?(@.type=="InternalIP")].address}')

    if [[ -z "$node_ip" ]]; then
        echo "Couldn't find $node ip"
        continue
    fi

    echo "$node: $node_ip"
    ssh "$node_ip" "ip a | grep -E 'inet.*(nebula)'"
done
