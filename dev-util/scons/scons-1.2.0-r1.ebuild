# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/scons/scons-1.2.0-r1.ebuild,v 1.7 2009/04/12 18:07:35 ranger Exp $

EAPI=2
inherit distutils

DESCRIPTION="Extensible Python-based build utility"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz
	doc? ( http://www.scons.org/doc/${PV}/PDF/${PN}-user.pdf -> ${P}-user.pdf
		   http://www.scons.org/doc/${PV}/HTML/${PN}-user.html -> ${P}-user.html )"

HOMEPAGE="http://www.scons.org/"

SLOT="0"
LICENSE="MIT"
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="doc"
DEPEND=">=dev-lang/python-2.5[threads]"
DOCS="RELEASE.txt CHANGES.txt"

src_prepare() {
	# from debian, fix links and removes
	epatch "${FILESDIR}"/${P}-links.patch
	epatch "${FILESDIR}"/${P}-popen.patch
}

src_install () {
	distutils_src_install
	# move man pages from /usr/man to /usr/share/man
	dodir /usr/share
	mv "${D}"/usr/man "${D}"/usr/share
	if use doc; then
		insinto /usr/share/doc/${PF}
		doins "${DISTDIR}"/${P}-user.{pdf,html}
	fi
}

pkg_postinst() {
	python_mod_optimize /usr/$(get_libdir)/${P}
}

pkg_postrm() {
	python_mod_cleanup /usr/$(get_libdir)/${P}
}
