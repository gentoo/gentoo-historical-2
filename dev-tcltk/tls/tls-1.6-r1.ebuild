# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tcltk/tls/tls-1.6-r1.ebuild,v 1.1 2009/11/16 19:57:19 mescalinum Exp $

inherit eutils

MY_P="${PN}${PV}"
DESCRIPTION="TLS OpenSSL extension to Tcl."
HOMEPAGE="http://tls.sourceforge.net/"
SRC_URI="mirror://sourceforge/tls/${MY_P}-src.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~sparc ~x86"
IUSE="tk"

RESTRICT="test"

DEPEND=">=dev-lang/tcl-8.3.3
	dev-libs/openssl
	tk? ( >=dev-lang/tk-8.3.3 )"

S="${WORKDIR}/${MY_P}"

src_compile() {
	econf --with-ssl-dir=/usr || die
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc ChangeLog README.txt
	dohtml tls.htm
}
