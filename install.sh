#/bin/sh

echo "######## run to /tmp"
cd /tmp/
echo "######## Download sniffer"
wget -O stable-sniffer-static-64bit.tar.gz https://www.voipmonitor.org/current-stable-sniffer-static-64bit.tar.gz --content-disposition --no-check-certificate
echo "######## Decompress"
tar xzf stable-sniffer-static-64bit.tar.gz
echo "######## Download voipservices conf"
cd voipmonitor-*-static/
rm install-script.sh
wget -P etc/ https://raw.githubusercontent.com/fouille/vps_monit_install_sniffer/master/voipservices.conf
wget -P etc/init.d https://raw.githubusercontent.com/fouille/vps_monit_install_sniffer/master/etc/init.d/voipservices
wget https://raw.githubusercontent.com/fouille/vps_monit_install_sniffer/master/install-script.sh
chmod +x install-script.sh
chmod +x etc/init.d/voipservices
rm etc/voipmonitor.conf
rm etc/init.d/voipmonitor
echo "######## Run"
./install-script.sh
rm -rf /tmp/voipmonitor*
echo "######## Finish"
