# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libsoup/libsoup-2.2.1.ebuild,v 1.1 2004/10/16 19:05:20 liquidx Exp $

inherit gnome2

DESCRIPTION="Soup is a SOAP implementation"
HOMEPAGE="http://www.gnome.org/"

LICENSE="LGPL-2"
SLOT="2.2"
KEYWORDS="~x86 ~sparc ~ppc ~alpha ~hppa ~ia64 ~amd64 ~mips"
IUSE="ssl doc ipv6"

RDEPEND=">=dev-libs/glib-2
	>=dev-libs/libxml2-2
	ssl? ( >=net-libs/gnutls-1.0
		>=dev-libs/libgpg-error-0.4 )"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.12.0
	doc? ( >=dev-util/gtk-doc-1.0 )"

G2CONF="${G2CONF} $(use_enable ssl) $(use_enable ipv6)"
DOCS="AUTHORS COPYING* ChangeLog README* TODO"
