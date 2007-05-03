# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/gksu/gksu-2.0.0.ebuild,v 1.17 2007/05/03 17:29:27 dang Exp $

inherit gnome2 fixheadtails

DESCRIPTION="A gtk+ frontend for libgksu"
HOMEPAGE="http://www.nongnu.org/gksu/"
SRC_URI="http://people.debian.org/~kov/gksu/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sh sparc x86 ~x86-fbsd"
IUSE="doc gnome"

RDEPEND=">=x11-libs/libgksu-2
	>=x11-libs/gtk+-2.4.0
	>=gnome-base/gconf-2.0
	gnome? ( >=gnome-base/nautilus-2 )"
DEPEND="${RDEPEND}
	doc? ( dev-util/gtk-doc )"


DOCS="AUTHORS ChangeLog NEWS README"
G2CONF="$(use_enable doc gtk-doc) $(use_enable gnome nautilus-extension)"
USE_DESTDIR="1"

src_unpack() {
	gnome2_src_unpack
	ht_fix_file "${S}/gksu-migrate-conf.sh"
}

src_install() {
	gnome2_src_install
	chmod +x "${D}/usr/share/gksu/gksu-migrate-conf.sh"
}

pkg_postinst() {
	gnome2_pkg_postinst
	einfo 'updating configuration'
	"${ROOT}"/usr/share/gksu/gksu-migrate-conf.sh
}
