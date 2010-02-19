# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/gssdp/gssdp-0.6.4.ebuild,v 1.10 2010/02/19 18:20:17 armin76 Exp $

EAPI=2

DESCRIPTION="A GObject-based API for handling resource discovery and announcement over SSDP."
HOMEPAGE="http://gupnp.org"
SRC_URI="http://gupnp.org/sources/${PN}/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 hppa ~ia64 ppc ~ppc64 ~sparc x86"
IUSE="X"

RDEPEND=">=dev-libs/glib-2.18:2
	net-libs/libsoup:2.4
	X? ( >=gnome-base/libglade-2.6 )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	sys-devel/gettext"

src_configure() {
	econf \
		--disable-dependency-tracking \
		--disable-gtk-doc \
		$(use_with X libglade)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README
}
