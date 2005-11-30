# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/dictd-vera/dictd-vera-1.12.ebuild,v 1.1 2004/03/06 12:02:43 liquidx Exp $

pkg_dte="December 2003"

DESCRIPTION="V.E.R.A. -- Virtual Entity of Relevant Acronyms for dict"
HOMEPAGE="http://home.snafu.de/ohei/vera/vueber-e.html"
SRC_URI="http://home.snafu.de/ohei/FTP/vera-${PV}.tar.gz
	mirror://debian/pool/main/v/vera/vera_${PV}-1.diff.gz"

IUSE=""
SLOT="0"
LICENSE="FDL-1.1"
KEYWORDS="~x86 ~ppc ~sparc ~amd64"

RDEPEND=">=app-text/dictd-1.5.5"

S=${WORKDIR}/vera-${PV}

src_unpack () {
	unpack ${A}
	cd ${S}
	patch -p1 < ${WORKDIR}/vera_${PV}-1.diff
}

src_compile () {
	sed -f debian/dict-vera/sedfile vera.? >vera1 || die
	sed '1,2!s/^/   /' vera. > vera || die
	cat vera1>>vera || die
	/usr/bin/dictfmt -f -u http://home.snafu.de/ohei \
	    -s "V.E.R.A. -- Virtual Entity of Relevant Acronyms (${pkg_dte})" \
	   vera   <vera || die
	/usr/bin/dictzip -v vera.dict || die
}

src_install () {
	dodir /usr/lib/dict
	insinto /usr/lib/dict
	doins vera.dict.dz
	doins vera.index
	dodoc debian/README debian/ChangeLog debian/GFDL
}
