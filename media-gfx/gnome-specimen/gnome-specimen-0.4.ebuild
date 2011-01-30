# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/gnome-specimen/gnome-specimen-0.4.ebuild,v 1.3 2011/01/30 07:54:17 ssuominen Exp $

EAPI=3

GCONF_DEBUG=no
PYTHON_DEPEND="2:2.6"

inherit gnome2 python

DESCRIPTION="Font preview application"
HOMEPAGE="http://uwstopia.nl"
SRC_URI="http://uwstopia.nl/geek/projects/${PN}/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/gconf-python
	dev-python/libgnome-python
	dev-python/pygtk
	dev-python/pygobject"
DEPEND="${RDEPEND}
	dev-util/intltool
	dev-util/pkgconfig
	sys-devel/gettext"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	rm -f py-compile
	ln -s $(type -P true) py-compile
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README TODO

	python_convert_shebangs 2 "${D}"/usr/bin/${PN}
}

pkg_postinst() {
	python_mod_optimize specimen
	gnome2_pkg_postinst
}

pkg_postrm() {
	python_mod_cleanup specimen
	gnome2_pkg_postrm
}
