#!/usr/bin/env bash

models="$(ls models/ggml*.bin)"
audio_file="$1"

# Exit if invalid audio file is passed
[[ ! -f "$audio_file" ]] && echo "Invalid audio file" && exit 1 

function run_on_model() {
  local sel_model=$1
  local sel_audio=$2
  trim $(./main --no-timestamps --language en -m $sel_model -f $sel_audio 2> /dev/null)
}

for model in $models; do
  start=`date +%s`
  output=$(run_on_model $model $audio_file)
  end=`date +%s`
  duration=$(($end-$start))
  echo -e "$model(${duration}s):\t\t"
  echo "${output}" | tee /tmp/$(basename $model)_${start}.txt 
done
