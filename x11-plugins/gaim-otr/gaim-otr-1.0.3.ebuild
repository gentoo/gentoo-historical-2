# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/gaim-otr/gaim-otr-1.0.3.ebuild,v 1.5 2007/01/05 04:40:40 dirtyepic Exp $

inherit flag-o-matic eutils

DESCRIPTION="(OTR) Messaging allows you to have private conversations over instant messaging"
HOMEPAGE="http://www.cypherpunks.ca/otr/"
SRC_URI="http://www.cypherpunks.ca/otr/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="net-libs/libotr
	>=net-im/gaim-1.1.0"

src_unpack() {
	unpack ${A}
	cd ${S}

	#fix bug #80405
	epatch ${FILESDIR}/gaim-otr-1.0.3-fPIC.patch
}

src_compile() {
	strip-flags
	replace-flags -O? -O2

	emake -j1 || die "Make failed"
}

src_install() {
	make install DESTDIR=${D} || die "Install failed"
	dodoc COPYING ChangeLog README
}
