# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/color/color-1.1.ebuild,v 1.3 2003/10/24 20:08:12 taviso Exp $

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
}

pkg_postinst() {
	einfo "For information on using colour in your shell scripts,"
	einfo "run \`color\` without any arguments."
	einfo
	einfo "To see all the colours available, use this command"
	einfo "	$ color --list"
	einfo
	einfo "More examples are available in /usr/share/doc/${PF}."
}
