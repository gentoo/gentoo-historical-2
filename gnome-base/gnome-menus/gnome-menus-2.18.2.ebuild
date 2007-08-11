# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome-menus/gnome-menus-2.18.2.ebuild,v 1.7 2007/08/11 15:01:04 ticho Exp $

inherit eutils gnome2 python multilib

DESCRIPTION="The GNOME menu system, implementing the F.D.O cross-desktop spec"
HOMEPAGE="http://www.gnome.org"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~hppa ia64 ppc ~ppc64 ~sh sparc x86 ~x86-fbsd"
IUSE="debug python kernel_linux"

RDEPEND=">=dev-libs/glib-2.6
	python? (
				>=dev-lang/python-2.2
				dev-python/pygtk
			)"
DEPEND="${RDEPEND}
	  sys-devel/gettext
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.35"

DOCS="AUTHORS ChangeLog HACKING NEWS README"

pkg_setup() {
	G2CONF="$(use_enable kernel_linux inotify) $(use_enable debug) $(use_enable python)"
}

pkg_postinst() {
	gnome2_pkg_postinst
	use python && python_mod_optimize "${ROOT}"usr/$(get_libdir)/python*/site-packages
}

pkg_postrm() {
	gnome2_pkg_postrm
	use python && python_mod_cleanup "${ROOT}"usr/$(get_libdir)/python*/site-packages
}
