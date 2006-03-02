# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/nasty/nasty-0.6-r1.ebuild,v 1.2 2006/03/02 02:45:56 vanquirius Exp $

DESCRIPTION="Proof-of-concept GPG passphrase recovery tool."
HOMEPAGE="http://www.vanheusden.com/nasty/"
SRC_URI="http://www.vanheusden.com/nasty/${P}.tgz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
RDEPEND="app-crypt/gpgme"

src_unpack() {
	unpack ${A}
	sed -i.orig \
		-e 's,^LDFLAGS=-lgpgme,LDFLAGS=`gpgme-config --libs`,g' \
		-e '/^CFLAGS/s,$(DEBUG),`gpgme-config --cflags` $(DEBUG),g' \
		"${S}"/Makefile || die "sed failed"
}

src_compile() {
	emake DEBUG=''
}

src_install() {
	dobin nasty
	dodoc readme.txt
}
