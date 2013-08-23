# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/portpeek/portpeek-2.1.9.ebuild,v 1.3 2013/08/23 11:06:08 pinkbyte Exp $

EAPI="5"
PYTHON_COMPAT=( python{2_7,3_2} )

inherit python-single-r1

DESCRIPTION="A helper program for maintaining the package.keyword and package.unmask files"
HOMEPAGE="http://www.mpagano.com/blog/?page_id=3"
SRC_URI="http://www.mpagano.com/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ~ppc ~sparc x86 ~x86-fbsd"
IUSE=""

DEPEND=""
RDEPEND=">=app-portage/gentoolkit-0.3.0.7
	>=sys-apps/portage-2.1.11.52"

src_install() {
	dobin ${PN} || die "dobin failed"
	doman *.[0-9]
}
