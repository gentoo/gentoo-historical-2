# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/mtools/mtools-3.9.9.ebuild,v 1.13 2005/02/13 17:20:54 lanius Exp $

DESCRIPTION="utilities to access MS-DOS disks from Unix without mounting them"
HOMEPAGE="http://mtools.linux.lu/"
SRC_URI="http://mtools.linux.lu/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc alpha amd64 ppc64"
IUSE=""

DEPEND="sys-apps/texinfo"

src_compile() {
	econf --sysconfdir=/etc/mtools || die
	emake || die "emake failed"
}

src_install() {
	einstall sysconfdir=${D}/etc/mtools
	insinto /etc/mtools
	newins mtools.conf mtools.conf.example
	dodoc Changelog NEWPARAMS README* Release.notes
}
