#!/usr/bin/env bash

## delete all namespace which all stuck in Terminationg
## link from https://stackoverflow.com/questions/52369247/namespace-stuck-as-terminating-how-do-i-remove-it
## chmod +x delete_stuck_ns.sh

function delete_namespace () {
    echo "Deleting namespace $1"
    kubectl get namespace $1 -o json > tmp.json
    sed -i 's/"kubernetes"//g' tmp.json
    kubectl replace --raw "/api/v1/namespaces/$1/finalize" -f ./tmp.json
    rm ./tmp.json
}

TERMINATING_NS=$(kubectl get ns | awk '$2=="Terminating" {print $1}')

for ns in $TERMINATING_NS
do
    delete_namespace $ns
done