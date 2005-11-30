# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/color/color-1.1.ebuild,v 1.1 2003/10/24 19:34:27 taviso Exp $

inherit ccc

DESCRIPTION="Easily add ANSI colouring to shell scripts"
HOMEPAGE="http://runslinux.net/projects.html#color"

SRC_URI="http://runslinux.net/projects/color/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~x86 ~alpha"
IUSE=""
DEPEND="virtual/glibc"

S=${WORKDIR}/${P}

src_unpack() {
	unpack ${A}

	# replace hardcoded compiler and CFLAGS.
	replace-cc-hardcode
	sed -i "s/-W -Wall -O2 -g/${CFLAGS}/g" ${S}/Makefile
}

src_compile() {
	emake || die

	# some feedback everything went ok.
	echo; ls -l color; size color
}

src_install() {
	dobin color
	dodoc CHANGELOG COPYING README

	# symlink for british users.
	dosym /usr/bin/color /usr/bin/colour

	einfo "For information on using color in your shell scripts,"
	einfo "run \`color\` without any arguments."
	einfo
	einfo "More examples are available in ${DOCDIR}."
}
