# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/qtcurve/qtcurve-1.8.17.ebuild,v 1.3 2013/11/04 08:22:29 polynomial-c Exp $

EAPI=5
KDE_REQUIRED="optional"
inherit cmake-utils kde4-base

DESCRIPTION="A set of widget styles for Qt and GTK2"
HOMEPAGE="https://github.com/QtCurve/qtcurve"

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/QtCurve/qtcurve.git"
	KEYWORDS=""
else
	SRC_URI="https://github.com/QtCurve/${PN}/archive/${PV}.tar.gz  -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="+X gtk kde nls +qt4 qt5 windeco"
REQUIRED_USE="gtk? ( X )
	windeco? ( kde X )
	|| ( gtk qt4 qt5 )"

RDEPEND="X? ( x11-libs/libxcb
		x11-libs/libX11 )
	gtk? ( x11-libs/gtk+:2 )
	qt4? ( dev-qt/qtdbus:4
		dev-qt/qtgui:4
		dev-qt/qtsvg:4
	)
	qt5? ( dev-qt/qtgui:5
		dev-qt/qtsvg:5
		dev-qt/qtwidgets:5
		X? ( dev-qt/qtdbus:5
			dev-qt/qtx11extras:5 )
	)
	kde? ( $(add_kdebase_dep systemsettings)
		windeco? ( $(add_kdebase_dep kwin) )
	)
	!x11-themes/gtk-engines-qtcurve"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

DOCS=( AUTHORS ChangeLog.md README.md TODO.md )

pkg_setup() {
	use kde && kde4-base_pkg_setup
}

src_configure() {
	local mycmakeargs
	mycmakeargs=(
		$(cmake-utils_use_enable gtk GTK2)
		$(cmake-utils_use_enable qt4 QT4)
		$(cmake-utils_use_enable qt5 QT5)
		$(cmake-utils_use X QTC_ENABLE_X11 )
		$(cmake-utils_use kde QTC_QT4_ENABLE_KDE )
		$(cmake-utils_use windeco QTC_QT4_ENABLE_KWIN )
		$(cmake-utils_use nls QTC_INSTALL_PO )
	)
	cmake-utils_src_configure
}
