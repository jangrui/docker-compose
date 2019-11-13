#/bin/bash

grastate=`grep ^data= .env|cut -d = -f 2`db1/grastate.dat

if [ ! -e $grastate ];then
    echo "grastate.dat not found !"
    exit 1;
else
    if [ `sudo cat $grastate|grep safe_to_bootstrap:|awk '{print $2}'` -ne 1 ];then
        sudo sed -i "s,safe_to_bootstrap:.*,safe_to_bootstrap: 1," $grastate
        echo -e "\033[44;37m change safe_to_bootstrap = 1 \033[0m"
        sudo cat  $grastate
    fi
fi
