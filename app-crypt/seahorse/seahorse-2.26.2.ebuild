# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/seahorse/seahorse-2.26.2.ebuild,v 1.8 2010/01/17 23:28:03 jer Exp $

EAPI="2"

inherit gnome2 eutils

DESCRIPTION="A GNOME application for managing encryption keys"
HOMEPAGE="http://www.gnome.org/projects/seahorse/index.html"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="avahi debug doc ldap libnotify test"

RDEPEND=">=gnome-base/libglade-2.0
	>=gnome-base/gconf-2.0
	>=dev-libs/glib-2.10
	>=x11-libs/gtk+-2.10
	>=dev-libs/dbus-glib-0.72
	>=gnome-base/gnome-keyring-2.25.5
	net-libs/libsoup:2.4
	x11-misc/shared-mime-info

	net-misc/openssh
	>=app-crypt/gpgme-1.0.0
	|| (
		=app-crypt/gnupg-1.4*
		=app-crypt/gnupg-2.0* )

	avahi? ( >=net-dns/avahi-0.6 )
	ldap? ( net-nds/openldap )
	libnotify? ( >=x11-libs/libnotify-0.3.2 )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=app-text/gnome-doc-utils-0.3.2
	>=app-text/scrollkeeper-0.3
	>=dev-util/pkgconfig-0.20
	>=dev-util/intltool-0.35
	doc? ( >=dev-util/gtk-doc-1.9 )"

DOCS="AUTHORS ChangeLog NEWS README TODO THANKS"

pkg_setup() {
	G2CONF="${G2CONF}
		--enable-pgp
		--enable-ssh
		--enable-pkcs11
		--disable-scrollkeeper
		--disable-update-mime-database
		--enable-hkp
		$(use_enable avahi sharing)
		$(use_enable debug)
		$(use_enable ldap)
		$(use_enable libnotify)
		$(use_enable test tests)"
}

src_prepare() {
	gnome2_src_prepare

	# Fix intltoolize broken file, see upstream #577133
	sed "s:'\^\$\$lang\$\$':\^\$\$lang\$\$:g" -i po/Makefile.in.in || die "sed failed"

	# fix building with gpgme with lfs  Bug #275445
	epatch "${FILESDIR}"/${P}-gpgme-lfs.patch
}

pkg_postinst() {
	einfo "The seahorse-agent tool has been moved to app-crypt/seahorse-plugins"
	einfo "Use that if you want seahorse to manage your terminal SSH keys"
}
