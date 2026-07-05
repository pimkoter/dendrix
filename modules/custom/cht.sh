#!/usr/bin/env bash

cht_search() {
  local languages=(
    python javascript typescript go rust c cpp csharp 
    java ruby php swift kotlin perl shell bash html css
  )

  # Gather system commands
  local system_commands=()
  while IFS= read -r cmd; do
    system_commands+=("$cmd")
  done < <(compgen -c)

  # Run FZF to make a selection
  local selection
  selection=$( (printf "%s\n" "${languages[@]}"; printf "%s\n" "${system_commands[@]}") | fzf \
    --header "Select a Language or System Command" \
    --prompt "Search: " )

  [[ -z "$selection" ]] && return 0

  # Check if selection is a language
  local is_lang=0
  for lang in "${languages[@]}"; do
    if [[ "$lang" == "$selection" ]]; then
      is_lang=1
      break
    fi
  done

  if [[ $is_lang -eq 1 ]]; then
    local query
    echo -n -e "\033[1;33mEnter query for $selection (e.g., 'reverse a string'): \033[0m"
    read -r query
    [[ -z "$query" ]] && return 0

    local formatted_query="${query// /+}"
    local url="cht.sh/$selection/$formatted_query"
  else
    local url="cht.sh/$selection"
  fi

  # --- TMUX WINDOW HANDLING ---
  # If inside a tmux session, open the result in a new temporary window
  if [[ -n "$TMUX" ]]; then
    tmux new-window -n "chtsh-$selection" "curl -s '$url' | less -R"
  else
    # Fallback for non-tmux environments
    echo -e "\n\033[1;32mFetching: $url ...\033[0m\n"
    curl -s "$url" | less -R
  fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  cht_search
fi
