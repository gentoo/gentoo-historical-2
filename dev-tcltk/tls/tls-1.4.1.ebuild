# Copyright 2003 Arcady Genkin <agenkin@gentoo.org>
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tcltk/tls/tls-1.4.1.ebuild,v 1.3 2003/08/07 03:26:51 vapier Exp $

DESCRIPTION="TLS OpenSSL extension to Tcl."
HOMEPAGE="http://tls.sourceforge.net/"
SRC_URI="mirror://sourceforge/tls/${PN}${PV}-src.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="x86"

DEPEND=">=dev-lang/tcl-8.3.3
	>=dev-lang/tk-8.3.3
	dev-libs/openssl"

S=${WORKDIR}/tls1.4

src_compile() {
	econf --with-ssl-dir=/usr || die
	make || die
}

src_install() {
	einstall || die
	dodoc ChangeLog README.txt license.terms
}
