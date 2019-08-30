#!/usr/bin/env bash

autocomplete() {
  typeset -A _ARGUMENTS=()
  . /opt/wex/project/bash/globals.sh

  if [ -n "${ZSH_VERSION+x}" ]; then
    COMP_WORDS=(${words})
    COMP_CWORD=$((CURRENT - 1))
  fi

  local CUR=${COMP_WORDS[@]:${COMP_CWORD}:1}
  local SUGGESTIONS=();
  local SPLIT=("$(wex text/split -t="${CUR}" -s=/)")
  local SEEK_GROUP=${SPLIT[@]:0:1}
  local SEEK_SCRIPT=${SPLIT[@]:1:1}
  local HAS_GROUP=$([ "${SEEK_GROUP}" != "" ] && [ "${SEEK_GROUP}" != "${CUR}" ] && echo "true" || echo "false");
  local WEX_SCRIPT_CALL_NAME=${COMP_WORDS[@]:1:1}
  local ARGS_INDEX=2;

  # Handle the '::' case with zsh by separating '::' from the argument
  local SECOND_ARGUMENT=${COMP_WORDS[@]:1:1}
  if [[ "${SECOND_ARGUMENT}" =~ '::' ]];then
    SECOND_ARGUMENT_ARRAY=("${(s/::/)SECOND_ARGUMENT}")

    COMP_WORDS=( "${COMP_WORDS[@]:0:1}" "${SECOND_ARGUMENT_ARRAY[1]}" "::" "${SECOND_ARGUMENT_ARRAY[2]}" )
  fi

  if [[ "${COMP_WORDS[@]:2:1}" == "::" ]];then
    ARGS_INDEX+=1
    local WEX_DIR_BASH_GROUPS=("${COMP_WORDS[@]:1:1}")
  else
    _wexFindNamespace "${CUR}"

    if [ "${WEX_NAMESPACE_TEST}" != "" ];then
      local WEX_DIR_BASH_GROUPS=("${WEX_NAMESPACE_TEST}" "${WEX_NAMESPACE_DEFAULT}")
    else
      local WEX_DIR_BASH_GROUPS=("${WEX_NAMESPACE_DEFAULT}")
    fi
  fi

  if (( COMP_CWORD < ARGS_INDEX ));then
    # Search into extend directories.
    for WEX_DIR_BASH_GROUP in "${WEX_DIR_BASH_GROUPS[@]}"
    do
      local WEX_GROUPS=($(ls ${WEX_DIR_BASH}/${WEX_DIR_BASH_GROUP}));

      for BASH_GROUP in ${WEX_GROUPS[@]}
      do
        # This is a directory.
        local GROUP_DIR="${WEX_DIR_BASH}${WEX_DIR_BASH_GROUP}/${BASH_GROUP}"
        if [ -d "${GROUP_DIR}" ];then

          # We search for a script file
          if [ "${HAS_GROUP}" = true ];then
            local SCRIPTS=($(ls "${GROUP_DIR}"));

            # Iterate over scripts files.
            for SCRIPT in ${SCRIPTS[@]}
            do
              local SUGGESTION=$(basename ${BASH_GROUP})"/"$(echo "${SCRIPT}" | cut -f 1 -d '.')

              # all shells but ZSH
              if [ -z "${ZSH_VERSION+x}" ]; then
                SUGGESTIONS+=" ${SUGGESTION}"
              else # ZSH
                # If it is of the form "word::word"
                # then we add "word::" at the first to avoid zsh rejecting the suggestion
                if [[ "${SECOND_ARGUMENT}" =~ '::' ]];then
                  SUGGESTION=${SECOND_ARGUMENT_ARRAY[1]}::${SUGGESTION}
                fi

                compadd -S '' "${SUGGESTION}"
              fi
            done;
          # We search for a group folder.
          else
            local SUGGESTION=$(basename ${BASH_GROUP})"/"
            # all shells but ZSH
            if [ -z "${ZSH_VERSION+x}" ]; then
              SUGGESTIONS+=" ${SUGGESTION}"
            else # ZSH
              # If it is of the form "word::word"
              # then we add "word::" at the first to avoid zsh rejecting the suggestion
              if [[ "${SECOND_ARGUMENT}" =~ '::' ]];then
                SUGGESTION=${SECOND_ARGUMENT_ARRAY[1]}::${SUGGESTION}
              fi

              compadd -S '' "${SUGGESTION}"
            fi
          fi
        fi
      done;
    done;
  # Autocomplete args.
  else
    _wexFindNamespace "${CUR}"
    _wexFindScriptFile

    if [ ! -f "${WEX_SCRIPT_FILE}" ]; then
      return
    fi

    # Include found script file
    . "${WEX_SCRIPT_FILE}"
    ${WEX_SCRIPT_METHOD_ARGS_NAME}

    for ARG in "${_ARGUMENTS[@]}"
    do
      eval "SPLIT=(${ARG})"
      if [ -n "${BASH_VERSION+x}" ]; then
        SUGGESTIONS+=" --"${SPLIT[0]}
      else
        compadd -S '' -P "--" ${SPLIT[@]:0:1}
      fi
    done
  fi

  if [ -n "${BASH_VERSION+x}" ]; then
    COMPREPLY=( $(compgen -W "${SUGGESTIONS}" -- "${CUR}") )
  fi
}

autocomplete