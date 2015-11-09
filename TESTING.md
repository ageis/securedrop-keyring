# Testing updates to apt.freedom.press-keyring

[aptly](http://www.aptly.info/) can be used to create a testing repository, first by adding the .deb built by the scripts from this repo:

	aptly repo create -distribution=trusty keyring
	aptly repo add keyring apt.freedom.press-keyring_2015.11.07_all.deb
	aptly snapshot create keyring from repo keyring
	aptly -architectures=amd64 publish snapshot -distribution=trusty keyring

You can then run `aptly serve` or set up a virtual host pointing the document root of aptly's public directory, and install this
repo on the test system in `/etc/apt/sources.list.d/`. Run `apt-get update && apt-get install apt.freedom.press-keyring`.

After updating the key via the `update-keyring.sh` script, add the latest .deb to the repo and publish it:

	aptly repo add keyring apt.freedom.press-keyring_2015.11.08_all.deb
	aptly snapshot create keyring-2 from repo keyring
	aptly publish switch trusty keyring-2

Now run `apt-get update`. The newer package will be shown as available for update — the version number is incremented by date.
