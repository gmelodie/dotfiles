# Add some lines to interfaces

echo "
# The primary network interface
auto eth0
allow-hotplug eth0
iface eth0 inet dhcp
" >> /etc/network/interfaces
