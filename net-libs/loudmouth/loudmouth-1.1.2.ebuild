# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/loudmouth/loudmouth-1.1.2.ebuild,v 1.1 2006/06/29 19:32:26 genstef Exp $

inherit gnome2

DESCRIPTION="Lightweight C Jabber library"
HOMEPAGE="http://loudmouth.imendio.org/"
SRC_URI="http://ftp.imendio.com/pub/imendio/${PN}/src/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"

IUSE="doc ssl debug"

RDEPEND=">=dev-libs/glib-2.4
	ssl? ( >=net-libs/gnutls-1 )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	doc? ( >=dev-util/gtk-doc-1 )"

DOCS="AUTHORS ChangeLog NEWS README"

pkg_setup() {
	G2CONF="$(use_enable ssl) \
		$(use_enable debug) \
		$(use_enable doc gtk-doc)"
}
