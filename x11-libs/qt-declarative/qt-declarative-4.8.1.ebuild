# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/qt-declarative/qt-declarative-4.8.1.ebuild,v 1.7 2012/07/09 14:25:13 armin76 Exp $

EAPI=4

inherit qt4-build

DESCRIPTION="The Declarative module for the Qt toolkit"
SLOT="4"
KEYWORDS="alpha amd64 arm ia64 ~ppc ~ppc64 sparc x86 ~amd64-fbsd ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="+accessibility qt3support webkit"

DEPEND="
	~x11-libs/qt-core-${PV}[aqua=,c++0x=,debug=,qpa=,qt3support=]
	~x11-libs/qt-gui-${PV}[accessibility=,aqua=,c++0x=,debug=,qpa=,qt3support=]
	~x11-libs/qt-opengl-${PV}[aqua=,c++0x=,debug=,qpa=,qt3support=]
	~x11-libs/qt-script-${PV}[aqua=,c++0x=,debug=,qpa=]
	~x11-libs/qt-sql-${PV}[aqua=,c++0x=,debug=,qpa=,qt3support=]
	~x11-libs/qt-svg-${PV}[accessibility=,aqua=,c++0x=,debug=,qpa=]
	~x11-libs/qt-xmlpatterns-${PV}[aqua=,c++0x=,debug=,qpa=]
	qt3support? ( ~x11-libs/qt-qt3support-${PV}[accessibility=,aqua=,c++0x=,debug=,qpa=] )
	webkit? ( ~x11-libs/qt-webkit-${PV}[aqua=,debug=,qpa=] )
"
RDEPEND="${DEPEND}"

pkg_setup() {
	QT4_TARGET_DIRECTORIES="
		src/declarative
		src/imports
		tools/designer/src/plugins/qdeclarativeview
		tools/qml
		tools/qmlplugindump"

	if use webkit; then
		QT4_TARGET_DIRECTORIES+=" src/3rdparty/webkit/Source/WebKit/qt/declarative"
	fi

	QT4_EXTRACT_DIRECTORIES="
		include
		src
		tools
		translations"

	QCONFIG_ADD="declarative"
	QCONFIG_DEFINE="QT_DECLARATIVE"

	qt4-build_pkg_setup
}

src_configure() {
	myconf+="
		-declarative -no-gtkstyle
		$(qt_use accessibility)
		$(qt_use qt3support)
		$(qt_use webkit)"
	qt4-build_src_configure
}

src_install() {
	qt4-build_src_install

	# install private headers
	if use aqua && [[ ${CHOST##*-darwin} -ge 9 ]]; then
		insinto "${QTLIBDIR#${EPREFIX}}"/QtDeclarative.framework/Headers/private
		# ran for the 2nd time, need it for the updated headers
		fix_includes
	else
		insinto "${QTHEADERDIR#${EPREFIX}}"/QtDeclarative/private
	fi
	find "${S}"/src/declarative/ -type f -name "*_p.h" -exec doins {} +
}
