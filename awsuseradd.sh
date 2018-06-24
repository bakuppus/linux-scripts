#!/bin/bash

echo "   "
echo "Please Enter the username "
echo "-------------------------"
echo "  "
read -p 'Username: ' uservar
#read -sp 'Password: ' passvar
echo
echo Thankyou $uservar we now have your login details


#Create a symlink called rbash from Bash for Restricted Shell mode
ls -ld /bin/rbash   2>&1 >/dev/null
if [ $? -eq 0 ]; then
    echo "rbash exists"   2>&1 >/dev/null
else
    sudo ln -s /bin/bash /bin/rbash
fi


#create user , use  rbash as default login shell.
sudo useradd $uservar -s /bin/rbash  

#Create a bin directory inside the home folder of the  new user
sudo  mkdir /home/$uservar/bin  

#specify which commands the user can run
sudo ln -s /bin/ls /home/$uservar/bin/ls
sudo ln -s /bin/sh /home/$uservar/bin/sh

#prevent the user from modifying .bash_profile
sudo   chown root. /home/$uservar/.bash_profile
sudo  chmod 755 /home/$uservar/.bash_profile

#Modify the PATH variable
#sudo echo "PATH=$HOME/bin" >> /home/$uservar/.bash_profile

#Copy  public key to the authorized keys file for the new user 
sudo cp -rf  /home/ec2-user/.ssh /home/$uservar/
sudo chown -R $uservar:$uservar  /home/$uservar/.ssh

#restrict Folders
ls -ld /* | egrep -v 'critical|home|var|etc|dev|proc|boot|sys|bin|tmp|lib|lib64|usr' | awk '{print $9}' | while read  i; do setfacl -m u:$uservar:--- $i; done

echo "   "
echo "Thank You Again..., user created successfully"

