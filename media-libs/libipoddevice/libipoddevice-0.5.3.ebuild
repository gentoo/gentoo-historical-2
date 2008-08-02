# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libipoddevice/libipoddevice-0.5.3.ebuild,v 1.7 2008/08/02 21:08:11 loki_val Exp $

inherit base autotools

DESCRIPTION="device-specific layer for the Apple iPod"
HOMEPAGE="http://banshee-project.org/Libipoddevice"
SRC_URI="http://banshee-project.org/files/libipoddevice/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND=">=dev-libs/dbus-glib-0.71
	>=sys-apps/hal-0.5.2
	sys-apps/pmount
	virtual/eject
	>=gnome-base/libgtop-2.12
	>=sys-apps/sg3_utils-1.20"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

PATCHES=( "${FILESDIR}/${P}-libsgutils2.patch" )

src_unpack() {
	base_src_unpack
	cd "${S}"
	# use correct libdir in pkgconfig file
	sed -i -e 's:^libdir=.*:libdir=@libdir@:' \
		ipoddevice.pc.in || die "sed failed."
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc ChangeLog NEWS README
}
