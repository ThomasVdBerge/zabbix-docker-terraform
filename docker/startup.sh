#!/bin/bash
## This script will populate the zabbix database if it is empty
declare -a schemas=("schema" "images" "data")

shouldSetUpDatabase() {
    ret=$(mysql -h $ZS_DBHost -u $ZS_DBUser -p$ZS_DBPassword zabbix -e "show tables;")
    if [[ "$ret" > 0 ]];then
        echo "database already populated..."
        return 1
    else
        echo "database empty..."
    fi
}

if shouldSetUpDatabase;
then
    echo "populating database..."
    for i in "${schemas[@]}"
    do
        echo "importing: /usr/local/src/zabbix/database/mysql/$i.sql"
        $(mysql -h $ZS_DBHost -u $ZS_DBUser -p$ZS_DBPassword zabbix < "/usr/local/src/zabbix/database/mysql/$i.sql")
    done
fi

/bin/bash /config/bootstrap.sh "$@"
