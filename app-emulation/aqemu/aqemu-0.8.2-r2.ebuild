# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/aqemu/aqemu-0.8.2-r2.ebuild,v 1.1 2012/02/21 11:21:51 maksbotan Exp $

EAPI=4

inherit  cmake-utils

DESCRIPTION="Graphical interface for QEMU and KVM emulators. Using Qt4."
HOMEPAGE="http://sourceforge.net/projects/aqemu"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="kvm vnc"

DEPEND="${RDEPEND}"
RDEPEND="kvm? ( app-emulation/qemu-kvm )
	!kvm? ( >=app-emulation/qemu-0.9.0 )
	vnc? ( net-libs/libvncserver )
	x11-libs/qt-gui:4
	x11-libs/qt-test:4
	x11-libs/qt-xmlpatterns:4"

DOCS="AUTHORS CHANGELOG README TODO"
PATCHES=( "${FILESDIR}"/aqemu-0.8.2_sigsev_propertis.patch
"${FILESDIR}"/aqemu-0.8.2_qt48_build.patch
"${FILESDIR}"/aqemu-0.8.2_desktop_file.patch )

src_configure() {
	local mycmakeargs=" -DMAN_PAGE_COMPRESSOR="" "
	if use vnc; then
		mycmakeargs+=" -DWITHOUT_EMBEDDED_DISPLAY=OFF "
	else
		mycmakeargs+=" -DWITHOUT_EMBEDDED_DISPLAY=ON "
	fi

	cmake-utils_src_configure
}
