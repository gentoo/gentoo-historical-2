# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-embedded/avr-binutils/avr-binutils-2.14.ebuild,v 1.4 2004/06/24 22:05:37 agriffis Exp $

IUSE="nls"

MY_P=${P/avr-/}
S=${WORKDIR}/${MY_P}
DESCRIPTION="The GNU binutils for the AVR microcontroller architecture"
HOMEPAGE="http://sources.redhat.com/binutils"
SRC_URI="http://ftp.gnu.org/gnu/binutils/${MY_P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

DEPEND="virtual/glibc"

src_compile() {
	econf \
		--target=avr \
		`use_enable nls` || die
	emake || die
}

src_install() {
	einstall || die
}
