# snd-aloop module for recording ALSA output
modprobe snd-aloop
echo "snd-aloop" >> /etc/modules

# 80 --> 8000 port redirection
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 8000 -j ACCEPT
iptables -A PREROUTING -t nat -p tcp --dport 80 -j REDIRECT --to-port 8000

# Preseed icecast config
echo "icecast2 icecast2/adminpassword  string  hackme" | debconf-set-selections
echo "icecast2 icecast2/sourcepassword string  hackme" | debconf-set-selections
echo "icecast2 icecast2/hostname       string  jukebox.local" | debconf-set-selections
echo "icecast2 icecast2/relaypassword  string  hackme" | debconf-set-selections
echo "icecast2 icecast2/icecast-setup  boolean true" | debconf-set-selections

# Preseed iptables-persistent config
echo "iptables-persistent iptables-persistent/autosave_v6 boolean true" | debconf-set-selections
echo "iptables-persistent iptables-persistent/autosave_v4 boolean true" | debconf-set-selections

# Add repositories and install packages
wget -q -O - https://apt.mopidy.com/mopidy.gpg | apt-key add -
wget -q -O /etc/apt/sources.list.d/mopidy.list https://apt.mopidy.com/mopidy.list
apt-get update
apt-get install -yq libspotify12 libspotify-dev icecast2 iptables-persistent vim

# Configure and start icecast
sed -i -e 's/ENABLE=false/ENABLE=true/g' /etc/default/icecast2
mv /etc/icecast2/icecast.xml /etc/icecast2/icecast.xml.orig
cp /vagrant/conf/icecast.xml /etc/icecast2/icecast.xml
chown icecast2:icecast /etc/icecast2/icecast.xml
service icecast2 restart

# Setup streamer with upstart
# gst-launch-0.10 alsasrc device=looprec ! lame ! shout2send mount=/radio.mp3
