# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-print/apsfilter/apsfilter-7.2.2.ebuild,v 1.1 2002/07/07 17:49:09 edolnx Exp $

DESCRIPTION="Apsfilter Prints So Fine, It Leads To Extraordinary Results"
HOMEPAGE="http://www.apsfilter.org"
LICENSE="postcard-apsfilter"

DEPEND="virtual/lpr >=app-text/ghostscript-6.53-r2
>=app-text/psutils-1.17 >=media-gfx/imagemagick-5.4.5
>=app-text/a2ps-4.13b-r4 >=sys-apps/gawk-3.1.0-r1 virtual/mta"

SRC_URI="http://www.apsfilter.org/download/${P}.tar.bz2"
S=${WORKDIR}/apsfilter

src_compile() {

	cd ${S}
	pwd

	use lpr && myconf="--with-printcap=/etc/lpr/printcap"
	use cups && myconf="--with-printcap=/etc/cups/printcap"
	use lprng && myconf="--with-printcap=/etc/lprng/printcap"
	./configure \
		--prefix=/usr \
		--mandir=/usr/share/man \
		${myconf} || die "./configure failed"

	emake || die
}

src_install () {
	make DESTDIR=${D} install || die
	dosym /usr/share/apsfilter/SETUP /usr/bin/apsfilter
}
