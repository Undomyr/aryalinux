#!/bin/bash
set -e
set +h

function preinstall()
{

groupadd -g 99 nogroup &&
useradd -c "Unprivileged Nobody" -d /dev/null -g nogroup \
    -s /bin/false -u 99 nobody

}


postinstall()
{
echo "#"
}


$1
