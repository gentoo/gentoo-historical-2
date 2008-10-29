# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/gksu/gksu-2.0.0-r2.ebuild,v 1.1 2008/10/29 19:01:34 dang Exp $

inherit gnome2 fixheadtails eutils autotools

DESCRIPTION="A gtk+ frontend for libgksu"
HOMEPAGE="http://www.nongnu.org/gksu/"
SRC_URI="http://people.debian.org/~kov/gksu/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="doc gnome"

RDEPEND=">=x11-libs/libgksu-2
	>=x11-libs/gtk+-2.4.0
	>=gnome-base/gconf-2.0
	gnome? (
		>=gnome-base/gnome-vfs-2
		>=gnome-base/nautilus-2
		x11-terms/gnome-terminal
		)"
DEPEND="${RDEPEND}
	doc? ( dev-util/gtk-doc )"

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS README"
	G2CONF="$(use_enable doc gtk-doc) $(use_enable gnome nautilus-extension)"
	USE_DESTDIR="1"
}

src_unpack() {
	gnome2_src_unpack
	ht_fix_file "${S}/gksu-migrate-conf.sh"

	epatch "${FILESDIR}"/${P}-gnome-2.22.patch

	# Fix the nautilus extension directory. Bug #241586
	epatch "${FILESDIR}"/${P}-new-nautilus.patch

	if use gnome ; then
		sed -i 's/x-terminal-emulator/gnome-terminal/' gksu.desktop
	else
		sed -i 's/dist_desktop_DATA = $(desktop_in_files:.desktop.in=.desktop)/dist_desktop_DATA =/' Makefile.am
		sed -i 's/dist_desktop_DATA = $(desktop_in_files:.desktop.in=.desktop)/dist_desktop_DATA =/' Makefile.in
	fi

	eautoreconf
}

src_install() {
	gnome2_src_install
	chmod +x "${D}/usr/share/gksu/gksu-migrate-conf.sh"
}

pkg_postinst() {
	gnome2_pkg_postinst
	einfo 'updating configuration'
	"${ROOT}"/usr/share/gksu/gksu-migrate-conf.sh
	einfo ""
	einfo "A note on gksudo:  It actually runs sudo to get it's work done"
	einfo "However, by default, Gentoo's sudo wipes your environment."
	einfo "This means that gksudo will fail to run any X-based programs."
	einfo "You need to either add yourself to wheel and uncomment this line"
	einfo "in your /etc/sudoers:"
	einfo "Defaults:%wheel   !env_reset"
	einfo "Or remove the env_reset line entirely.  This can cause security"
	einfo "problems; if you don't trust your users, don't do this, use gksu"
	einfo "instead."
}
