# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/qwt/qwt-5.0.1.ebuild,v 1.4 2007/03/15 12:05:46 caleb Exp $

inherit multilib eutils

SRC_URI="mirror://sourceforge/qwt/${P}.tar.bz2"
HOMEPAGE="http://qwt.sourceforge.net/"
DESCRIPTION="2D plotting library for Qt4"
LICENSE="qwt"
KEYWORDS="~amd64 ~ppc64 ~x86"
SLOT="5"
IUSE="doc"

QWTVER="5.0.1"

DEPEND="=x11-libs/qt-4*
	>=sys-apps/sed-4"

src_unpack () {
	unpack ${A}

	cd ${S}

	qwtconfig=${S}/"qwtconfig.pri"
	echo > ${qwtconfig} ""
	echo >> ${qwtconfig} "target.path = /usr/$(get_libdir)"
	echo >> ${qwtconfig} "headers.path = /usr/include/qwt5"
	echo >> ${qwtconfig} "doc.path = /usr/share/doc/${PF}"
	echo >> ${qwtconfig}
	echo >> ${qwtconfig} "CONFIG += qt warn_on thread"
	echo >> ${qwtconfig} "CONFIG += release"
	echo >> ${qwtconfig} "CONFIG += QwtDll QwtPlot QwtWidgets QwtDesigner"

	# Can also do QwtExamples for example building

	echo >> ${qwtconfig} "QMAKE_CFLAGS_RELEASE += ${CFLAGS}"
	echo >> ${qwtconfig} "QMAKE_CXXFLAGS_RELEASE += ${CXXFLAGS}"

	# They got the version wrong
	sed -e "s/5.0.0/5.0.1/g" -i "${S}/src/src.pro"

	if ! useq doc; then
		echo >> "${S}/src/src.pro" "INSTALLS = target headers"
	fi

}

src_compile () {
	# -j1 due to parallel build failures ( bug # 170625 )
	/usr/bin/qmake qwt.pro
	MAKEOPTS="$MAKEOPTS -j1" emake || die

	cd designer
	/usr/bin/qmake qwtplugin.pro
	MAKEOPTS="$MAKETOPS -j1" emake || die
}

src_install () {
	make INSTALL_ROOT=${D} install
}
