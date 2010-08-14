# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/devicekit-disks/devicekit-disks-009.ebuild,v 1.8 2010/08/14 17:12:47 armin76 Exp $

EAPI="2"

inherit bash-completion gnome2

MY_PN="DeviceKit-disks"

DESCRIPTION="Daemon providing interfaces to work with storage devices"
HOMEPAGE="http://www.freedesktop.org/wiki/Software/DeviceKit"
SRC_URI="http://hal.freedesktop.org/releases/${MY_PN}-${PV}.tar.gz"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ia64 ~ppc ~ppc64 sh sparc x86"
IUSE="debug doc"

# lvm2-2.02.48-r2 dep due to bug 270350
RDEPEND=">=dev-libs/glib-2.16.1
	>=dev-libs/dbus-glib-0.82
	>=sys-apps/dbus-1.0
	>=sys-auth/polkit-0.92
	>=sys-fs/udev-145[extras]
	>=sys-fs/lvm2-2.02.48-r2
	>=sys-apps/parted-1.8.8[device-mapper]
	>=dev-libs/libatasmart-0.14
	>=sys-apps/sg3_utils-1.27.20090411

	dev-db/sqlite:3"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40
	dev-util/pkgconfig
	dev-libs/libxslt
	doc? ( >=dev-util/gtk-doc-1.3 )"
# dev-util/gtk-doc-am needed if eautoreconf

S="${WORKDIR}/${MY_PN}-${PV}"

pkg_setup() {
	# Pedantic is currently broken
	G2CONF="${G2CONF}
		--localstatedir=/var
		--disable-ansi
		--enable-man-pages
		$(use_enable debug verbose-mode)"
}

src_prepare() {
	gnome2_src_prepare

	# Fix intltoolize broken file, see upstream #577133
	sed "s:'\^\$\$lang\$\$':\^\$\$lang\$\$:g" -i po/Makefile.in.in || die "sed failed"
}

src_install() {
	gnome2_src_install

	if use bash-completion; then
		dobashcompletion "${S}/tools/devkit-disks-bash-completion.sh"
	fi
}
