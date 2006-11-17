# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/pinepgp/pinepgp-0.18.0.ebuild,v 1.5 2006/11/17 01:06:22 ticho Exp $

inherit eutils

DESCRIPTION="Use GPG/PGP with Pine"
HOMEPAGE="http://www.megaloman.com/~hany/software/pinepgp/"
SRC_URI="http://www.megaloman.com/~hany/_data/pinepgp/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~sparc"
IUSE=""

DEPEND="mail-client/pine app-crypt/gnupg"

src_unpack()	{
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-makefile-sed-fix.patch
}

src_compile()	{
	econf || die "configure problem"
	emake || die "compile problem"
}

src_install()	{
	exeinto /usr/bin
	dobin pinegpg pinepgpgpg-install
	dodoc ChangeLog COPYING README
}
