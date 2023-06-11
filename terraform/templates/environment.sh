# source ./aws.env

export DOCKER_HOST=ssh://${user}@${public_ip}
export AWS_HOST=${public_ip}
export AWS_SSH_HOST=${user}@${public_ip}

alias aws-connect='ssh -i "${private_key_path}" ${user}@${public_ip}'
alias aws-list-tunnels='ps -ax | grep "ssh -fN" | grep -v grep'

function aws-tunnel() {
    if [ "$#" -ne 3 ]; then
        echo "usage: aws-tunnel <local_port> <remote_host> <remote_port>"
        return 1
    fi
    ssh -fN -i "${private_key_path}" -L $1:$2:$3 ${user}@${public_ip}
}

function aws-tunnel-list() {
    ps -ax | grep "ssh -fN" | grep -v grep
}

function aws-tunnel-stop() {
    if [ "$#" -ne 1 ]; then
        echo "usage: aws-tunnel-stop <pid>"
        return 1
    fi

    kill -15 $1
}

aws-pull(){
    if [ "$#" -ne 1 ]; then
        echo "usage: aws-pull <remote_dir>"
        return 1
    fi
    rsync -azP ${user}@${public_ip}:$1/ .
}


aws-push(){
    if [ "$#" -ne 1 ]; then
        echo "usage: aws-pull <remote_dir>"
        return 1
    fi
    rsync -azP . ${user}@${public_ip}:$1/
}

function aws-deactivate() {
    unset DOCKER_HOST
    unset AWS_HOST

    unalias aws-connect
    unalias aws-list-tunnels

    unset -f aws-tunnel
    unset -f aws-tunnel-list
    unset -f aws-tunnel-stop
    unset -f aws-deactivate
}