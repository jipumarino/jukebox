wget -q -O - https://apt.mopidy.com/mopidy.gpg | sudo apt-key add -
sudo wget -q -O /etc/apt/sources.list.d/mopidy.list https://apt.mopidy.com/mopidy.list
sudo apt-get update
sudo apt-get install mopidy mopidy-spotify icecast2 mpc vim
sed -i -e 's/ENABLED=false/ENABLED=true/g' /etc/default/icecast2
mv /etc/icecast2/icecast.xml /etc/icecast2/icecast.xml.orig
cp /vagrant/conf/icecast.xml /etc/icecast2/icecast.xml
chown icecast2:icecast /etc/icecast2/icecast.xml
mv /etc/mopidy/mopidy.conf /etc/mopidy/mopidy.conf.orig
cp /vagrant/conf/mopidy.conf /etc/mopidy/mopidy.conf
chown mopidy /etc/mopidy/mopidy.conf
cp /vagrant/conf/silence.mp3 /usr/share/icecast2/web/silence.mp3
service icecast restart
service mopidy restart
mpc add spotify:user:12124580543:playlist:1OVBp7XsVuwJQxWG3Xpldc

