# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/winetricks/winetricks-916.ebuild,v 1.1 2012/10/19 05:50:00 tetromino Exp $

EAPI=4

inherit gnome2-utils eutils

if [[ ${PV} == "99999999" ]] ; then
	ESVN_REPO_URI="http://winetricks.googlecode.com/svn/trunk"
	inherit subversion
else
	SRC_URI="http://winetricks.googlecode.com/svn-history/r${PV}/trunk/src/winetricks -> ${P}
		http://winetricks.googlecode.com/svn-history/r${PV}/trunk/src/winetricks.1 -> ${P}.1"
	KEYWORDS="~amd64 ~x86"
fi
wtg=winetricks-gentoo-2012.10.19
SRC_URI="${SRC_URI}
	http://dev.gentoo.org/~tetromino/distfiles/wine/${wtg}.tar.bz2"

DESCRIPTION="Easy way to install DLLs needed to work around problems in Wine"
HOMEPAGE="http://code.google.com/p/winetricks/ http://wiki.winehq.org/winetricks"

LICENSE="LGPL-2.1+"
SLOT="0"
IUSE="gtk kde"

DEPEND=""
RDEPEND="app-arch/cabextract
	app-arch/unzip
	app-emulation/wine
	gtk? ( gnome-extra/zenity )
	kde? ( kde-base/kdialog )"

S="${WORKDIR}"

src_unpack() {
	if [[ ${PV} == "99999999" ]] ; then
		subversion_src_unpack
	else
		mkdir src
		cp "${DISTDIR}"/${P} src/${PN} || die
		cp "${DISTDIR}"/${P}.1 src/${PN}.1 || die
	fi
	unpack ${wtg}.tar.bz2
}

src_install() {
	cd src
	dobin ${PN}
	doman ${PN}.1
	cd ../${wtg} || die
	domenu winetricks.desktop
	insinto /usr/share/icons/hicolor/scalable/apps
	doins wine-winetricks.svg
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
