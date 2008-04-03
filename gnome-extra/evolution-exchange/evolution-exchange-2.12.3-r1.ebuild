# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/evolution-exchange/evolution-exchange-2.12.3-r1.ebuild,v 1.3 2008/04/03 14:27:30 ranger Exp $
EAPI="1"

inherit gnome2 eutils

DESCRIPTION="Evolution module for connecting to Microsoft Exchange"
HOMEPAGE="http://www.novell.com/products/desktop/features/evolution.html"
LICENSE="GPL-2"

SLOT="2.0"
KEYWORDS="~amd64 ~hppa ppc ~sparc ~x86"
IUSE="debug doc static"

RDEPEND=">=x11-libs/gtk+-2.10
	>=gnome-base/gconf-2.0
	>=gnome-base/libbonobo-2.0
	>=gnome-base/libglade-2.0
	>=gnome-base/libgnomeui-2.0
	dev-libs/libxml2
	>=mail-client/evolution-2.11
	>=gnome-extra/evolution-data-server-1.11
	>=net-libs/libsoup-2.2.96:2.2
	>=net-nds/openldap-2.1.30-r2"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35.5
	dev-util/pkgconfig
	doc? ( >=dev-util/gtk-doc-1 )"

DOCS="AUTHORS ChangeLog NEWS README"

pkg_setup() {
	G2CONF="${G2CONF} $(use_with debug e2k-debug)"

	if ! built_with_use gnome-extra/evolution-data-server ldap || ! built_with_use gnome-extra/evolution-data-server kerberos; then
		eerror "Please re-emerge gnome-extra/evolution-data-server with"
		eerror "the use flags ldap and kerberos."
		die
	fi

	G2CONF="${G2CONF} $(use_with static static-ldap) --with-openldap"
}

src_unpack() {
	gnome2_src_unpack

	# Fix bug 201824
	epatch "${FILESDIR}/${P}-fix-locks.patch"

	# Fix build with libsoup-2.4 present on the system
	epatch "${FILESDIR}/${P}-no-libsoup24.patch"
}
