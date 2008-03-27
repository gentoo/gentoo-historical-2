# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/gnupg-pkcs11-scd/gnupg-pkcs11-scd-0.06.ebuild,v 1.2 2008/03/27 21:19:52 alonbl Exp $

DESCRIPTION="PKCS#11 support for GnuPG"
HOMEPAGE="http://gnupg-pkcs11.sourceforge.net"
SRC_URI="mirror://sourceforge/gnupg-pkcs11/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND=">=dev-libs/libgpg-error-1.3
	>=dev-libs/libgcrypt-1.2.2
	>=dev-libs/openssl-0.9.7
	>=dev-libs/pkcs11-helper-1.02"
DEPEND="${RDEPEND}
	>=dev-libs/libassuan-1.0.4
	dev-util/pkgconfig"

src_compile() {
	econf --docdir="/usr/share/doc/${PF}" || die
	emake || die
}

src_install() {
	emake install DESTDIR="${D}" || die
	prepalldocs
}
