# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/xchat-gnome/xchat-gnome-0.18.ebuild,v 1.4 2008/06/30 23:11:18 mr_bones_ Exp $

inherit gnome2 eutils autotools

DESCRIPTION="GNOME frontend for the popular X-Chat IRC client"
HOMEPAGE="http://xchat-gnome.navi.cx/"
SRC_URI="http://releases.navi.cx/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="dbus ipv6 libnotify mmx nls perl python spell ssl tcl"

RDEPEND=">=dev-libs/glib-2.12.0
	>=gnome-base/libgnome-2.16.0
	>=gnome-base/gconf-2.8.0
	>=gnome-base/libgnomeui-2.16.0
	>=gnome-base/libglade-2.3.0
	>=gnome-base/gnome-vfs-2.9.2
	>=x11-libs/gtk+-2.10.0
	spell? ( app-text/enchant )
	ssl? ( >=dev-libs/openssl-0.9.6d )
	perl? ( >=dev-lang/perl-5.6.1 )
	python? ( dev-lang/python )
	tcl? ( dev-lang/tcl )
	dbus? ( >=sys-apps/dbus-0.60 )
	>=x11-libs/libsexy-0.1.11
	libnotify? ( >=x11-libs/libnotify-0.3.2 )
	x11-libs/libX11"

DEPEND="${RDEPEND}
	gnome-base/gnome-common
	>=dev-util/pkgconfig-0.7
	>=app-text/gnome-doc-utils-0.3.2
	nls? ( sys-devel/gettext )"

# gnome-base/gnome-common is temporarily needed for re-creating configure

pkg_setup() {
	G2CONF="${G2CONF}
		--enable-gnomefe
		--enable-shm
		--disable-schemas-install
		--disable-scrollkeeper
		$(use_enable ssl openssl)
		$(use_enable perl)
		$(use_enable python)
		$(use_enable tcl)
		$(use_enable mmx)
		$(use_enable ipv6)
		$(use_enable dbus)
		$(use_enable nls)
		$(use_enable libnotify)"
}

src_unpack() {
	gnome2_src_unpack

	epatch "${FILESDIR}"/0.17-libnotify-configure.patch

	AT_M4DIR="m4" eautoreconf
}

src_install() {
	USE_DESTDIR="1" gnome2_src_install || die "gnome2_src_install failed"

	# install plugin development header
	insinto /usr/include/xchat-gnome
	doins src/common/xchat-plugin.h || die "doins failed"

	dodoc AUTHORS ChangeLog NEWS || die "dodoc failed"
}
