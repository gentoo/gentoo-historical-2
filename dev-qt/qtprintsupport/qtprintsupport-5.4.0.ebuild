# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-qt/qtprintsupport/qtprintsupport-5.4.0.ebuild,v 1.2 2015/02/01 10:37:48 yngwin Exp $

EAPI=5

QT5_MODULE="qtbase"
VIRTUALX_REQUIRED="test"

inherit qt5-build

DESCRIPTION="Printing support library for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == live ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
fi

IUSE="cups opengl"

RDEPEND="
	~dev-qt/qtcore-${PV}[debug=]
	~dev-qt/qtgui-${PV}[debug=,opengl=]
	~dev-qt/qtwidgets-${PV}[debug=,opengl=]
	cups? ( >=net-print/cups-1.4 )
"
DEPEND="${RDEPEND}
	test? ( ~dev-qt/qtnetwork-${PV}[debug=] )
"

QT5_TARGET_SUBDIRS=(
	src/printsupport
	src/plugins/printsupport
)

QT5_GENTOO_CONFIG=(
	cups
)

src_configure() {
	local myconf=(
		$(qt_use cups)
	)
	qt5-build_src_configure
}
