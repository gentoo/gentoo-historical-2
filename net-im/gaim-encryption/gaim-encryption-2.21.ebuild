# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/gaim-encryption/gaim-encryption-2.21.ebuild,v 1.12 2004/04/24 04:06:16 vapier Exp $

inherit flag-o-matic

DESCRIPTION="GAIM Encryption PlugIn"
HOMEPAGE="http://gaim-encryption.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 sparc amd64 ppc alpha ia64 hppa ~mips"
IUSE=""

DEPEND=">=net-im/gaim-0.75-r3
	|| ( dev-libs/nss net-www/mozilla )"

src_compile() {
	local myconf
	myconf="--with-gaim=/usr/include/gaim"

	NSS_LIB=/usr/lib
	NSS_INC=/usr/include
	has_version dev-libs/nss && {
		# Only need to specify this if no pkgconfig from mozilla
		myconf="${myconf} --with-nspr-includes=${NSS_INC}/nspr"
		myconf="${myconf} --with-nss-includes=${NSS_INC}/nss"
		myconf="${myconf} --with-nspr-libs=${NSS_LIB}"
		myconf="${myconf} --with-nss-libs=${NSS_LIB}"
	}

	econf ${myconf} || die "Configuration failed"
	einfo "Replacing -Os CFLAG with -O2"
	replace-flags -Os -O2

	emake || emake -j1 || die "Make failed"
}

src_install() {
	einstall || die "Install failed"
	dodoc CHANGELOG INSTALL NOTES README TODO VERSION WISHLIST
}
