# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/xca/xca-0.5.1.ebuild,v 1.2 2005/03/01 18:59:04 swegener Exp $

inherit eutils kde toolchain-funcs

DESCRIPTION="a graphical user interface to OpenSSL, RSA public keys, certificates, signing requests and revokation lists"
HOMEPAGE="http://www.hohnstaedt.de/xca.html"
SRC_URI="mirror://sourceforge/xca/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=dev-libs/openssl-0.9.6
	>=x11-libs/qt-2.2.4
	>=sys-libs/db-3.2"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-qt.diff
	epatch ${FILESDIR}/configure-db-4.1.patch
	echo "inst_prefix=/usr" >> Local.mak
	epatch ${FILESDIR}/Rules.mak-prefix.patch
}

src_compile() {
	kde_src_compile nothing
	CC=$(tc-getCC) prefix=/usr ./configure || die "configure died"
	inst_prefix=/usr emake || die "emake failed"
}

src_install() {
	make destdir=${D} mandir=share/man install

	dodoc README CREDITS AUTHORS COPYRIGHT

	insinto /etc/xca
	doins misc/*.txt
}
