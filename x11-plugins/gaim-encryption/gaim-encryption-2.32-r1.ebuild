# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/gaim-encryption/gaim-encryption-2.32-r1.ebuild,v 1.7 2004/12/15 12:59:48 gustavoz Exp $

inherit flag-o-matic eutils debug

DESCRIPTION="GAIM Encryption PlugIn"
HOMEPAGE="http://gaim-encryption.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc sparc x86 ~ppc64"
IUSE=""

DEPEND=">=net-im/gaim-1.0.1
		>=dev-libs/nss-3.9.2-r2"

src_compile() {
	strip-flags
	replace-flags -O? -O2

	local myconf
	myconf="${myconf} --with-nspr-includes=/usr/include/nspr"
	myconf="${myconf} --with-nss-includes=/usr/include/nss"
	myconf="${myconf} --with-nspr-libs=/usr/lib/nspr"
	myconf="${myconf} --with-nss-libs=/usr/lib/nss"

	econf ${myconf} || die "Configuration failed"

	emake || MAKEOPTS="${MAKEOPTS} -j1" emake || die "Make failed"
}

src_install() {
	make install DESTDIR=${D} || die "Install failed"
	dodoc CHANGELOG INSTALL NOTES README TODO VERSION WISHLIST
}
