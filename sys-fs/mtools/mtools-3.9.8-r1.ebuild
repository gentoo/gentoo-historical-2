# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/mtools/mtools-3.9.8-r1.ebuild,v 1.4 2004/03/07 19:16:45 plasmaroo Exp $

DESCRIPTION="utilities to access MS-DOS disks from Unix without mounting them"
SRC_URI="http://mtools.linux.lu/${P}.tar.gz"
HOMEPAGE="http://mtools.linux.lu/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc alpha ~amd64"

DEPEND="sys-apps/texinfo"

src_compile() {
	econf --sysconfdir=/etc/mtools
	make || die
}

src_install() {
	einstall sysconfdir=${D}/etc/mtools
	insinto /etc/mtools
	newins mtools.conf mtools.conf.example
	dodoc COPYING ChangeLog NEWPARAMS README* Release.notes
}
