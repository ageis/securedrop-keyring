#!/bin/bash
## Update ./keyrings/apt-freedom.press-keyring.gpg with an
## armored export of the new public key before running this script.
## Usage: ./update_keyring.sh

command -v dch > /dev/null
dch_installed=$?
command -v git > /dev/null
git_installed=$?
command -v dpkg-buildpackage > /dev/null
dpkg_dev_installed=$?
if [ $dch_installed -ne 0 ] || [ $git_installed -ne 0 ] || [ $dpkg_dev_installed -ne 0 ]; then
  echo "You must run this on a system with dch + dpkg-buildpackage + git available (in order to edit the Debian package changelog and commit message)"
  echo "If you're on Debian/Ubuntu, use: apt-get install dpkg-dev devscripts git"
  exit 1
fi

set -e

export DATE=`date +%Y.%m.%d`
export DEBEMAIL="${DEBEMAIL:-securedrop@freedom.press}"
export DEBFULLNAME="${DEBFULLNAME:-SecureDrop Team}"

# Update the changelog in the Debian package
dch -v $DATE -D trusty -c debian/changelog

key_fingerprint=$(gpg --keyid-format short keyrings/apt.freedom.press-keyring.gpg | grep "^pub" | head -1 | awk '{ print $2 }' | cut -d'/' -f2)
# Update the removal hook with the key fingerprint
sed -i "s/apt-key del .*/apt-key del $key_fingerprint/" debian/prerm

# Build the package
dpkg-buildpackage -us -uc

# Commit the change
# Due to `set -e`, providing an empty commit message here will cause the script to abort early.
git commit -a

echo
echo "[ok] Keyring update complete and committed. You'll find the new package in the parent of the source directory."
echo
