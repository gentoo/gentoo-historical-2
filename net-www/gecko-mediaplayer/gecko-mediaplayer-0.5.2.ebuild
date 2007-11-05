# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-www/gecko-mediaplayer/gecko-mediaplayer-0.5.2.ebuild,v 1.1 2007/11/05 20:15:32 drac Exp $

inherit multilib

DESCRIPTION="A browser plug-in for GNOME MPlayer."
HOMEPAGE="http://dekorte.homeip.net/download/gecko-mediaplayer"
SRC_URI="http://dekorte.homeip.net/download/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-libs/dbus-glib
	>=media-video/gnome-mplayer-0.5.2
	|| ( net-libs/xulrunner
		www-client/mozilla-firefox
		www-client/seamonkey
		www-client/epiphany )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	sys-devel/gettext"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."

	dodir /usr/$(get_libdir)/nsbrowser/plugins

	mv "${D}"/usr/$(get_libdir)/mozilla/plugins/${PN}* \
		"${D}"/usr/$(get_libdir)/nsbrowser/plugins

	rm -rf "${D}"/usr/share/doc/${PN}

	dodoc ChangeLog
}
