swapoff -a
sed -i "s/^[^#].*swap*/#&/g" /etc/fstab
