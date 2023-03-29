# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

clear

export ZSH="$HOME/.oh-my-zsh"
export TCCHOME="$HOME/workspace/TCC/"
export TCCBUILD="$HOME/workspace/TCC/build"
export CXX=clang++

export PATH=$PATH:~/clion-2022.3.3/bin
export PATH=$PATH:~/workspace/cpprojects/bin

plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh


alias zsh-config="lvim ~/.zshrc"
alias zrc="source ~/.zshrc"
alias spaceship-config="lvim ~/.spaceshiprc.zsh"

alias i3-config="lvim ~/.i3/config"
alias i3-wclass="xprop | grep -e 'CLASS'"
alias ws-dir="cd ~/.i3/workspaces"
alias wdev-config="lvim ~/.i3/workspaces/configs/wdev"
alias ls="exa --icons"
alias workspace="cd ~/workspace"

alias work-dir="cd ~/projects"
alias projects="lvim ~/projects"

alias access-postgres='kubectl run pg-minikube-postgresql-client --rm --tty -i --restart="Never" --namespace default --image docker.io/bitnami/postgresql:11.13.0-debian-10-r40 --env="PGPASSWORD=123" --command -- psql --host pg-minikube-postgresql -U postgres -d postgres -p 5432'

alias clion="nohup clion.sh &"

X=$(xrandr --current | grep '*' | uniq | awk '{print $1}' | cut -d 'x' -f1)
Y=$(xrandr --current | grep '*' | uniq | awk '{print $1}' | cut -d 'x' -f2)

# Terraform
alias tf="terraform"


WS_DEFAULT="wdev"
declare -a arrFiles
ws-list(){
    work_dir=$(pwd)
    cd ~/.i3/workspaces
    cont=0
    for file in ~/.i3/workspaces/*
    do 
        arrFiles=("${Pics[@]}" "$file" "${arrFiles[$cont]}")
        cont=$cont+1
    done
    cd $work_dir
}

export draw_machine_dir=~/workspace/cpprojects/cmaketests
run(){

work_dir=$(pwd)
cd $draw_machine_dir

{ 
  cmake --build build
} || { 
  echo "ERROR: "
  cd $work_dir
  return 1
}
draw_machine

cd $work_dir

}

ws(){
    work_dir=$(pwd)
    cont=1
    ws_path=~/.i3/workspaces
    echo $ws_path
    for file in $ws_path/configs/*
    do
        base_name=$(basename ${file})
        echo $base_name
        echo $ws_path
        wrks="$cont:$base_name"
        echo $wrks
        if [ $cont -ne  1 ]; 
        then            
            i3 workspace $wrks
        fi
        i3 append_layout $file
        ${ws_path}/sh/${base_name}.sh
        cont=$(($cont+1))
    done
    cd $work_dir

}

set-monitor(){
  
  xrandr --setmonitor M1 960/344x1080/193+0+0 HDMI-1
  xrandr --setmonitor M2 960/344x1080/193+961+0 none 

}

del-monitor(){
  xrandr --delmonitor M1
  xrandr --delmonitor M2
}

access-db(){
  engine="$1"
  if [ $engine=="postgres" ];
  then
    export POSTGRES_PASSWORD=$(kubectl get secret --namespace default sql-db-postgresql -o jsonpath="{.data.postgres-password}" | base64 -d)
    kubectl run sql-db-postgresql-client --rm --tty -i --restart='Never' --namespace default --image docker.io/bitnami/postgresql:15.2.0-debian-11-r2 --env="PGPASSWORD=$POSTGRES_PASSWORD" \
          --command -- psql --host sql-db-postgresql -U postgres -d postgres -p 5432
  fi
}

source /opt/asdf-vm/asdf.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme





