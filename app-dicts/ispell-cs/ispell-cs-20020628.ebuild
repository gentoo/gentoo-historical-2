# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/ispell-cs/ispell-cs-20020628.ebuild,v 1.12 2005/01/01 12:53:00 eradicator Exp $

MY_P=${PN/cs/czech}
S=${WORKDIR}/${MY_P}
DESCRIPTION="The Czech dictionary for ispell"
SRC_URI="ftp://ftp.vslib.cz/pub/unix/ispell/${MY_P}-${PV}.tar.gz"
HOMEPAGE="ftp://ftp.vslib.cz/pub/unix/ispell/"

SLOT="0"
LICENSE="GPL-2"
IUSE=""
KEYWORDS="ppc x86 sparc alpha mips hppa"

DEPEND="dev-lang/perl
	app-text/ispell"

src_compile() {
	make all || die
}

src_install () {
	insinto /usr/lib/ispell
	doins czech.aff czech.hash
	dodoc README
}
