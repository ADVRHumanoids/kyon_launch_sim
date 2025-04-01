ros1(){
    SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
    cd $SCRIPT_DIR
    xhost +local:root
    echo "Running docker image from $PWD..."
    docker compose -p kyon-cetc-focal-ros1 up ${1:-dev} -d --no-recreate
    docker compose -p kyon-cetc-focal-ros1 exec ${1:-dev} bash
}