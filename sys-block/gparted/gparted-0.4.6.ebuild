# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-block/gparted/gparted-0.4.6.ebuild,v 1.1 2009/08/08 21:47:21 eva Exp $

EAPI="1"
GCONF_DEBUG="no"

inherit eutils gnome2

DESCRIPTION="Gnome Partition Editor"
HOMEPAGE="http://gparted.sourceforge.net/"

SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="dmraid fat gnome hfs jfs kde ntfs reiserfs reiser4 xfs xfce"

common_depends=">=sys-apps/parted-1.7.1
	>=dev-cpp/gtkmm-2.8.0"

RDEPEND="${common_depends}
	gnome? ( x11-libs/gksu )
	xfce? ( x11-libs/gksu )
	kde? ( || ( kde-base/kdesu kde-base/kdebase ) )

	>=sys-fs/e2fsprogs-1.41.0
	dmraid? ( || (
			>=sys-fs/lvm2-2.02.45
			sys-fs/device-mapper )
		sys-fs/dmraid
		sys-fs/multipath-tools )
	fat? ( sys-fs/dosfstools )
	ntfs? ( sys-fs/ntfsprogs )
	hfs? (
		sys-fs/udev
		sys-fs/hfsutils )
	jfs? ( sys-fs/jfsutils )
	reiserfs? ( sys-fs/reiserfsprogs )
	reiser4? ( sys-fs/reiser4progs )
	xfs? ( sys-fs/xfsprogs sys-fs/xfsdump )"

DEPEND="${common_depends}
	>=dev-util/pkgconfig-0.12
	>=dev-util/intltool-0.35.5
	app-text/scrollkeeper
	app-text/gnome-doc-utils
	app-text/docbook-xml-dtd:4.1.2"

DOCS="AUTHORS NEWS ChangeLog README"

src_unpack() {
	gnome2_src_unpack

	# Revert upstream changes to use gksu inconditionally
	sed "s:Exec=@gksuprog@ :Exec=:" \
		-i gparted.desktop.in.in || die "sed 1 failed"
}

pkg_setup() {
	G2CONF="${G2CONF}
		--enable-doc
		--disable-scrollkeeper
		GKSUPROG=$(type -P true)"
}

src_install() {
	gnome2_src_install

	if use kde; then
		cp "${D}"/usr/share/applications/gparted.desktop \
			"${D}"/usr/share/applications/gparted-kde.desktop

		sed -i "s:Exec=:Exec=kdesu :" "${D}"/usr/share/applications/gparted-kde.desktop
		echo "OnlyShowIn=KDE;" >> "${D}"/usr/share/applications/gparted-kde.desktop
	fi

	if use gnome || use xfce; then
		sed -i "s:Exec=:Exec=gksu :" "${D}"/usr/share/applications/gparted.desktop
		echo "OnlyShowIn=GNOME;XFCE;" >> "${D}"/usr/share/applications/gparted.desktop
	else
		echo "OnlyShowIn=X-NeverShowThis;" >> "${D}"/usr/share/applications/gparted.desktop
	fi
}
