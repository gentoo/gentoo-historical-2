# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/ispell-es/ispell-es-1.7.ebuild,v 1.5 2004/03/14 00:50:17 mr_bones_ Exp $

MY_P="espanol-"${PV}
S=${WORKDIR}/${MY_P/n/~n}
DESCRIPTION="A Spanish dictionary for ispell"
SRC_URI="ftp://ftp.fi.upm.es/pub/unix/${MY_P}.tar.gz"
HOMEPAGE="http://www.datsi.fi.upm.es/~coes/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="ppc x86 sparc alpha mips hppa"

DEPEND="app-text/ispell"

src_compile() {
	# It's important that we export the TMPDIR environment variable,
	# so we don't commit sandbox violations
	export TMPDIR=/tmp
	emake || die
	unset TMPDIR
}

src_install () {
	insinto /usr/lib/ispell
	doins espa~nol.aff espa~nol.hash
	fperms 444 /usr/lib/ispell/espa~nol.*
	dodoc LEAME README
}
