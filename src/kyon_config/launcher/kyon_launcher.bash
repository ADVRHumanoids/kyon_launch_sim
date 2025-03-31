#!/bin/bash

# Define directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Source ROS environment
if [ -f /opt/ros/noetic/setup.bash ]; then
    source /opt/ros/noetic/setup.bash
fi

# Source workspace setup if it exists
if [ -f ~/xbot2_ws/setup.bash ]; then
    source ~/xbot2_ws/setup.bash
fi

# Source docker setup if it exists
if [ -f $SCRIPT_DIR/../docker/kyon-cetc-focal-ros1/setup.sh ]; then
    source $SCRIPT_DIR/../docker/kyon-cetc-focal-ros1/setup.sh
fi

# Check if concert_launcher is installed
if ! command -v concert_launcher &> /dev/null; then
    echo "Error: concert_launcher is not installed. Please install it first."
    echo "You can install it with: pip install concert_launcher"
    exit 1
fi

# Set default configuration file
export CONCERT_LAUNCHER_DEFAULT_CONFIG=$SCRIPT_DIR/launcher_config.yaml

# Print available commands
function print_help {
    echo "Kyon Robot Launcher"
    echo "Usage: $0 [command]"
    echo ""
    echo "Available commands:"
    echo "  sim       - Start robot in simulation mode"
    echo "  real      - Start robot with real hardware"
    echo "  sim_gui   - Start simulation GUI"
    echo "  real_gui  - Start real robot GUI"
    echo "  status    - Check the status of running processes"
    echo "  kill      - Kill all running processes"
    echo "  monitor   - Show monitoring session for all processes"
    echo "  help      - Show this help message"
}

# Handle commands
case "$1" in
    sim)
        echo "Starting robot in simulation mode..."
        concert_launcher run sim_all
        ;;
    real)
        echo "Starting robot with real hardware..."
        concert_launcher run real_all
        ;;
    sim_gui)
        echo "Starting simulation GUI..."
        concert_launcher run xbot2_gui_server --params hw_type:=sim
        ;;
    real_gui)
        echo "Starting real robot GUI..."
        concert_launcher run xbot2_gui_server
        ;;
    status)
        echo "Checking status of running processes..."
        concert_launcher status
        ;;
    kill)
        echo "Killing all running processes..."
        concert_launcher kill --all
        ;;
    monitor)
        echo "Starting monitoring session..."
        concert_launcher mon
        ;;
    help|"")
        print_help
        ;;
    *)
        echo "Unknown command: $1"
        print_help
        exit 1
        ;;
esac