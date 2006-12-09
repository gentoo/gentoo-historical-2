# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libipoddevice/libipoddevice-0.5.2.ebuild,v 1.1 2006/12/09 22:26:58 metalgod Exp $

inherit multilib eutils

DESCRIPTION="libipoddevice is a device-specific layer for the Apple iPod"
HOMEPAGE="http://banshee-project.org/Libipoddevice"
SRC_URI="http://banshee-project.org/files/libipoddevice/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="|| ( >=dev-libs/dbus-glib-0.71
			( <sys-apps/dbus-0.90 >=sys-apps/dbus-0.30 ) )
	>=sys-apps/hal-0.5.2
	sys-apps/pmount
	virtual/eject"

DEPEND="${RDEPEND}
	>=dev-libs/glib-2.0
	>=gnome-base/libgtop-2.12
	>=sys-apps/sg3_utils-1.20"

src_unpack() {
	unpack ${A}
	# use correct libdir in pkgconfig file
	if [ $(get_libdir) != "lib" ] ; then
		sed -i -e 's:^libdir=.*:libdir=@libdir@:' \
			${S}/ipoddevice.pc.in || die "sed failed"
	fi
}
pkg_setup() {
	if [ ! -z $(best_version =sys-apps/dbus-0.62*) ]; then
		if ! built_with_use "=sys-apps/dbus-0.62*" gtk; then
			die "need sys-libs/dbus built with gtk USE flag"
		fi
	fi
}
src_compile() {
	econf || die "configure failed"
	emake || die "make failed"
}
src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc ChangeLog NEWS README
}
