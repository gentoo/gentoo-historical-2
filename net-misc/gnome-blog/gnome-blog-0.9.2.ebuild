# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/gnome-blog/gnome-blog-0.9.2.ebuild,v 1.2 2010/05/21 20:31:27 hwoarang Exp $

EAPI="2"
GCONF_DEBUG="no"

inherit gnome2 python

DESCRIPTION="Post entries to your blog right from the Gnome panel"
HOMEPAGE="http://www.gnome.org/~seth/gnome-blog/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86"
IUSE=""

RDEPEND=">=gnome-base/gconf-2
	>=dev-python/pygtk-2.6

	>=dev-python/gconf-python-2
	>=dev-python/libgnome-python-2
	>=dev-python/gnome-applets-python-2
	>=dev-python/gnome-vfs-python-2
	>=dev-python/gtkspell-python-2
	>=dev-python/gdata-2"
DEPEND="${RDEPEND}
	dev-util/desktop-file-utils
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.9"

DOCS="AUTHORS ChangeLog NEWS README TODO"

src_prepare() {
	gnome2_src_prepare

	# Let this file be re-created so the path in the <oaf_server> element is
	# correct. See bug #93612.
	rm -f GNOME_BlogApplet.server.in || die "rm failed"

	# disable pyc compiling
	mv py-compile py-compile.orig
	ln -s $(type -P true) py-compile
}

pkg_postinst() {
	gnome2_pkg_postinst
	python_mod_optimize $(python_get_sitedir)/gnomeblog
}

pkg_postrm() {
	gnome2_pkg_postrm
	python_mod_cleanup /usr/$(get_libdir)/python*/site-packages/gnomeblog
}
