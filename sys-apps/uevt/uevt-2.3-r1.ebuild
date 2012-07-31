# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/uevt/uevt-2.3-r1.ebuild,v 1.1 2012/07/31 06:24:50 ssuominen Exp $

EAPI=4

DESCRIPTION="A lightweight, desktop-independant daemon for disks mounting and power managing"
HOMEPAGE="http://elentir.sleipnir.fr/ http://git.sleipnir.fr/uevt/"
SRC_URI="http://ftp.sleipnir.fr/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEPEND=">=dev-libs/glib-2.26
	x11-libs/gtk+:2
	>=x11-libs/libnotify-0.7"
RDEPEND="${COMMON_DEPEND}
	sys-fs/udisks:0
	sys-power/upower"
DEPEND="${COMMON_DEPEND}
	dev-lang/vala:0.16
	dev-util/intltool
	virtual/pkgconfig
	sys-devel/gettext"

pkg_setup() {
	export VALAC="$(type -P valac-0.16)"
	DOCS=( AUTHORS ChangeLog README )
}

src_prepare() {
	# http://bugs.gentoo.org/428438
	echo src/configurator.c >> po/POTFILES.skip
	echo src/power-infos.c >> po/POTFILES.skip
}
