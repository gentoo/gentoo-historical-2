# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/sablotron/sablotron-0.97.ebuild,v 1.17 2004/04/26 12:06:13 obz Exp $

inherit libtool

S="${WORKDIR}/Sablot-${PV}"
DESCRIPTION="An XSLT Parser in C++"
SRC_URI="http://download-1.gingerall.cz/download/sablot/Sablot-${PV}.tar.gz"
HOMEPAGE="http://www.gingerall.com/charlie/ga/xml/p_sab.xml"
LICENSE="MPL-1.1"

SLOT="0"
IUSE=""
KEYWORDS="x86 sparc ppc hppa alpha amd64 ~mips"

DEPEND=">=dev-libs/expat-1.95.6-r1
	dev-perl/XML-Parser"

src_compile() {
	local myconf=

	# Please do not remove, else we get references to PORTAGE_TMPDIR
	# in /usr/lib/libsablot.la ...
	elibtoolize

	use perl && myconf="--enable-perlconnect"

	# rphillips
	# fixes bug #3876
	export LDFLAGS="-lstdc++"

	econf ${myconf} || die "econf failed"
	make || die
}

src_install() {
	einstall
	dodoc README* RELEASE
	dodoc src/TODO
}
