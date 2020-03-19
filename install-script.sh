#!/bin/bash

SHAREDIR=usr/local/share/voipservices
AUDIODIR=$SHAREDIR/audio
BINDIR=usr/local/sbin
CFGDIR=etc
INITDIR=$CFGDIR/init.d
SENSOR=voipservices
SPOOLDIR=/var/spool/$SENSOR

if [ "a$1" == "a--uninstall" ]
then

        echo "Stopping $SENSOR"
        /$INITDIR/$SENSOR stop

        echo "Uninstalling /$SHAREDIR"
        rm -rf /$SHAREDIR

        echo "Uninstalling $SENSOR binary from /$BINDIR/$SENSOR"
        rm /$BINDIR/$SENSOR

        echo "Moving /$CFGDIR/$SENSOR.conf to /$CFGDIR/$SENSOR.conf-backup."
        mv /$CFGDIR/$SENSOR.conf /$CFGDIR/$SENSOR.conf-backup

        echo "Deleting $SPOOLDIR"
        rm -rf $SPOOLDIR

        update-rc.d $SENSOR remove &>/dev/null
        chkconfig $SENSOR off &>/dev/null
        chkconfig --del $SENSOR &>/dev/null

        echo "Deleting starting script /$INITDIR/$SENSOR"
        rm /$INITDIR/$SENSOR

        echo;
        echo "The database is not deleted. Do it manually.";
        echo;
        exit 0;
fi

if [ "a$1" == "a--no-user-input" ]
then
        NOUSERINPUT=yes
else
        NOUSERINPUT=""
fi

echo "Installing /$AUDIODIR"
mkdir -p /$AUDIODIR
cp -r usr/local/share/voipmonitor/* /$AUDIODIR/

echo "Installing $SENSOR binary to /$BINDIR/$SENSOR"
mkdir -p /$BINDIR
cp $BINDIR/voipmonitor /$BINDIR/$SENSOR
echo "Installing $INITDIR/$SENSOR starting script to /$INITDIR/$SENSOR. Start $SENSOR by /$INITDIR/$SENSOR start"
cp $INITDIR/$SENSOR /$INITDIR/

# ask/set id sniffer
DEFID=1
if [ -z $NOUSERINPUT ]; then
        echo -n "Enter ID of Sniffer [$ID]: "
        read TMPID
fi
if [ -z "$TMPID" ]; then
        ID=$DEFID
else
        ID=$TMPID
fi
sed -i "s#^id_sensor[\t= ]\+.*\$#id_sensor = $ID#" $CFGDIR/$SENSOR.conf

# ask/set spool directory, usage # as a delimiter in sed
DEFSPOOLDIR=/var/spool/voipservices
if [ -z $NOUSERINPUT ]; then
        echo -n "Enter spool directory [$DEFSPOOLDIR]: "
        read TMPSPOOL
fi
if [ -z "$TMPSPOOL" ]; then
        SPOOLDIR=$DEFSPOOLDIR
else
        SPOOLDIR=$TMPSPOOL
fi
sed -i "s#^spooldir[\t= ]\+.*\$#spooldir = $SPOOLDIR#" $CFGDIR/$SENSOR.conf
echo "Creating $SPOOLDIR"
mkdir $SPOOLDIR

# ask/set sniffing interface(s)
DEFINT=eth0
if [ -z $NOUSERINPUT ]; then
        echo -n "Enter sniffing interface(s). More interface names must separated by comma. [$DEFINT]: "
        read TMPINT
fi
if [ -z "$TMPINT" ]; then
        INTERFACE=$DEFINT
else
        INTERFACE=$TMPINT
fi
sed -i "s#^interface[\t= ]\+.*\$#interface = $INTERFACE#" $CFGDIR/$SENSOR.conf

# ask/set maxpool days
DEFMAXPOOLDAYS=90
if [ -z $NOUSERINPUT ]; then
        echo -n "Enter max pool days for pcaps store (in MB). [$DEFMAXPOOLDAYS]: "
        read TMPMAXPOOLDAYS
fi
if [ -z "$TMPMAXPOOLDAYS" ]; then
        MAXPOOLDAYS=$DEFMAXPOOLDAYS
else
        MAXPOOLDAYS=$TMPMAXPOOLDAYS
fi
sed -i "s#^maxpooldays[\t= ]\+.*\$#maxpooldays = $MAXPOOLDAYS#" $CFGDIR/$SENSOR.conf

# ask/set mysqlusername
DEFMYSQLUSERNAME=default
if [ -z $NOUSERINPUT ]; then
        echo -n "Enter MYSQL username. [$MYSQLUSERNAME]: "
        read TMPMYSQLUSERNAME
fi
if [ -z "$TMPMYSQLUSERNAME" ]; then
        MYSQLUSERNAME=$DEFMYSQLUSERNAME
else
        MYSQLUSERNAME=$TMPMYSQLUSERNAME
fi
sed -i "s#^mysqlusername[\t= ]\+.*\$#mysqlusername = $MYSQLUSERNAME#" $CFGDIR/$SENSOR.conf

# ask/set mysqlpassword
DEFMYSQLPASSWORD=pass
if [ -z $NOUSERINPUT ]; then
        echo -n "Enter MYSQL password. [$MYSQLPASSWORD]: "
        read TMPMYSQLPASSWORD
fi
if [ -z "$TMPMYSQLPASSWORD" ]; then
        MYSQLPASSWORD=$DEFMYSQLPASSWORD
else
        MYSQLPASSWORD=$TMPMYSQLPASSWORD
fi
sed -i "s#^mysqlpassword[\t= ]\+.*\$#mysqlpassword = $MYSQLPASSWORD#" $CFGDIR/$SENSOR.conf

# ask/set server_password
DEFSERVERPASSWORD=pass
if [ -z $NOUSERINPUT ]; then
        echo -n "Enter Voipservice Server password. [$SERVERPASSWORD]: "
        read TMPSERVERPASSWORD
fi
if [ -z "$TMPSERVERPASSWORD" ]; then
        SERVERPASSWORD=$DEFSERVERPASSWORD
else
        SERVERPASSWORD=$TMPSERVERPASSWORD
fi
sed -i "s#^server_password[\t= ]\+.*\$#server_password = $SERVERPASSWORD#" $CFGDIR/$SENSOR.conf

# ask/set autocleanmingb
DEFAUTOCLEANMINGB=50
if [ -z $NOUSERINPUT ]; then
        echo -n "Enter Auto-clean minimum GB. [$AUTOCLEANMINGB]: "
        read TMPAUTOCLEANMINGB
fi
if [ -z "$TMPAUTOCLEANMINGB" ]; then
        AUTOCLEANMINGB=$DEFAUTOCLEANMINGB
else
        AUTOCLEANMINGB=$TMPAUTOCLEANMINGB
fi
sed -i "s#^autocleanmingb[\t= ]\+.*\$#autocleanmingb = $AUTOCLEANMINGB#" $CFGDIR/$SENSOR.conf

echo "Installing $CFGDIR/$SENSOR.conf to /$CFGDIR/$SENSOR.conf. Edit this file to your needs"
cp -i $CFGDIR/$SENSOR.conf /$CFGDIR/


update-rc.d $SENSOR defaults &>/dev/null
chkconfig --add $SENSOR &>/dev/null
chkconfig $SENSOR on &>/dev/null

echo;
echo "Create database $SENSOR with this command: mysqladmin create $SENSOR";
echo "Edit /$CFGDIR/$SENSOR.conf";
echo "Run $SENSOR /$INITDIR/$SENSOR start";
echo;
