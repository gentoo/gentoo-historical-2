# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/loudmouth/loudmouth-1.4.2-r1.ebuild,v 1.1 2008/10/23 09:48:03 leio Exp $

inherit gnome2

DESCRIPTION="Lightweight C Jabber library"
HOMEPAGE="http://www.loudmouth-project.org/"
SRC_URI="http://ftp.imendio.com/pub/imendio/${PN}/src/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"

IUSE="doc ssl debug test"

RDEPEND=">=dev-libs/glib-2.4
	ssl? ( >=net-libs/gnutls-1.4.0 )"
# FIXME: can't build against system lib
#	asyncns? ( net-libs/libasyncns )"
#   openssl dropped because of bug #216705

DEPEND="${RDEPEND}
	test? ( dev-libs/check )
	dev-util/pkgconfig
	doc? ( >=dev-util/gtk-doc-1 )"

DOCS="AUTHORS ChangeLog NEWS README"

pkg_setup() {
	G2CONF="${G2CONF} $(use_enable debug)
		--without-asyncns"
	# Currently asyncns segfaults on some machines and breaks XMPP for telepathy, disabled till fixed

	if use ssl; then
		G2CONF="${G2CONF} --with-ssl=gnutls"
	else
		G2CONF="${G2CONF} --with-ssl=no"
	fi
}
