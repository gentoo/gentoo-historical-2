# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/scala/scala-3.3.18-r2.ebuild,v 1.3 2011/06/21 15:57:08 jlec Exp $

EAPI="2"

inherit autotools fortran-2 eutils

DESCRIPTION="Scale together multiple observations of reflections"
HOMEPAGE="http://www.ccp4.ac.uk/dist/html/scala.html"
SRC_URI="ftp://ftp.mrc-lmb.cam.ac.uk/pub/pre/${P}.tar.gz"

LICENSE="ccp4"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	virtual/fortran

	sci-libs/ccp4-libs
	virtual/lapack
	!<sci-chemistry/ccp4-6.1.2"
DEPEND="
	${RDEPEND}
	dev-util/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${PV}-gcc4.6.patch
	cp "${FILESDIR}"/{configure.ac,Makefile.am} "${S}"
	eautoreconf
}

src_install() {
	exeinto /usr/libexec/ccp4/bin/
	doexe ${PN} || die
	dosym ../libexec/ccp4/bin/${PN} /usr/bin/${PN}
	dodoc ${PN}.doc || die
	dohtml ${PN}.html || die
}
