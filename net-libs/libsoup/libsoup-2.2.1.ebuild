# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libsoup/libsoup-2.2.1.ebuild,v 1.15 2005/02/10 11:29:16 dragonheart Exp $

inherit gnome2

DESCRIPTION="Soup is a SOAP implementation"
HOMEPAGE="http://www.gnome.org/"

LICENSE="LGPL-2"
SLOT="2.2"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 sparc x86"
IUSE="ssl doc ipv6"

RDEPEND=">=dev-libs/glib-2
	>=dev-libs/libxml2-2
	ssl? ( >=net-libs/gnutls-1.0
		>=dev-libs/libgpg-error-0.4 )"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.12.0
	doc? ( >=dev-util/gtk-doc-1.0 )"

G2CONF="${G2CONF} $(use_enable ssl) $(use_enable ipv6)"
DOCS="AUTHORS ChangeLog README* TODO"

src_unpack() {
	unpack ${A}
	has_version ">=net-libs/gnutls-1.1.23" && sed -e's|GNUTLS_CERT_NOT_TRUSTED|GNUTLS_CERT_INVALID|g' -i ${S}/libsoup/soup-gnutls.c
}

