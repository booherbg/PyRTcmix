#!/bin/sh
# Download the tarball
echo Downloading the daily snapshot tarball...
wget ftp://presto.music.virginia.edu/pub/rtcmix/snapshots.daily/RTcmix-all.tar.gz

# Extract it and link it
echo Extracting tarball and linking to rtcmix-daily folder
#tar -zxvf RTcmix-all.tar.gz | grep THANKS | xargs -I {} ln -s `basename {}` rtcmix-daily
tar -zxvf RTcmix-all.tar.gz
ln -s RTcmix-all-* rtcmix-daily

# Apply the patch
echo Applying load_utils.c patch to rtcmix-daily/src/rtcmix
patch -d rtcmix-daily/src/rtcmix/ < load_utils.c.patch

# configure it!
echo Running rtcmix-daily/configure script
cd rtcmix-daily
./configure
# This is just for linux, hopefully doesn't break other O/S
echo "OPT=-fPIC -O2" >> site.conf

# Make it!
echo Building rtcmix \(not installing\)
make

# OK now build our own stuff
echo Setting RTCMIX_PATH environmental variable to:
echo --\> `pwd`/
export RTCMIX_PATH=`pwd`/
cd ..
echo Building PyRTcmix \(python setup.py build_ext\)
python setup.py build_ext
echo Attempting to install. If this fails, simply run 'sudo python setup.py install' to complete
python setup.py install
echo \^---- if that failed, run \"sudo python setup.py install\"

#this is also needed as long as /usr/lib is in ldconfig's path
echo finally, you\'ll need to do this:
echo ln -s $RTCMIX_PATH/lib/librtcmix.so /usr/lib/
echo ln -s $RTCMIX_PATH/lib/libgen.so /ur/lib/
