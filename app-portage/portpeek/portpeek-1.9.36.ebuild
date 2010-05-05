# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/portpeek/portpeek-1.9.36.ebuild,v 1.6 2010/05/05 17:07:11 mpagano Exp $

EAPI="2"
PYTHON_DEPEND="2"

inherit eutils python git

DESCRIPTION="A helper program for maintaining the package.keyword and package.unmask files"
HOMEPAGE="http://www.mpagano.com/blog/?page_id=3"
SRC_URI=""

EGIT_REPO_URI="git://mpagano.com/var/git/portpeek.git"
EGIT_BRANCH="1.9.36"
EGIT_COMMIT="1.9.36"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~sparc ~x86 ~x86-fbsd"
IUSE=""

DEPEND=""
RDEPEND="=app-portage/gentoolkit-0.3.0_rc9
	>=sys-apps/portage-2.2_rc67
	dev-lang/python:2.6"

pkg_setup() {
	python_set_active_version 2
}

src_prepare() {
	python_convert_shebangs 2 portpeek
}

src_install() {
	dobin ${PN} || die "dobin failed"
	doman *.[0-9]
}
