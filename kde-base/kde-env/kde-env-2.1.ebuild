# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/kde-base/kde-env/kde-env-2.1.ebuild,v 1.1 2001/04/17 14:22:18 achim Exp $

A=""
S=${WORKDIR}
DESCRIPTION="KDE 2.1 environment"
SRC_URI=""
HOMEPAGE="http://www.kde.org/"

src_install() {

	insinto /etc/env.d
	doins ${FILESDIR}/90kde21
	exeinto /usr/X11R6/bin/wm
	doexe ${FILESDIR}/kde21

}
