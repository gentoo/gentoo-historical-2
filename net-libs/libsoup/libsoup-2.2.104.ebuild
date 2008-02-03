# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libsoup/libsoup-2.2.104.ebuild,v 1.6 2008/02/03 11:19:37 armin76 Exp $

inherit gnome2

DESCRIPTION="An HTTP library implementation in C"
HOMEPAGE="http://www.gnome.org/"

LICENSE="LGPL-2"
SLOT="2.2"
KEYWORDS="alpha amd64 ~arm ~hppa ia64 ppc ppc64 ~sh sparc x86 ~x86-fbsd"
IUSE="doc ssl"

RDEPEND=">=dev-libs/glib-2.12
	>=dev-libs/libxml2-2
	ssl? ( >=net-libs/gnutls-1 )"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9
	doc? ( >=dev-util/gtk-doc-1 )"

DOCS="AUTHORS ChangeLog NEWS README"

pkg_setup() {
	G2CONF="$(use_enable ssl)"
}
