# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/grisbi/grisbi-0.5.0-r1.ebuild,v 1.3 2004/07/14 21:48:02 mr_bones_ Exp $

IUSE="print"

DESCRIPTION="Grisbi is a personnal accounting application for Linux"
HOMEPAGE="http://www.grisbi.org"
SRC_URI="mirror://sourceforge/grisbi/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

DEPEND="dev-libs/libxml2
	>=x11-libs/gtk+-2
	dev-libs/libofx"

RDEPEND="${DEPEND}
	print? ( virtual/tetex
	dev-tex/latex-unicode )"

pkg_setup() {
	if ! use print; then
		echo
		einfo
		einfo "NOTE: The USE variable 'print' is not in your USE flags."
		einfo "For printing support in grisbi, you will need to restart"
		einfo "the build with USE=\"print\""
		einfo
		echo
		for TICKER in 1 2 3 4 5; do
			echo -ne "\a" ; sleep 1
		done
	fi
}

src_unpack() {

	unpack ${A}

	# Apply location patchs
	ebegin "Applying Gentoo documention location patch"
		cd ${S}
		for i in src/Makefile.am src/Makefile.in \
			help/C/Makefile.am help/C/Makefile.in help/C/grisbi-manuel.html \
			help/fr/Makefile.am help/fr/Makefile.in help/fr/grisbi-manuel.html
		do
			sed -i "s;doc/grisbi/help;doc/${P}/help;g" ${i}
		done
	eend 0
}

src_compile() {
	econf || die "configure failed"
	emake || die
}

src_install() {
	einstall || die
	dodoc AUTHORS COPYING ChangeLog NEWS README
}

pkg_postinst() {
	pkg_setup

	einfo "The first thing you should do is set up the browser command in"
	einfo "preferences after you start up grisbi.  Otherwise you will not"
	einfo "be able to see the help and manuals"
}
