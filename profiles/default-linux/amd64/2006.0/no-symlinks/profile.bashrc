# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/profiles/default-linux/amd64/2006.0/no-symlinks/profile.bashrc,v 1.1 2005/10/07 02:22:32 eradicator Exp $

for dir in /lib /lib64 /usr/lib /usr/lib64 /usr/X11R6/lib /usr/X11R6/lib64 /usr/qt/*/lib /usr/qt/*/lib64 /usr/kde/*/lib /usr/kde/*/lib64; do
	if [ -L "${dir}" ]; then
		ewarn "${dir} is a symlink"
		#exit 1
	fi
done

if [ -z "${IWANTTOTRASHMYSYSTEM}" ]; then
	eerror "The amd64 2005.0/no-symlinks profile is still in active development"
	eerror "and not yet ready for user testing.  An announcement will be made"
	eerror "on gentoo-amd64@gentoo.org once we are ready for testers."
	exit 1
fi
