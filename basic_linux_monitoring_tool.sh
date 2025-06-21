#!/usr/bin/env bash

echo "=== User Session Audit ==="

# Last 10 sessions
echo -e "\n-- Last Connected Users --"
last | grep -vE "reboot|wtmp" | head -n 10

# Who’s currently logged in
echo -e "\n-- Currently Logged-In Users --"
w

# Recent commands from user histories
echo -e "\n-- Recent Commands from Shell History --"
for home in /home/* /Users/*; do
  if [ -d "$home" ]; then
    user=$(basename "$home")
    for histfile in "$home/.bash_history" "$home/.zsh_history"; do
      if [ -r "$histfile" ]; then
        echo "History for $user ($(basename $histfile)):"
        tail -n 10 "$histfile" | sed 's/^/  /'
        echo
      fi
    done
  fi
done

echo "=== End of User Session Audit ==="
