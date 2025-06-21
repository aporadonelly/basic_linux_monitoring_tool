#!/bin/bash

echo "=== User Session Audit ==="

# 1. Last connected users (login & logout times)
#    `last -F` shows login and logout for each session
echo -e "\n-- Last Connected Users --"
last -F | grep -v "system boot" | head -n 10

# 2. Current sessions (so you can see who’s still logged in)
echo -e "\n-- Currently Logged-In Users --"
w

# 3. What they did:
#    a) Shell history (best-effort; users can edit their history)
echo -e "\n-- Recent Commands from Bash History --"
for user_home in /home/*; do
  user=$(basename "$user_home")
  histfile="$user_home/.bash_history"
  if [ -r "$histfile" ]; then
    echo "History for $user:"
    tail -n 10 "$histfile" | sed 's/^/  /'
  fi
done

#    b) (Optional) Auditd execve logs — more reliable, but requires auditd setup
if command -v ausearch &>/dev/null; then
  echo -e "\n-- auditd: Recent Executed Commands --"
  # show execve events in the last hour
  ausearch -m execve -ts recent | aureport --summary
else
  echo -e "\n(Install and configure auditd for full command auditing.)"
fi

echo -e "\n=== End of User Session Audit ==="
