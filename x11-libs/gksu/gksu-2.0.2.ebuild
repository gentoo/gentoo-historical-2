# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/gksu/gksu-2.0.2.ebuild,v 1.12 2011/01/06 15:28:15 eva Exp $

EAPI="2"
GCONF_DEBUG="no"

inherit gnome2 fixheadtails

DESCRIPTION="A gtk+ frontend for libgksu"
HOMEPAGE="http://www.nongnu.org/gksu/"
SRC_URI="http://people.debian.org/~kov/gksu/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ~mips ppc ppc64 sh sparc x86 ~x86-fbsd"
IUSE="doc gnome"

RDEPEND=">=x11-libs/libgksu-2.0.8
	>=x11-libs/gtk+-2.4:2
	>=gnome-base/gconf-2
	gnome? (
		>=gnome-base/nautilus-2
		x11-terms/gnome-terminal )"
DEPEND="${RDEPEND}
	doc? ( dev-util/gtk-doc )"

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS README"
	G2CONF="${G2CONF}
		--disable-static
		$(use_enable gnome nautilus-extension)"
}

src_prepare() {
	gnome2_src_prepare

	ht_fix_file "${S}/gksu-migrate-conf.sh"

	if use gnome ; then
		sed 's/x-terminal-emulator/gnome-terminal/' \
			-i gksu.desktop || die "sed 1 failed"
	else
		sed 's/dist_desktop_DATA = $(desktop_in_files:.desktop.in=.desktop)/dist_desktop_DATA =/' \
			-i Makefile.am Makefile.in || die "sed 2 failed"
	fi
}

src_install() {
	gnome2_src_install
	chmod +x "${D}/usr/share/gksu/gksu-migrate-conf.sh"
	if use gnome; then
		find "${D}" -name "*.la" -delete || die "la file removal failed"
	fi
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
