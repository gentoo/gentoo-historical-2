# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/avant-window-navigator/avant-window-navigator-0.3.2.1.ebuild,v 1.2 2009/08/08 20:17:44 jmbsvicetto Exp $

inherit gnome2 python

DESCRIPTION="Fully customisable dock-like window navigator."
HOMEPAGE="http://launchpad.net/awn"
SRC_URI="http://launchpad.net/awn/0.2/${PV}/+download/${P}.tar.gz"
LICENSE="GPL-2 LGPL-2.1"

SLOT="0"
KEYWORDS="~amd64 ~x86"
# upstream asked for gconf to be forced until optional support is fixed
IUSE="doc gnome vala xfce"

RDEPEND="
	|| (
		>=dev-lang/python-2.5
		dev-python/elementtree
	)
	dev-libs/dbus-glib
	>=dev-libs/glib-2.16.0
	dev-python/pycairo
	>=dev-python/pygtk-2
	dev-python/pyxdg
	>=gnome-base/gconf-2
	>=gnome-base/libglade-2
	>=x11-libs/gtk+-2
	>=x11-libs/libwnck-2.20
	gnome? (
		>=gnome-base/gnome-desktop-2
		>=gnome-base/gnome-vfs-2
		>=gnome-base/libgnome-2
	)
	vala? ( dev-lang/vala )
	xfce? ( xfce-base/thunar )
"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35.5
	dev-util/pkgconfig
	doc? ( >=dev-util/gtk-doc-1.4 )
"

DOCS="AUTHORS ChangeLog NEWS README TODO"

src_unpack() {
	gnome2_src_unpack

	# Disable pyc compiling.
	mv py-compile py-compile.orig
	ln -s $(type -P true) py-compile
}

src_compile() {
	local myconf

	if use gnome; then myconf="--with-desktop=gnome"
	elif use xfce; then myconf="--with-desktop=xfce4"
	else myconf="--with-desktop=agnostic"
	fi

	econf $(use_enable doc gtk-doc) \
		$(use_with vala) \
		--with-gconf \
		--disable-static \
		--disable-pymod-checks \
		${myconf}

	emake || die "emake failed"
}

pkg_postinst() {
	gnome2_pkg_postinst

	ewarn
	ewarn "AWN will be of no use if you do not have a compositing manager."

	python_version
	python_mod_optimize /usr/$(get_libdir)/python${PYVER}/site-packages/awn
}

pkg_postrm() {
	gnome2_pkg_postrm
	python_mod_cleanup /usr/$(get_libdir)/python*/site-packages/awn
}
