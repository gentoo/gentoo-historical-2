# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/compiz/compiz-0.6.2-r1.ebuild,v 1.5 2008/07/25 14:03:52 carlo Exp $

EAPI=1

inherit gnome2 eutils

DESCRIPTION="3D composite- and windowmanager"
HOMEPAGE="http://www.compiz.org/"
SRC_URI="http://xorg.freedesktop.org/archive/individual/app/${P}.tar.gz"
LICENSE="GPL-2 LGPL-2.1 MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="dbus gnome kde svg"

DEPEND=">=media-libs/mesa-6.5.1-r1
	>=media-libs/glitz-0.5.6
	>=x11-base/xorg-server-1.1.1-r1
	x11-libs/libXdamage
	x11-libs/libXrandr
	x11-libs/libXcomposite
	x11-libs/libXinerama
	media-libs/libpng
	>=x11-libs/gtk+-2.0
	x11-libs/pango
	x11-libs/startup-notification
	gnome-base/gconf
	>=x11-libs/libwnck-2.18.3
	dev-libs/libxslt
	gnome? ( >=gnome-base/gnome-control-center-2.16.1 )
	svg? ( gnome-base/librsvg )
	dbus? ( >=sys-apps/dbus-1.0
			dev-libs/dbus-glib )
	kde? (
		|| ( kde-base/kwin:3.5 kde-base/kdebase:3.5 )
		dev-libs/dbus-qt3-old )"

RDEPEND="${DEPEND}
	x11-apps/mesa-progs"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/compiz-0.6.2-CVE-2007-3920.patch"
}

src_compile() {
	econf --with-default-plugins \
		--enable-gtk \
		--enable-gconf \
		`use_enable gnome` \
		`use_enable gnome metacity` \
		`use_enable kde` \
		`use_enable svg librsvg` \
		`use_enable dbus` \
		`use_enable dbus dbus-glib` || die

	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	dobin "${FILESDIR}/0.3.6/compiz-start" || die
	dodoc AUTHORS ChangeLog NEWS README TODO || die
}
