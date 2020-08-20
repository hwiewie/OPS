sed -i "s/crashkernel=auto/ipv6.disable=1 crashkernel=auto/g" /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg
grub2-mkconfig -o /boot/efi/EFI/centos/grub.cfg
reboot
