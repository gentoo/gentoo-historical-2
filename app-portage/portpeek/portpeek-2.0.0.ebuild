# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/portpeek/portpeek-2.0.0.ebuild,v 1.2 2010/04/08 01:32:17 mpagano Exp $

EAPI="2"
PYTHON_DEPEND="3"

inherit eutils python git

DESCRIPTION="A helper program for maintaining the package.keyword and package.unmask files"
HOMEPAGE="http://www.mpagano.com/blog/?page_id=3"
SRC_URI=""

EGIT_REPO_URI="git://mpagano.com/var/git/portpeek.git"
EGIT_COMMIT="v2.0.0"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86 ~x86-fbsd"
IUSE=""

DEPEND=""
RDEPEND=">=app-portage/gentoolkit-0.3.0_rc10
	>=sys-apps/portage-2.2_rc67
	dev-lang/python:3.1"

pkg_setup() {
	python_set_active_version 3
}

src_prepare() {
	python_convert_shebangs 3 portpeek
}

src_install() {
	dobin ${PN} || die "dobin failed"
	doman *.[0-9]
}
