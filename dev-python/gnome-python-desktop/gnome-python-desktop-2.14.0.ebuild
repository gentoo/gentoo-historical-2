# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/gnome-python-desktop/gnome-python-desktop-2.14.0.ebuild,v 1.18 2006/08/19 00:54:50 kloeri Exp $

inherit distutils gnome2 python virtualx

DESCRIPTION="provides python interfacing modules for some GNOME desktop
libraries"
HOMEPAGE="http://pygtk.org/"

LICENSE="LGPL-2.1 GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 hppa ~ia64 ppc ppc64 sparc x86"

RDEPEND="virtual/python
	>=dev-python/pygtk-2.4.0
	>=dev-libs/glib-2.6.0
	>=x11-libs/gtk+-2.4.0
	>=dev-python/gnome-python-2.10.0
	>=gnome-base/gnome-panel-2.13.4
	>=gnome-base/libgnomeprint-2.2.0
	>=gnome-base/libgnomeprintui-2.2.0
	>=x11-libs/gtksourceview-1.1.90
	>=x11-libs/libwnck-2.9.92
	>=gnome-base/libgtop-2.13.0
	>=gnome-extra/nautilus-cd-burner-2.11.1
	>=gnome-extra/gnome-media-2.10.0
	>=gnome-base/gconf-2.10.0
	>=x11-wm/metacity-2.13.13
	media-video/totem
	!<dev-python/gnome-python-extras-2.13"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.7"

DOCS="AUTHORS COPYING* ChangeLog INSTALL MAINTAINERS NEWS README"

src_test() {
	Xmake check || die "tests failed"
}

src_install() {
	gnome2_src_install

	if use doc; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}

pkg_postinst() {
	python_version
	python_mod_optimize ${ROOT}/usr/$(get_libdir)/python${PYVER}/site-packages/gtk-2.0
}

pkg_postrm() {
	python_version
	python_mod_cleanup
}
