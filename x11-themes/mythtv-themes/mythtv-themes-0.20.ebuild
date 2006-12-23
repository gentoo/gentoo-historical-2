# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/mythtv-themes/mythtv-themes-0.20.ebuild,v 1.3 2006/12/23 21:34:37 cardoe Exp $

inherit qt3

DESCRIPTION="A collection of themes for the MythTV project."
HOMEPAGE="http://www.mythtv.org/"
SRC_URI="http://www.mythtv.org/mc/myththemes-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 x86"
IUSE=""

RDEPEND="$(qt_min_version 3.3)
	>=media-tv/mythtv-${PV}"

S="${WORKDIR}/myththemes-${PV}"

src_compile() {
	cd ${S}
	./configure --prefix="${ROOT}"/usr || die "configure died"

	${QTDIR}/bin/qmake QMAKE=${QTDIR}/bin/qmake -o "Makefile" myththemes.pro || die "qmake failed"
}

src_install() {
	einstall INSTALL_ROOT="${D}" || die "install failed"
}
