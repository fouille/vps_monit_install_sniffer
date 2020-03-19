#/bin/sh

echo "######## run to /tmp"
cd /tmp/ 
echo "######## Download sniffer"
wget https://www.voipmonitor.org/current-stable-sniffer-static-64bit.tar.gz --content-disposition --no-check-certificate
echo "######## Decompress"
tar xzf voipmonitor-*-static.tar.gz
echo "######## Run"
./voipmonitor-*-static/install-script.sh
echo "######## Finish"
