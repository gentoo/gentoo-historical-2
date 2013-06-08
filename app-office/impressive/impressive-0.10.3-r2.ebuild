# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/impressive/impressive-0.10.3-r2.ebuild,v 1.1 2013/06/08 15:00:01 floppym Exp $

EAPI=5
PYTHON_COMPAT=( python{2_6,2_7} )

inherit eutils python-single-r1

MY_PN="Impressive"

DESCRIPTION="Stylish way of giving presentations with Python"
HOMEPAGE="http://impressive.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_PN}/${PV}/${MY_PN}-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="app-text/pdftk
	virtual/python-imaging[${PYTHON_USEDEP}]
	dev-python/pygame[${PYTHON_USEDEP}]
	dev-python/pyopengl[${PYTHON_USEDEP}]
	x11-misc/xdg-utils
	x11-apps/xrandr
	|| ( app-text/xpdf app-text/ghostscript-gpl )
	|| ( media-fonts/dejavu media-fonts/ttf-bitstream-vera media-fonts/corefonts )"

S=${WORKDIR}/${MY_PN}-${PV}

src_prepare() {
	epatch "${FILESDIR}/${PN}-pillow.patch"
}

src_install() {
	python_fix_shebang impressive.py
	dobin impressive.py

	# compatibility symlinks
	dosym impressive.py /usr/bin/impressive || die
	dosym impressive.py /usr/bin/keyjnote || die

	# docs
	doman impressive.1 || die
	dohtml impressive.html || die
	dodoc changelog.txt demo.pdf || die
}
