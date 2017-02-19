#!/usr/bin/env bash

# This script is executed at vagrant up to provision the VM.

set -e


if [ ! -f /home/vagrant/.provisioning-progress ]; then
  su vagrant -c "touch /home/vagrant/.provisioning-progress"
  echo "--> Progress file created in /home/vagrant/.provision-progress"
  apt-get update
else
  echo "--> Progress file exists in /home/vagrant/.provisioning-progress"
fi

#Set the system locale
if grep -q +locale .provisioning-progress; then
  echo "--> Locale already set, moving on."
else
  echo "--> Setting the system locale..."
  echo "LC_ALL=\"en_US.UTF-8\"" >> /etc/default/locale
  locale-gen en_US.UTF-8
  update-locale LANG=en_US.UTF-8
  su vagrant -c "echo +locale >> /home/vagrant/.provisioning-progress"
  echo "--> Locale is now set."
fi

#Install Git, Build-essential, curl, vim, htop
if grep -q +core-libs .provisioning-progress; then
  echo "--> Core libs (git, curl, etc) already installed, moving on."
else
  echo "--> Installing core libs (git, curl, etc)..."
  apt-get update
  apt-get -y install build-essential curl git-core python-software-properties htop vim
  apt-get -y install nodejs # needed by Rails to have a Javascript runtime
  apt-get -y install zlib1g-dev libssl-dev libreadline6-dev libyaml-dev libncurses5-dev libxml2-dev libxslt-dev
  su vagrant -c "echo +core-libs >> /home/vagrant/.provisioning-progress"
  echo "--> Core libs (git, curl, etc) are now installed."
fi

# Default folder to /vagrant
if grep -q +default/vagrant .provisioning-progress; then
  echo "--> default/vagrant already configured"
else
  echo "--> configuring default /vagrant"
  sudo -u vagrant printf 'cd /vagrant\n' >> /home/vagrant/.profile
  su vagrant -c "echo +default/vagrant >> /home/vagrant/.provisioning-progress"
  echo "--> default/vagrant is now configured."
fi

# Install ruby
if grep -q +ruby/2.2.2 .provisioning-progress; then
  echo "--> ruby-2.2.2 is installed, moving on."
else
  echo "--> Installing ruby-2.2.2 ..."
  su vagrant -c "mkdir -p /home/vagrant/downloads; cd /home/vagrant/downloads; \
                 wget --no-check-certificate https://ftp.ruby-lang.org/pub/ruby/2.2/ruby-2.2.2.tar.gz; \
                 tar -xvf ruby-2.2.2.tar.gz; cd ruby-2.2.2; \
                 mkdir -p /home/vagrant/ruby; \
                 ./configure --prefix=/home/vagrant/ruby --disable-install-doc; \
                 make; make install;"
  sudo -u vagrant printf 'export PATH=/home/vagrant/ruby/bin:$PATH\n' >> /home/vagrant/.profile

  su vagrant -c "echo +ruby/2.2.2 >> /home/vagrant/.provisioning-progress"
  echo "--> ruby-2.2.2 is now installed."
fi

# Install bundler
if grep -q +bundler .provisioning-progress; then
  echo "--> bundler already installed, moving on."
else
  echo "--> Installing bundler..."
  su vagrant -c "/home/vagrant/ruby/bin/gem install bundler --no-ri --no-rdoc"
  su vagrant -c "echo +bundler >> /home/vagrant/.provisioning-progress"
  echo "--> +bundler is now installed."
fi


# Install sqlite
if grep -q +sqlite .provisioning-progress; then
  echo "--> sqlite already installed, moving on."
else
  echo "--> Installing sqlite..."
  apt-get -y install sqlite3 libsqlite3-dev
  su vagrant -c "echo +sqlite >> /home/vagrant/.provisioning-progress"
  echo "--> +sqlite is now installed."
fi


# Install rspec
if grep -q +rspec .provisioning-progress; then
  echo "--> rspec already installed, moving on."
else
  echo "--> Installing rspec..."
  apt-get -y install ruby-rspec-core 
  su vagrant -c "echo +rspec >> /home/vagrant/.provisioning-progress"
  echo "--> +rspec is now installed."
fi


echo "All done"
