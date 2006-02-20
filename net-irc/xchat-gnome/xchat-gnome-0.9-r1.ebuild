# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/xchat-gnome/xchat-gnome-0.9-r1.ebuild,v 1.3 2006/02/20 15:25:30 antarus Exp $

inherit gnome2 eutils autotools

DESCRIPTION="GNOME frontend for the popular X-Chat IRC client"
HOMEPAGE="http://xchat-gnome.navi.cx/"
SRC_URI="http://releases.navi.cx/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="perl tcltk python ssl mmx ipv6 nls dbus libsexy libnotify"

RDEPEND=">=dev-libs/glib-2.0.3
	>=gnome-base/libgnome-2
	>=gnome-base/gconf-2
	>=gnome-base/libgnomeui-2
	>=gnome-base/libglade-2
	>=gnome-base/gnome-vfs-2
	>=x11-libs/gtk+-2.8
	ssl? ( >=dev-libs/openssl-0.9.6d )
	perl? ( >=dev-lang/perl-5.6.1 )
	python? ( dev-lang/python )
	tcltk? ( dev-lang/tcl )
	dbus? ( >=sys-apps/dbus-0.35 )
	libsexy? ( x11-libs/libsexy )
	libnotify? ( x11-libs/libnotify )"

DEPEND="${RDEPEND}
	gnome-base/gnome-common
	>=dev-util/pkgconfig-0.7
	nls? ( sys-devel/gettext )"

# gnome-base/gnome-common is temporarily needed for re-creating configure

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/xchat-gnome-0.7-scrollkeeper.patch
	epatch ${FILESDIR}/0.9-libnotify-libsexy-configure.patch
	epatch ${FILESDIR}/0.9-libnotify-api-changes.patch

	AT_M4DIR="m4" eautoreconf
}

src_compile() {
	econf \
		--enable-gnomefe \
		--enable-shm \
		$(use_enable ssl openssl) \
		$(use_enable perl) \
		$(use_enable python) \
		$(use_enable tcltk tcl) \
		$(use_enable mmx) \
		$(use_enable ipv6) \
		$(use_enable dbus) \
		$(use_enable nls) \
		$(use_enable libsexy) \
		$(use_enable libnotify) \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	addpredict /var/lib/scrollkeeper/scrollkeeper_docs

	USE_DESTDIR="1" gnome2_src_install || die "gnome2_src_install failed"

	# install plugin development header
	insinto /usr/include/xchat-gnome
	doins src/common/xchat-plugin.h || die "doins failed"

	dodoc AUTHORS ChangeLog NEWS || die "dodoc failed"
}

pkg_postinst() {
	gnome2_gconf_install
}
