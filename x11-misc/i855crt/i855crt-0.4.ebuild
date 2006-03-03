# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/i855crt/i855crt-0.4.ebuild,v 1.1 2006/03/03 10:47:48 blubb Exp $

DESCRIPTION="Intel Montara 855GM CRT out auxiliary driver"
HOMEPAGE="http://i855crt.sourceforge.net/"
SRC_URI="mirror://sourceforge/${P}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="|| ( ( x11-libs/libXext
			x11-libs/libXv
			)
		virtual/x11
		)"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd ${S}

	# upstream ships it with the binary, we want to make sure we compile it
	make clean || die "make clean failed"
}

src_compile() {
	emake
}

src_install() {
	dobin i855crt
	insinto /etc
	doins i855crt.conf
}
