# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Leonardo Boshell <p@kapcoweb.com>
# $Header: /var/cvsroot/gentoo-x86/app-i18n/ispell-es/ispell-es-1.7.ebuild,v 1.4 2002/05/08 06:10:57 drobbins Exp $

MY_P="espa%7Enol-"${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="A Spanish dictionary for ispell"
SRC_URI="ftp://ftp.fi.upm.es/pub/unix/${MY_P}.tar.gz"
HOMEPAGE="http://www.datsi.fi.upm.es/~coes/"

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
	dodoc LEAME README
}
