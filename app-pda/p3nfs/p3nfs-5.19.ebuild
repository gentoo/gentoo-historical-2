# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-pda/p3nfs/p3nfs-5.19.ebuild,v 1.4 2007/01/24 03:32:04 genone Exp $

inherit eutils flag-o-matic

DESCRIPTION="Symbian to Unix and Linux communication program"
HOMEPAGE="http://www.koeniglich.de/p3nfs.html"
SRC_URI="http://www.koeniglich.de/packages/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

DEPEND="net-nds/portmap"

src_unpack() {
	unpack ${A}

	sed -i "s:.*cd client/epoc32.*:#&:" "${S}/Makefile.in"
}

src_compile() {
	append-ldflags $(bindnow-flags)
	sed -i "s:\$(LDFLAGS):${LDFLAGS}:" "${S}/server/Makefile.in"

	econf || die "econf failed"
	emake CFLAGS="${CFLAGS} -Wall -I." || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc README
}

pkg_postinst() {
	elog
	elog "You need to install one of the nfsapp-*.sis clients on your"
	elog "Symbian device to be able to mount it's filesystems."
	elog
	elog "Make sure to have portmap running before you start the"
	elog "p3nfsd server."
	elog
}
