# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/asapm/asapm-2.10.ebuild,v 1.7 2004/06/19 03:53:14 kloeri Exp $

inherit eutils

DESCRIPTION="APM monitor for AfterStep"
SRC_URI="http://www.tigr.net/afterstep/download/asapm/asapm-2.10.tar.gz"

HOMEPAGE="http://www.tigr.net/afterstep/list.pl"
LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="x86 sparc "

DEPEND="virtual/glibc virtual/x11"

src_compile() {
	./configure --infodir=/usr/share/info --mandir=/usr/share/man --prefix=/usr --host=${CHOST} || die
	epatch ${FILESDIR}/${PF}-gentoo.diff
	emake || die
}

src_install () {
	dodir usr/bin
	dodir usr/share/man/man1

	make prefix=${D} install || die
}

