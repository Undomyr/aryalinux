#!/bin/bash
set -e
set +h

function preinstall()
{

groupadd -g 48 rsyncd &&
useradd -c "rsyncd Daemon" -d /home/rsync -g rsyncd \
    -s /bin/false -u 48 rsyncd

}


postinstall()
{
echo "#"
}


$1
