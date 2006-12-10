# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/pessulus/pessulus-2.16.1.ebuild,v 1.3 2006/12/10 19:42:48 ticho Exp $

inherit gnome2 python

DESCRIPTION="lockdown editor for GNOME"
HOMEPAGE="http://live.gnome.org/Pessulus"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~sparc x86"
IUSE="doc"

RDEPEND=">=dev-python/pygtk-2.6.0
	>=dev-python/gnome-python-2.6.0
	>=gnome-base/gconf-2"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.35
	doc? ( >=dev-util/gtk-doc-1 )"

DOCS="AUTHORS ChangeLog HACKING MAINTAINERS NEWS README TODO"

pkg_postinst() {
	python_version
	python_mod_optimize ${ROOT}/usr/$(get_libdir)/python${PYVER}/site-packages/Pessulus
}

pkg_postrm() {
	python_version
	python_mod_cleanup
}
