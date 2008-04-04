# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/hachoir-metadata/hachoir-metadata-1.0.ebuild,v 1.2 2008/04/04 20:46:42 cedk Exp $

NEED_PYTHON=2.4

inherit distutils

DESCRIPTION="tool to extract metadata from multimedia files"
HOMEPAGE="http://hachoir.org/wiki/hachoir-metadata"
SRC_URI="http://cheeseshop.python.org/packages/source/h/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE="gnome kde"

DEPEND=""
RDEPEND=">=dev-python/hachoir-core-1.0.1
	>=dev-python/hachoir-parser-1.0
	gnome? ( gnome-base/nautilus gnome-extra/zenity )
	kde? ( kde-base/konqueror )"

PYTHON_MODNAME="hachoir_metadata"

src_install() {
	distutils_src_install

	if use gnome; then
		exeinto /usr/share/nautilus-scripts
		doexe gnome/hachoir
	fi

	if use kde; then
		exeinto /usr/bin
		doexe kde/hachoir-metadata-kde
		insinto /usr/share/apps/konqueror/servicemenus
		doins kde/hachoir.desktop
	fi
}

pkg_postinst() {
	if use gnome; then
		elog "To enable the nautilus script symlink it with:"
		elog " $ mkdir -p ~/.gnome2/nautilus-scripts"
		elog " $ ln -s /usr/share/nautilus-scripts/hachoir " \
			"~/.gnome2/nautilus-script"
	fi
}
