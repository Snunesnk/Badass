#!/bin/bash

# Apply the configuration to the containers
running_containers=$(docker ps -q)
if [[ ! -z $running_containers ]]; then
    for i in ${running_containers[@]}; do
        container_info=$(echo "$i:$(docker exec $i hostname)")
        hostname=${container_info#*:}
        container_id=${container_info%:*}
        case $hostname in
            snunes-router-*|snunes-host-*)
                filename="$hostname.sh"
                sudo docker cp "./setups/$filename" "$container_id:/"
                sudo docker exec "$container_id" ash "/$filename" $1
                echo "$hostname done"
                ;;
        esac
    done
    exit 0
else
    echo "No running containers"
    exit 1
fi
