#!/bin/sh

values_file="$1/values.yaml"
chart_file="$1/Chart.yaml"
yq eval ".image.tag = \"$2\"" -i "$values_file"
yq eval ".appVersion = \"$2\"" -i "$chart_file"

current_version=$(yq eval '.version' "$chart_file")
new_version=$(echo "$current_version" | awk -F. '{OFS="."; $3=$3+1; print}')
yq eval ".version = \"$new_version\"" -i "$chart_file"
