#!/bin/zsh

emulate -L zsh

setopt extendedglob histlexwords
bindkey -e

typeset -ga _edit_opts=( extendedglob NO_listbeep NO_shortloops warncreateglobal )

local -a alt_left=(  '^['{'[1;',\[,O}3D '^[^['{\[,O}D )
local -a ctrl_left=( '^['{'[1;',\[,O}5D )
local -a alt_right=(  '^['{'[1;',\[,O}3C '^[^['{\[,O}C )
local -a ctrl_right=( '^['{'[1;',\[,O}5C )

.edit.move-word() {
  emulate -L zsh
  setopt $_edit_opts

  if [[ $WIDGET == *kill-* ]]; then
    zle -f kill
    if (( REGION_ACTIVE )); then
      zle .kill-region
      return
    fi
  fi

  local catch=

  if [[ $WIDGET == *-shell-* ]]; then
    local -a words=( ${(z)BUFFER} )
    local -a lwords=( ${(z)LBUFFER} )

    local -i lcurrent=$#lwords
    local -i rcurrent=$#lwords

    local prefix=$lwords[lcurrent]
    local suffix=${words[rcurrent]#$prefix}

    if [[ -z $suffix ]]; then
      # The cursor is between two words, not in the middle of one.
      (( rcurrent++ ))
      suffix=$words[rcurrent]
    fi

    local blanks='[[:blank:]]#'
    local terminator=$'[;\n]'

    if [[ $WIDGET == *backward-* ]]; then
      if [[ lcurrent -ne rcurrent && $prefix == \; ]]; then
        prefix=
      else
        terminator=
      fi
      catch=${(M)LBUFFER%%${prefix}${~terminator}${~blanks}}
    else
      if [[ lcurrent -ne rcurrent && $suffix == \; ]]; then
        suffix=
      else
        terminator=
      fi
      catch=${(M)RBUFFER##${~blanks}${~terminator}${suffix}}
    fi
  else
    local wordchars=''
    zstyle -s ":edit:$WIDGET:" word-chars wordchars
    local +h WORDCHARS=$wordchars

    local subword='([[:WORD:]]#~*[[:lower:]]*[[:upper:]]*)'
    local blanks='[[:blank:]]##'
    local other='[^[:WORD:][:blank:]]##'

    if [[ $WIDGET == *backward-* ]]; then
      catch=${(M)LBUFFER%%(${~other}${~blanks}|${~subword}(${~blanks}|${~other}|))}
    else
      catch=${(M)RBUFFER##(${~blanks}${~other}|(${~blanks}|${~other}|)${~subword})}
    fi
  fi

  local -i move=0
  if [[ $WIDGET == *backward-* ]]; then
    (( move = -$#catch ))
  else
    (( move = $#catch ))
  fi

  if [[ $WIDGET == *kill-* ]]; then
    # Move MARK instead of CURSOR so kill-region appends to the right end.
    (( MARK = CURSOR + move ))
    zle .kill-region
  else
    (( CURSOR += move ))
  fi
}

for widget in \
  backward-subword \
  forward-subword \
  backward-shell-word \
  forward-shell-word \
  backward-kill-subword \
  kill-subword \
  backward-kill-shell-word \
  kill-shell-word
do
  zle -N "$widget" .edit.move-word
done

typeset -ga ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS
ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS+=(
  forward-subword
  forward-shell-word
)

# Requested bindings.
bindkey '^W' backward-kill-shell-word
bindkey '^[w' kill-shell-word
bindkey '^Q' backward-kill-subword
bindkey '^[q' kill-subword

# Common terminal escape sequences for Ctrl-Left/Right and Alt-Left/Right.
for key in "${ctrl_left[@]}"; do
  bindkey "$key" backward-subword
done
for key in "${ctrl_right[@]}"; do
  bindkey "$key" forward-subword
done
for key in "${alt_left[@]}"; do
  bindkey "$key" backward-shell-word
done
for key in "${alt_right[@]}"; do
  bindkey "$key" forward-shell-word
done
