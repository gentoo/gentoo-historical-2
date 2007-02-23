# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/minuit/minuit-5.15.02.ebuild,v 1.1 2007/02/23 01:52:46 bicatali Exp $

MY_PN=Minuit2

DESCRIPTION="A C++ physics analysis tool for function minimization"
HOMEPAGE="http://seal.web.cern.ch/seal/MathLibs/Minuit2/html/index.html"

SRC_URI="http://seal.web.cern.ch/seal/MathLibs/${MY_PN}/${MY_PN}-${PV}.tar.gz
	doc? ( http://seal.cern.ch/documents/minuit/mnusersguide.pdf
	http://seal.cern.ch/documents/minuit/mntutorial.pdf )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc"
DEPEND="doc? ( app-doc/doxygen )"

S=${WORKDIR}/${MY_PN}-${PV}

src_compile() {
	econf || die "econf failed"
	emake || die "emake failed"
	if use doc; then
		make docs || die "make docs failed"
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	insinto /usr/share/doc/${PF}/MnTutorial
	doins test/MnTutorial/*.{h,cxx}
	if use doc; then
		insinto /usr/share/doc/${PF}
		doins "${DISTDIR}"/mn*.pdf || die "doins failed"
		dohtml -r doc/html/* || die "dohtml failed"
	fi
}
