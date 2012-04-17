# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/smart-live-rebuild/smart-live-rebuild-1.2.2.ebuild,v 1.1 2012/04/17 15:58:50 mgorny Exp $

EAPI=4

PYTHON_DEPEND='2:2.6'
SUPPORT_PYTHON_ABIS=1
RESTRICT_PYTHON_ABIS='2.4 2.5 3.*'
DISTUTILS_SRC_TEST=setup.py

inherit base distutils

DESCRIPTION="Check live packages for updates and emerge them as necessary"
HOMEPAGE="https://bitbucket.org/mgorny/smart-live-rebuild/"
SRC_URI="mirror://bitbucket/mgorny/${PN}/downloads/${P}.tar.bz2"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~mips ~x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=app-portage/gentoopm-0.2.1
	!sys-apps/portage[python3]"

PYTHON_MODNAME=smartliverebuild

src_prepare() {
	base_src_prepare
	distutils_src_prepare
}

src_install() {
	distutils_src_install

	insinto /etc/portage
	newins smart-live-rebuild.conf{.example,}
	insinto /usr/share/portage/config/sets
	newins sets.conf.example ${PN}.conf
}
