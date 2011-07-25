# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/qscintilla/qscintilla-2.5.1.ebuild,v 1.4 2011/07/25 20:40:01 xarthisius Exp $

EAPI="3"

inherit qt4-r2

MY_P="QScintilla-gpl-${PV/_pre/-snapshot-}"

DESCRIPTION="A Qt port of Neil Hodgson's Scintilla C++ editor class"
HOMEPAGE="http://www.riverbankcomputing.co.uk/software/qscintilla/intro"
SRC_URI="http://www.riverbankcomputing.co.uk/static/Downloads/QScintilla2/${MY_P}.tar.gz"

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ppc ppc64 ~sparc x86 ~x86-fbsd"
IUSE="doc python"

DEPEND="x11-libs/qt-gui:4"
RDEPEND="${DEPEND}"
PDEPEND="python? ( ~dev-python/qscintilla-python-${PV} )"

S=${WORKDIR}/${MY_P}

PATCHES=("${FILESDIR}/${PN}-2.4-designer.patch")

src_configure() {
	pushd Qt4 > /dev/null
	einfo "Configuration of qscintilla"
	eqmake4 qscintilla.pro
	popd > /dev/null

	pushd designer-Qt4 > /dev/null
	einfo "Configuration of designer plugin"
	eqmake4 designer.pro
	popd > /dev/null
}

src_compile() {
	pushd Qt4 > /dev/null
	einfo "Building of qscintilla"
	emake || die "Building of qscintilla failed"
	popd > /dev/null

	pushd designer-Qt4 > /dev/null
	einfo "Building of designer plugin"
	emake || die "Building of designer plugin failed"
	popd > /dev/null
}

src_install() {
	pushd Qt4 > /dev/null
	einfo "Installation of qscintilla"
	emake INSTALL_ROOT="${D}" install || die "Installation of qscintilla failed"
	popd > /dev/null

	pushd designer-Qt4 > /dev/null
	einfo "Installation of designer plugin"
	emake INSTALL_ROOT="${D}" install || die "Installation of designer plugin failed"
	popd > /dev/null

	dodoc NEWS || die "dodoc failed"
	if use doc; then
		einfo "Installation of documentation"
		dohtml doc/html-Qt4/* || die "dohtml failed"
		insinto /usr/share/doc/${PF}/Scintilla
		doins doc/Scintilla/* || die "doins failed"
	fi
}
