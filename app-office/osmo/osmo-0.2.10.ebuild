# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/osmo/osmo-0.2.10.ebuild,v 1.4 2010/11/02 15:46:13 tomka Exp $

EAPI=2
inherit flag-o-matic

DESCRIPTION="A handy personal organizer"
HOMEPAGE="http://clayo.org/osmo/"
SRC_URI="mirror://sourceforge/${PN}-pim/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.12:2
	>=dev-libs/libtar-1.2.11-r3
	dev-libs/libxml2
	dev-libs/libgringotts
	>=dev-libs/libical-0.33
	app-text/gtkspell
	=gnome-extra/gtkhtml-2*
	>=x11-libs/libnotify-0.4.4"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_configure() {
	append-flags -I/usr/include/libical

	econf \
		--disable-dependency-tracking \
		--without-libsyncml
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog README TRANSLATORS || die
}
