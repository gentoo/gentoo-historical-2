# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/cute/cute-0.2.9-r2.ebuild,v 1.5 2006/01/05 20:33:25 gustavoz Exp $

inherit distutils

MY_P=${PN}-${PV/*.*.*.*/${PV%.*}-${PV##*.}}

DESCRIPTION="CUTE is a Qt and  Scintilla based text editor which can be easily extended using Python"
HOMEPAGE="http://cute.sourceforge.net/"
SRC_URI="mirror://sourceforge/cute/${MY_P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ~ppc sparc x86"
IUSE="doc"

DEPEND="virtual/python
	dev-python/qscintilla"

src_unpack() {
	unpack ${A}
	distutils_python_version
	cd ${S} ; sed -i -e "s:qscintilla::" cute.pro
	rm -rf ${S}/qscintilla ; cd ${S}/cute

	sed -i -r -e "s:#define DOC_PATH.*:#define DOC_PATH \"${ROOT}usr/share/doc/${P}/index.html\":" config.h

	# (multi-)lib fix
	sed -i -r -e "s:^QEXTSCINTILLADIR =.*:QEXTSCINTILLADIR = ${ROOT}usr/$(get_libdir):" \
		-e "s:^PYTHON_INCLUDE_DIR =.*:PYTHON_INCLUDE_DIR = ${ROOT}usr/include/python${PYVER}/:" \
		-e "s:^PYTHON_LIB_DIR =.*:PYTHON_LIB_DIR = ${ROOT}usr/$(get_libdir)/python${PYVER}/:" \
		-e "s:unix\:INCLUDEPATH=.*:unix\:INCLUDEPATH= ${QTDIR}/include ${ROOT}usr/include \\\\:" \
		-e "s:-lpython2.2:-lpython${PYVER}:" \
		-e "s:SCINTILLADIR/lib:SCINTILLADIR:" cute.pro

	echo -e "\nQMAKE_CFLAGS_RELEASE=${CFLAGS} -w\nQMAKE_CXXFLAGS_RELEASE=${CXXFLAGS} -w\nQMAKE_LFLAGS_RELEASE=${LDFLAGS}" >> cute.pro
}

src_compile() {
	cd ${S}/cute
	[ -d "$QTDIR/etc/settings" ] && addwrite "$QTDIR/etc/settings"
	addpredict "$QTDIR/etc/settings"
	${ROOT}usr/qt/3/bin/qmake QMAKE=${ROOT}usr/qt/3/bin/qmake -o Makefile cute.pro
	emake || die
}

src_install() {
	dobin ${S}/bin/cute
	if use doc ; then
		dohtml -r ${S}/cute/doc/doc/*
		dosym index.html /usr/share/doc/${PF}/html/book1.html
		insinto /usr/share/doc/${PF}/api
		doins ${S}/cute/cute-api/html/*
	fi
	insinto /usr/share/cute/langs
	doins ${S}/cute/langs/*
	insinto /usr/share/cute/lib/scripts/
	doins ${S}/cute/scripts/*
	insinto /usr/share/icons
	doins ${S}/cute/icons/cute.xpm
	dodoc changelog.txt LICENSE INSTALL README
}
