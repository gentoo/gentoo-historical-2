# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/yaala/yaala-0.4.2.ebuild,v 1.2 2003/01/22 08:06:52 lostlogic Exp $

SRC_URI="http://verplant.org/yaala/yaala-0.4.2.tar.bz2"
HOMEPAGE="http://verplant.org/yaala/"
DEPEND="virtual/glibc"
LICENSE="GPLv2"
SLOT="0"
KEYWORDS="~x86 ~ppc"
DESCRIPTION="Yet Another Log Analyzer"

src_install() {
	dodir /usr/share/yaala
	cp -dpRx * ${D}usr/share/yaala
}
