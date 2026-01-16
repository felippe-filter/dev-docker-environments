#!/bin/bash


containers=("proxy" "auth_service" "auth_users" "api" "app" "mysql" "payment" "customer_app")
historyFolderPath=.bash_history

if [ ! -d $historyFolderPath ]; then
  echo "Setting Up bash history folder"
  mkdir -p -m 775 "$historyFolderPath"
fi

for container in "${containers[@]}"; do
  file="$historyFolderPath"/."$container"_history
  if [ ! -f "$file" ]; then
    echo "Setting Up bash history file: $file"
    touch "$file"
  fi
done

if [ ! -f .env ]; then
  echo "Creating .env file"
  cp .env.exemple .env
fi
