# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/glipper/glipper-1.0-r3.ebuild,v 1.2 2010/02/14 21:47:34 swegener Exp $

GCONF_DEBUG="no"

inherit gnome2 python eutils multilib

DESCRIPTION="GNOME Clipboard Manager"
HOMEPAGE="http://glipper.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-lang/python-2.4
	>=dev-python/pygobject-2.6
	>=dev-python/pygtk-2.6
	>=dev-python/gconf-python-2.22.0
	>=dev-python/libgnome-python-2.22.0
	>=dev-python/gnome-applets-python-2.22.0
	>=dev-python/gnome-vfs-python-2.22.0
	>=gnome-base/gnome-desktop-2.10"
RDEPEND="${DEPEND}"

RESTRICT="test"

DOCS="AUTHORS ChangeLog NEWS"

src_unpack() {
	gnome2_src_unpack
	cd "${S}"

	epatch "${FILESDIR}"/${P}-binary-data.patch
	epatch "${FILESDIR}"/${P}-transparent.patch
	epatch "${FILESDIR}"/${P}-pkgconfig.patch
}

src_install() {
	gnome2_src_install py_compile=true
	python_version

	# remove pointless .la files, bug #305147
	rm -f "${D}"/usr/$(get_libdir)/python${PYVER}/site-packages/glipper/{keybinder/_keybinder,osutils/_osutils}.la
}

pkg_postinst() {
	gnome2_pkg_postinst
	python_version
	python_mod_optimize /usr/$(get_libdir)/python${PYVER}/site-packages/glipper

	elog "Glipper has been completely rewritten as a panel applet. Please remove your"
	elog "existing ~/.glipper directory and then add glipper as a new panel applet."
}

pkg_postrm() {
	gnome2_pkg_postrm
	python_mod_cleanup
}
