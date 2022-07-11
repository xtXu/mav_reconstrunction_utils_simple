#!/bin/bash

# *** Args (need to be set) ***
n_experiments=6
target_dir="/home/xxt/maze_data/EXPLORE"		# Can reuse same dir to add experiments
clear_voxblox_maps=true		# Irreversibly remove maps after evaluation to save disk space
experiment=3		# For auto configs of exp1/2 (city/windmill)

if [[ $# -eq 1 ]]; then
  n_experiments=$1
fi

# *** Run experiments ***
echo "Starting experiment${experiment} series of ${n_experiments} runs at '${target_dir}'!"

# Create dir
if [ ! -d "$target_dir" ]; then
  mkdir $target_dir
fi

# Use auto config for experiments (to make sure nothing can go wrong!)
if [[ $experiment == 1 ]]; then
  cfg="MyCityBuilding.yaml"
  planner="planners/reconstruction_planner.yaml"
  freq=30
  dur=30
  pcl="/home/xxt/unreal_exploration_game/Worlds/CityBuilding/gt_surface_pcl.ply"
elif [[ $experiment == 2 ]]; then
  cfg="MyMaze.yaml"
  planner="planners/reconstruction_planner.yaml"
  freq=30
  dur=30
  pcl="/"
elif [[ $experiment == 3 ]]; then
  cfg="MyMaze.yaml"
  planner="planners/exploration_planner.yaml"
  freq=30
  dur=30
  pcl="/"
fi

# Run the experiments
for (( i=1; i<=n_experiments; i++ ))
do  
  # run experiment
  roslaunch active_3d_planning_app_reconstruction run_experiment.launch data_directory:=$target_dir record_data:=true experiment_config:=$cfg data_frequency:=$freq time_limit:=$dur planner_config:=$planner
  # run spiral
  # roslaunch mav_active_3d_planning run_spiral.launch data_directory:=$target_dir
  # evaluate
   roslaunch active_3d_planning_app_reconstruction evaluate_experiment.launch experiment_config:=$cfg target_directory:=$target_dir method:=recent series:=false clear_voxblox_maps:=$clear_voxblox_maps gt_file_path:=$pcl evaluate_volume:=true
done

# roslaunch active_3d_planning_app_reconstruction evaluate_citybuilding.launch target_directory:=$target_dir series:=true 
