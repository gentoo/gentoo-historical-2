# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/twitux/twitux-0.69.ebuild,v 1.1 2009/02/11 08:50:46 welp Exp $

EAPI=1

DESCRIPTION="A Twitter client for the Gnome desktop"
HOMEPAGE="http://live.gnome.org/DanielMorales/Twitux"
SRC_URI="mirror://sourceforge/twitux/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="spell gnome-keyring"

DEPEND="net-libs/libsoup:2.4
	dev-libs/libxml2
	gnome-base/libgnome
	gnome-base/gconf
	x11-libs/gtk+:2
	dev-libs/dbus-glib
	spell? ( app-text/aspell )
	gnome-keyring? ( gnome-base/gnome-keyring )"
RDEPEND="${DEPEND}"

src_compile() {
	econf $(use_enable spell aspell) \
		$(use_enable gnome-keyring) || die "econf failed"

	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS NEWS README TODO
}
