#!/bin/bash

mkdir -p /etc/ssh/hostkeys

if [ ! -f /etc/ssh/hostkeys/ssh_host_rsa_key ]; then
    ssh-keygen -t rsa -b 2048 -f /etc/ssh/hostkeys/ssh_host_rsa_key -N ''
    ssh-keygen -t ecdsa -b 256 -f /etc/ssh/hostkeys/ssh_host_ecdsa_key -N ''
    chmod -R 600 /etc/ssh/hostkeys/ssh_host_rsa_key
fi

if id "$DEVICE_USERNAME" &>/dev/null; then
    echo "$DEVICE_USERNAME user already exists"
else
    adduser -S $DEVICE_USERNAME --shell /bin/bash --uid 1400
    echo $DEVICE_USERNAME:$DEVICE_PASSWORD | chpasswd
fi

#chown -R root:root /data
chmod -R 755 /data
chown $DEVICE_USERNAME:root /home/$DEVICE_USERNAME
chmod go-w /home/$DEVICE_USERNAME

if [ ! -d "/home/$DEVICE_USERNAME/.ssh" ]; then
    mkdir /home/$DEVICE_USERNAME/.ssh
    touch /home/$DEVICE_USERNAME/.ssh/authorized_keys
fi

chown -R $DEVICE_USERNAME:root /home/$DEVICE_USERNAME/.ssh
chmod 700 /home/$DEVICE_USERNAME/.ssh
chmod 600 /home/$DEVICE_USERNAME/.ssh/authorized_keys

/usr/sbin/sshd -D -e
