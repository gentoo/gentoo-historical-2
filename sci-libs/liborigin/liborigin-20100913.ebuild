# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/liborigin/liborigin-20100913.ebuild,v 1.1 2010/10/18 16:01:44 jlec Exp $

EAPI="3"

inherit eutils qt4-r2

DESCRIPTION="Library for reading OriginLab OPJ project files"
HOMEPAGE="http://soft.proindependent.com/liborigin2/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc"

RDEPEND="dev-libs/boost"
DEPEND="${RDEPEND}
	x11-libs/qt-gui:4
	dev-cpp/tree
	doc? ( app-doc/doxygen )"

DOCS="readme FORMAT"

S="${WORKDIR}"/${PN}${SLOT}

src_prepare() {
	mv liborigin2.pro liborigin.pro || die
	qt4-r2_src_prepare
	cat >> liborigin.pro <<-EOF
		INCLUDEPATH += "${EPREFIX}/usr/include/tree"
		headers.files = \$\$HEADERS
		headers.path = "${EPREFIX}/usr/include/liborigin2"
		target.path = "${EPREFIX}/usr/$(get_libdir)"
		INSTALLS = target headers
	EOF
	# use system one
	rm -f tree.hh || die
}

src_compile() {
	qt4-r2_src_compile
	if use doc; then
		cd doc
		doxygen Doxyfile || die "doc generation failed"
	fi
}

src_install() {
	qt4-r2_src_install
	if use doc; then
		insinto /usr/share/doc/${PF}
		doins -r doc/html || die "doc install failed"
	fi
}
