#!/bin/sh
#

# enigma2.sh will set this, but wget fails when it is set.
# So unset it now....
#
unset LD_PRELOAD

# Check it is being run as the root user
#
if [ "$(id -u)" != "0" ]; then
   echo >&2 "This script must be run as root"
echo   exit 1
fi

# Set properties
#--------------------------------------------------
# Start date
#
before="$(date +%s)"

ABM_urlbase=https://github.com/stuartygr2016/AutoBouquetsMaker/raw/master/AutoBouquetsMaker/providers
todir=/usr/lib/enigma2/python/Plugins/SystemPlugins/AutoBouquetsMaker/Test
if [ ! -d $todir ]; then
   echo >&2 "Missing $todir"
   exit 2
fi

# Do the work
#
for pv in sat_282_sky_uk_CustomMix; do

# busybox wget doesn't need --no-check-certificate, but ignores it anyway...
#
   echo "Fetching ${pv}"
   file=${pv}.xml
   wget -q --no-check-certificate -O /tmp/upPv.tmp ${ABM_urlbase}/$file
   if grep -q '<provider>' /tmp/upPv.tmp; then
      echo -n "$file - Installing..."
      mv /tmp/upPv.tmp $todir/$file
      echo "done"
   else
      echo >&2 "$file - Not Installed: not a provider file"
   fi
done

after="$(date +%s)"
elapsed_seconds="$(expr $after - $before)"

echo "Completed - Elapsed time: $elapsed_seconds secs"
