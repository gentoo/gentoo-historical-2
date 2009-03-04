# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/javatoolkit/javatoolkit-0.3.0-r2.ebuild,v 1.8 2009/03/04 20:40:54 betelgeuse Exp $

EAPI="2"

inherit distutils eutils multilib

DESCRIPTION="Collection of Gentoo-specific tools for Java"
HOMEPAGE="http://www.gentoo.org/proj/en/java/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND="dev-python/pyxml
		|| ( >=dev-lang/python-2.5[xml] dev-python/celementtree )"

PYTHON_MODNAME="javatoolkit"

src_install() {
	distutils_src_install --install-scripts="/usr/$(get_libdir)/${PN}/bin"
}

pkg_postrm() {
	distutils_python_version
	distutils_pkg_postrm
}

pkg_postinst() {
	distutils_pkg_postinst
}
