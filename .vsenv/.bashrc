source ~/.bashrc

bind '"\e[A"':history-search-backward
bind '"\e[B"':history-search-forward
# bind '"\C-j": "\C-atime \C-m"'

# Auto completion
complete -cf sudo
complete -cf which
complete -W "$(echo `cat ~/.ssh/known_hosts 2> /dev/null | cut -f 1 -d ' ' | sed -e s/,.*//g | uniq | grep -v "\["`;)" ssh

# Disable Ctrl-D to exit terminal
# set -o ignoreeof

#Aliases
alias system-update='sudo apt-get update && time sudo apt-get dist-upgrade'
alias install='sudo apt-get install $1'
alias search='apt-cache search $1'

alias sbb='sudo $(fc -ln -1)'
alias cpv='rsync -ah --info=progress2'
alias lt='du -sh * | sort -h'

alias vsv='vim -u ~/.vsenv/.vimrc'
alias vss='screen -S vlad -c ~/.vsenv/.screenrc'

# Add local bin 
if [ -d ~/bin ];then
	export PATH=~/bin:$PATH
fi

# Easy extract
extract () {
  if [ -f $1 ] ; then
      case $1 in
          *.tar.bz2)   tar xvjf $1    ;;
          *.tar.gz)    tar xvzf $1    ;;
          *.tar.xz)    tar xvf $1     ;;
          *.bz2)       bunzip2 $1     ;;
          *.rar)       rar x $1       ;;
          *.gz)        gunzip $1      ;;
          *.tar)       tar xvf $1     ;;
          *.tbz2)      tar xvjf $1    ;;
          *.tgz)       tar xvzf $1    ;;
          *.zip)       unzip $1       ;;
          *.Z)         uncompress $1  ;;
          *.7z)        7z x $1        ;;
          *)           echo "don't know how to extract '$1'..." ;;
      esac
  else
      echo "'$1' is not a valid file!"
  fi 
}

# Creates an archive from given directory
mktar() { tar cvf  "${1%%/}.tar"     "${1%%/}/"; }
mktgz() { tar cvzf "${1%%/}.tar.gz"  "${1%%/}/"; }
mktbz() { tar cvjf "${1%%/}.tar.bz2" "${1%%/}/"; }

# Kill processes matching a given pattern
pskill() {
    ps ax | grep "$1" | grep -v grep | awk '{ print $1 }' | xargs kill
}

# Grep for a process while ignoring the grep that you're running
function psgrep() {
	OUTFILE=$(mktemp /tmp/psgrep.XXXXX)
	ps fawxxx > "$OUTFILE"
	grep "$@" "$OUTFILE"
	rm "$OUTFILE"
}

# Repeat a command N times
function repeat() {
    local i max
#	max=$1; shift;
    if [ $# -eq 3 ]; then 
        max=$1; 
        duration=$2; shift 2;
    else 
        max=$1; shift;
    fi
	for ((i=1; i <= max ; i++)); do
		eval "$@";
        sleep $duration 
    	done
}

function cd() {
  if [ "$#" = "0" ]
  then
  pushd ${HOME} > /dev/null
  elif [ -f "${1}" ]
  then
    ${EDITOR} ${1}
  else
  pushd "$1" > /dev/null
  fi
}

function bd() {
  if [ "$#" = "0" ]
  then
    popd > /dev/null
  else
    for i in $(seq ${1})
    do
      popd > /dev/null
    done
  fi
}


function atoi
{
	#Returns the integer representation of an IP arg, passed in ascii dotted-decimal notation (x.x.x.x)
	IP=$1; IPNUM=0
	for (( i=0 ; i<4 ; ++i )); do
		((IPNUM+=${IP%%.*}*$((256**$((3-${i}))))))
		IP=${IP#*.}
	done
	echo $IPNUM 
} 

function itoa
{
	# Returns the dotted-decimal ascii form of an IP arg passed in integer format
	echo -n $(($(($(($((${1}/256))/256))/256))%256)).
	echo -n $(($(($((${1}/256))/256))%256)).
	echo -n $(($((${1}/256))%256)).
	echo $((${1}%256)) 
}

function hostgen 
{
	if [[ $# -ne 4 ]];then
		echo "hostgen host name prefix (e.g: cn); start from (e.g: 10);  first ip address (e.g: 192.168.1.1); number of host (e.g: 100);"
		echo "hostgen cn 10 192.168.1.1 100"
	else
		PREFIX=$1
		START=$2
		STARTIP=$3
		COUNT=$4
		ENDIP=$(itoa $(expr $(atoi $STARTIP) + $COUNT - 1))

 		seq -f "${PREFIX}%0${#COUNT}g" $START $(expr $START + $COUNT - 1) > /tmp/file1
		prips $STARTIP $ENDIP > /tmp/file2
		paste /tmp/file1 /tmp/file2
	fi
}

# Kitty special - do not forget about downloaddir in kitty.ini
winscp() { echo -ne "\033];__ws:${PWD}\007"; }

get() {
	for file in ${*}; do echo -ne "\033];__rv:${file}\007"; done;
}

# awesome!  CD AND LA. I never use 'cd' anymore...
function cl() { 
	cd "$@" && la; 
}

# Standard functions to change $PATH
add_path() { export PATH="$PATH:$1"; }
add_pre_path() { export PATH="$1:$PATH"; }
add_cdpath() { export CDPATH="$CDPATH:$1"; }


# JupyterLab
#jlremote(){
#	cd ~/mldl
#	conda activate
#	jupyter-lab --no-browser --ip=192.168.0.165
#}

# EXPORT section
parse_git_branch() {
   git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
export PS1='\u@\[\e[01;31m\]\h\[\e[38;5;220m\]$(parse_git_branch)\[\e[00m\] \W $ '

# Less pager improvement
export LESSOPEN="| /usr/bin/lesspipe %s"


# Go 
export PATH=/usr/local/go/bin:$PATH

# CUDA 
#export PATH=/usr/local/cuda-10.1/bin:$PATH
#export LD_LIBRARY_PATH=/usr/local/cuda-10.1/lib64:$LD_LIBRARY_PATH
#export CUDA_PATH=/usr/local/cuda-10.1/lib64
#export PATH=~/bin:/opt/cmu/bin:$PATH

# Run screen at login
#if [ -z "$STY" ]; then
#    exec screen -S $USERNAME -c ~/.vsenv/.screenrc
#fi
