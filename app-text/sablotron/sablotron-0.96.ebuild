# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/sablotron/sablotron-0.96.ebuild,v 1.12 2004/02/23 16:41:08 usata Exp $

inherit eutils libtool

MY_P="Sablot-${PV}"
S="${WORKDIR}/${MY_P}"
DESCRIPTION="An XSLT Parser in C++"
SRC_URI="http://download-1..gingerall.cz/download/sablot/${MY_P}.tar.gz"
HOMEPAGE="http://www.gingerall.com/charlie/ga/xml/p_sab.xml"

SLOT="0"
LICENSE="MPL-1.1"
KEYWORDS="x86 sparc ~ppc hppa"

DEPEND=">=dev-libs/expat-1.95.1"

src_unpack() {
	unpack ${A}
	cd ${S}/src/engine
	epatch ${FILESDIR}/Sablot-0.96.1.patch
}

src_compile() {
	local myconf=

	# Please do not remove, else we get references to PORTAGE_TMPDIR
	# in /usr/lib/libsablot.la ...
	elibtoolize

	use perl && myconf="--enable-perlconnect"

	# rphillips
	# fixes bug #3876
	export LDFLAGS="-lstdc++"

	econf ${myconf}
	make || die
}

src_install() {
	einstall
	dodoc README* RELEASE
	dodoc src/TODO
}
