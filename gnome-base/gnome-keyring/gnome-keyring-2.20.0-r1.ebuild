# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome-keyring/gnome-keyring-2.20.0-r1.ebuild,v 1.3 2007/10/07 21:47:01 remi Exp $

inherit gnome2 eutils autotools pam

DESCRIPTION="Password and keyring managing daemon"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="doc hal pam test"

RDEPEND=">=dev-libs/glib-2.6
		>=x11-libs/gtk+-2.6
		>=sys-apps/dbus-1.0
		hal? ( >=sys-apps/hal-0.5.7 )
		pam? ( sys-libs/pam )
		>=dev-libs/libgcrypt-1.2.2"
DEPEND="${RDEPEND}
		sys-devel/gettext
		>=dev-util/intltool-0.35
		>=dev-util/pkgconfig-0.9
		doc? ( dev-util/gtk-doc )"

DOCS="AUTHORS ChangeLog NEWS README TODO"

src_unpack() {
	gnome2_src_unpack

	# Fix tests
	echo "gkr-ask-tool.c" >> "${S}/po/POTFILES.in"

	epatch "${FILESDIR}/${P}-fix_pam.patch"
	use doc || epatch "${FILESDIR}/${P}-fix_gtk_doc.patch"
	eautoreconf
}

pkg_setup() {
	G2CONF="$(use_enable hal) \
		$(use_enable test tests) \
		$(use_enable pam) \
		$(use_with pam pam-dir $(getpam_mod_dir))"
}
