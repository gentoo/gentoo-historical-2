# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/pinepgp/pinepgp-0.18.0.ebuild,v 1.7 2003/07/13 13:32:32 aliz Exp $

DESCRIPTION="Use GPG/PGP with Pine"
HOMEPAGE="http://www.megaloman.com/~hany/software/pinepgp/"
SRC_URI="http://www.megaloman.com/~hany/_data/pinepgp/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~sparc "

RDEPEND="net-mail/pine"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${P}"

src_compile()	{
	econf || die "configure problem"
	emake || die "compile problem"
}

src_install()	{
	exeinto /usr/bin
	dobin pinegpg pinepgpgpg-install
	dodoc ChangeLog COPYING README
}

