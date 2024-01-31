#!/bin/bash

# Apply the configuration to the containers
running_containers=$(docker ps -q)
if [[ ! -z $running_containers ]]; then
    for i in ${running_containers[@]}; do
        container_info=$(echo "$i:$(docker exec $i hostname)")
        hostname=${container_info#*:}
        container_id=${container_info%:*}
        case $hostname in
            snunes-router-*|host-snunes-*)
                filename=$hostname
                ext=".sh"
                # check if hostname is router
                if [[ $hostname == snunes-router-* ]]; then
                    sudo docker cp "./confs/$filename-frr$ext" "$container_id:/"
                    sudo docker exec "$container_id" ash "/$filename-frr$ext"
                fi
                sudo docker cp "./confs/$filename$ext" "$container_id:/"
                sudo docker exec "$container_id" ash "/$filename$ext"
                echo "$hostname done"
                ;;
        esac
    done
    exit 0
else
    echo "No running containers"
    exit 1
fi
