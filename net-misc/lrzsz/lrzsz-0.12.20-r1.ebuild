# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/lrzsz/lrzsz-0.12.20-r1.ebuild,v 1.21 2005/01/06 19:09:31 vapier Exp $

inherit flag-o-matic

DESCRIPTION="Communication package providing the X, Y, and ZMODEM file transfer protocols"
HOMEPAGE="http://www.ohse.de/uwe/software/lrzsz.html"
SRC_URI="http://www.ohse.de/uwe/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc sparc x86"
IUSE="nls"

DEPEND=""

src_unpack() {
	unpack ${A}
	epatch ${FILESDIR}/${PN}-makefile-smp.patch
}

src_compile() {
	append-flags -Wstrict-prototypes
	econf $(use_enable nls) || die
	emake || die "emake failed"
}

src_install() {
	make \
		prefix="${D}/usr" \
		mandir="${D}/usr/share/man" \
		install || die

	local x
	for x in {r,s}{b,x,z} ; do
		dosym l${x} /usr/bin/${x}
	done

	dodoc AUTHORS COMPATABILITY ChangeLog NEWS README* THANKS TODO
}
