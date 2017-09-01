# Clean, simple, compatible and meaningful.
# Tested on Linux, Unix and Windows under ANSI colors.
# It is recommended to use with a dark background.
# Colors: black, red, green, yellow, *blue, magenta, cyan, and white.
#
# Mar 2017 YY SB

# VCS
YSB_VCS_PROMPT_PREFIX1=" %{$fg[white]%}on%{$reset_color%} "
YSB_VCS_PROMPT_PREFIX2=":%{$fg[cyan]%}"
YSB_VCS_PROMPT_SUFFIX="%{$reset_color%}"
YSB_VCS_PROMPT_DIRTY=" %{$fg[red]%}x"
YSB_VCS_PROMPT_CLEAN=" %{$fg[green]%}o"

# Git info
local git_info='$(git_prompt_info)'
ZSH_THEME_GIT_PROMPT_PREFIX="${YSB_VCS_PROMPT_PREFIX1}git${YSB_VCS_PROMPT_PREFIX2}"
ZSH_THEME_GIT_PROMPT_SUFFIX="$YSB_VCS_PROMPT_SUFFIX"
ZSH_THEME_GIT_PROMPT_DIRTY="$YSB_VCS_PROMPT_DIRTY"
ZSH_THEME_GIT_PROMPT_CLEAN="$YSB_VCS_PROMPT_CLEAN"
# Outputs current branch info in prompt format
function git_prompt_info() {
  [[ "$(command git config --get oh-my-zsh.hide-status 2>/dev/null)" == "1" ]] && return 0
  local ref=$(command git symbolic-ref HEAD 2> /dev/null)
  [[ ! -n $ref ]] && ref=$(git_current_tag)
  [[ ! -n $ref ]] && ref=$(command git rev-parse --short HEAD 2> /dev/null)
  [[ ! -n $ref ]] && return 0
  echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_SUFFIX"
}
# get git current tag
function git_current_tag() {
  local ref="$(command git branch 2> /dev/null | grep \*\ \(HEAD)"
  if [[ -n $ref ]];then
	ref=${ref#*at }
  	echo ${ref%%)*}
  fi
}


# HG info
local hg_info='$(ysb_hg_prompt_info)'
ysb_hg_prompt_info() {
	# make sure this is a hg dir
	if [ -d '.hg' ]; then
		echo -n "${YSB_VCS_PROMPT_PREFIX1}hg${YSB_VCS_PROMPT_PREFIX2}"
		echo -n $(hg branch 2>/dev/null)
		if [ -n "$(hg status 2>/dev/null)" ]; then
			echo -n "$YSB_VCS_PROMPT_DIRTY"
		else
			echo -n "$YSB_VCS_PROMPT_CLEAN"
		fi
		echo -n "$YSB_VCS_PROMPT_SUFFIX"
	fi
}

local exit_code="%(?,,C:%{$fg[red]%}%?%{$reset_color%})"

# Prompt format:
#
# PRIVILEGES USER @ MACHINE in DIRECTORY on git:BRANCH STATE [TIME] C:LAST_EXIT_CODE
# $ COMMAND
#
# For example:
#
# % test@test-mbp in ~/.oh-my-zsh on git:master x [21:47:42] C:0
# $
PROMPT="
%{$terminfo[bold]$fg[blue]%}#%{$reset_color%} \
%(#,%{$bg[yellow]%}%{$fg[black]%}%n%{$reset_color%},%{$fg[cyan]%}%n)\
%{$fg[white]%}@\
%{$fg[green]%}%m \
%{$fg[white]%}in \
%{$terminfo[bold]$fg[yellow]%}%~%{$reset_color%}\
${hg_info}\
${git_info}\
 \
%{$fg[white]%}[%*] $exit_code
%{$terminfo[bold]$fg[red]%}$ %{$reset_color%}"
