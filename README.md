# securedrop-keyring

This repository contains the code needed to build the securedrop-keyring package, which contains and manages updates for the key that is used to sign the Release file for the [SecureDrop](https://github.com/freedomofpress/securedrop) apt repository at [apt.freedom.press](https://apt.freedom.press), which is maintained by [Freedom of the Press Foundation](https://freedom.press).

The source was forked from deb.torproject.org-keyring, which in turn is based on debian-archive-keyring.

## Building the package

Requirements: `build-essential` and/or `dpkg-dev` and `debhelper`

Run the following command in the source directory:

        dpkg-buildpackage -us -uc

This will output the .deb file to the parent directory.

## Updating the repository signing key

Export the armored and updated public key to `./keyrings/securedrop-keyring.gpg` and then run:

	./update_keyring.sh

This will update the changelog, update the removal hooks with the fingerprint, build the package, and initiate a git commit.

See [TESTING.md](TESTING.md) for some tips on how to test updates to this package.
