#!/bin/bash
root="root"

if [ $USER != $root ]
then
echo "Please, run this as super user"
exit
fi

directory=$(pwd)

cd DaemonCooler

make 

mkdir /home/pi/.services
cd /home/pi/.services

cp $directory/DaemonCooler/DaemonCooler ./DaemonCooler

echo -e "#!/bin/bash\n$(pwd)/DaemonCooler" > DaemonCooler.sh

chmod +x DaemonCooler.sh

cd /etc/systemd/system 

echo -e "[Unit]\nDescription = Cooler control\n\n[Service]\nRemainAfterExit=true\nExecStart=/home/pi/.services/DaemonCooler.sh\nType=oneshot\n\n[Install]\nWantedBy=multi-user.target\n" > DaemonCooler.service

cd /etc
echo -e "# Lines must be written in one piece\npin=14\nmax_temp=50\ninterval=10\nworking_time=600\n" > ./CoolerDaemon.conf

echo "You could find configuration file in /etc/CoolerDaemon.conf"
echo "Log file is in /tmp/cooler.log"

echo ""

echo "Now you could run \"sudo systemctl start DaemonCooler.service\""

