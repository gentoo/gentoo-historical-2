# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/hddtemp/hddtemp-0.3_beta6-r1.ebuild,v 1.2 2003/07/11 18:32:49 aliz Exp $

MY_P=${P/_beta/-beta}
HDDDB_VERSION=20030609
HDDDB_FILE=hddtemp-${HDDDB_VERSION}.db
HDDDB_DIR=/usr/share/${PN}

DESCRIPTION="A simple utility to read the temperature of SMART IDE hard drives"
HOMEPAGE="http://coredump.free.fr/linux/hddtemp.php"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~ppc ~sparc"
DEPEND="virtual/glibc"

SRC_URI="http://coredump.free.fr/linux/${MY_P}.tar.gz
	mirror://gentoo/${HDDDB_FILE}.gz"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${MY_P}.tar.gz
	gunzip <${DISTDIR}/${HDDDB_FILE}.gz >${WORKDIR}/${HDDDB_FILE}
	cd ${S}
	# patch Makefile
	mv Makefile Makefile.orig
	sed -e "s:^CFLAGS.*:CFLAGS=${CFLAGS} -DARCH_I386:" \
		-e "s:^CC.*:CC=gcc:" \
		Makefile.orig > Makefile
	mv db.h db.h.orig
	sed -e "s:/etc/hddtemp.db:${HDDDB_DIR}/${HDDDB_FILE}:" \
		db.h.orig > db.h
}

src_compile() {
	emake || die
}

src_install() {
	dobin hddtemp
	insinto ${HDDDB_DIR}
	doins ${WORKDIR}/${HDDDB_FILE} 
	dodoc README TODO Changelog COPYING
}
