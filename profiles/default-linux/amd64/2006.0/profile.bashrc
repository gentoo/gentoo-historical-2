# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/profiles/default-linux/amd64/2006.0/profile.bashrc,v 1.1.1.1 2005/11/30 09:48:35 chriswhite Exp $

if [ -z "${IWANTTOTRASHMYSYSTEM}" ]; then
	eerror "The amd64 2006.0 profile is still in active development and requires"
	eerror "some packages still in package.mask or ~amd64 and is not yet ready for user testing."
	eerror "An announcement will be made on gentoo-amd64@gentoo.org once we are ready for testers."
	exit 1
fi
