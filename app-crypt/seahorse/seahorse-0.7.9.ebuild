# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/seahorse/seahorse-0.7.9.ebuild,v 1.9 2005/12/14 20:06:18 dang Exp $

inherit gnome2 eutils autotools flag-o-matic

DESCRIPTION="gnome front end to gnupg"
HOMEPAGE="http://seahorse.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"

RDEPEND=">=app-crypt/gnupg-1.2.0
	>=app-crypt/gpgme-1.0.0
	>=gnome-base/libgnomeui-2
	>=gnome-base/libglade-2
	>=x11-libs/gtk+-2.4
	>=gnome-base/gnome-mime-data-2
	>=gnome-base/libbonobo-2
	>=gnome-base/libbonoboui-2
	>=gnome-base/gnome-vfs-2
	>=app-editors/gedit-2.8.0
	>=gnome-base/nautilus-2.10
	dev-util/intltool
	dev-libs/glib
	>=net-libs/libsoup-2.2
	x11-misc/shared-mime-info
	ldap? ( net-nds/openldap )"

#no ~ppc64 keyword yet 	>=gnome-base/bonobo-activation-2

DEPEND="${RDEPEND}
	>=app-text/scrollkeeper-0.3
	dev-util/pkgconfig"

DOCS="AUTHORS ChangeLog NEWS README TODO THANKS"
IUSE="ldap"

src_unpack() {

	unpack ${A}
	cd ${S}
	# Apply patch to allow seahorse-0.7.9 to compile with
	# gedit-2.12. See bug #106133, <obz@gentoo.org>
	epatch ${FILESDIR}/${P}-gedit-2.12.patch
	epatch ${FILESDIR}/${P}-gpgme-1.1.0.patch
	# Re-configure
	eautoconf

}

src_compile() {
	# autoconf
	append-ldflags $(bindnow-flags)
	G2CONF=$(use_enable ldap)
	gnome2_src_compile
}


src_install() {
	gnome2_src_install

	# remove conflicts with x11-misc/shared-mime-info
	rm -rf ${D}/usr/share/mime/application ${D}/usr/share/mime/magic ${D}/usr/share/mime/globs \
		${D}/usr/share/mime/XMLnamespaces
}
