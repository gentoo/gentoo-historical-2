# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/liborigin/liborigin-20090406.ebuild,v 1.3 2010/04/26 20:34:20 maekke Exp $

EAPI=2
inherit eutils qt4

# hardcoded for now until it's back in sourceforge
MYP=${PN}2-06042009
S="${WORKDIR}/${MYP}"

DESCRIPTION="Library for reading OriginLab OPJ project files"
SRC_URI="mirror://berlios/qtiplot/${MYP}.zip"
HOMEPAGE="http://sourceforge.net/projects/liborigin/"

LICENSE="GPL-3"
KEYWORDS="amd64 x86"

SLOT="2"
IUSE="doc"

RDEPEND="dev-libs/boost"
DEPEND="${RDEPEND}
	x11-libs/qt-gui:4
	dev-cpp/tree
	doc? ( app-doc/doxygen )"

src_prepare() {
	cat >> liborigin.pro <<-EOF
		INCLUDEPATH += /usr/include/tree
		headers.files = \$\$HEADERS
		headers.path = /usr/include/liborigin2
		target.path = /usr/$(get_libdir)
		INSTALLS = target headers
	EOF
	# use system one
	rm -f tree.hh || die
}

src_configure() {
	eqmake4
}

src_compile() {
	emake || die "emake failed"
	if use doc; then
		cd doc
		doxygen Doxyfile || die "doc generation failed"
	fi
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die "emake install failed"
	dodoc readme FORMAT
	if use doc; then
		insinto /usr/share/doc/${PF}
		doins -r doc/html || die "doc install failed"
	fi
}
