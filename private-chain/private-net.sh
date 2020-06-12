#!/bin/bash

UP_DOWN="$1"
function networkUp() {
    nohup ./geth  --datadir "./data" --allow-insecure-unlock --nodiscover --rpc --rpcapi "db,eth,net,web3,miner,personal" --networkid 2020 --mine --minerthreads=1 --etherbase "0xA522b056dB259D88a5D1c90c52466e129a8dFD95" > geth.log 2>&1 &
    if [ $? -ne 0 ]; then 
        echo "Error !!!! unable to start geth"
	exit 1
    else 
	echo "ALL GOOD geth start up "
    fi

}


function networkDown() {
    geth_pid=$(ps -ef | grep geth | grep -v grep | awk '{print $2}')

    if [ -z "$geth_pid" ]; then 
        echo "not find geth pid"
    else
        echo "find geth pid：${geth_pid}" 
        kill -9 ${geth_pid}
	if [ $? -ne 0 ]; then 
		echo "stop geth Error, pleasse stop by hands"
		exit 1
	else 
		echo "STOP ALL GOOD"
	fi
    fi

    
}

function printHelp() {
    echo "Usage: ./eth_main.sh <up | down | restart>"
}

if [ "$UP_DOWN" == "up" ]; then 
    networkUp
elif [ "$UP_DOWN" == "down" ]; then
    networkDown
elif [ "$UP_DOWN" == "restart" ]; then
    networkDown
    networkUp
else
    printHelp
    exit 1
fi






 

