groupadd sftp_group
useradd testSFTP -g sftp_group -s /sbin/nologin
mkdir /home/testSFTP/data
chown root /home/testSFTP/
chmod 755 /home/testSFTP/
chown root /home/testSFTP/
chown testSFTP. /home/testSFTP/data/
chmod 755 /home/testSFTP/data
sed ‘/Subsystem sftp/s/.*/#&/’ /etc/ssh/sshd_config
echo "Match Group sftp_group" >> /etc/ssh/sshd_config
echo "ChrootDirectory %h" >> /etc/ssh/sshd_config
echo "ForceCommand internal-sftp" >> /etc/ssh/sshd_config
echo "X11Forwarding no" >> /etc/ssh/sshd_config
echo "AllowTcpForwarding no" >> /etc/ssh/sshd_config
systemctl restart sshd
firewall-cmd --permanent --add-service=ftp
firewall-cmd --reload
