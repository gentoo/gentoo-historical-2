# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dns/hesiod/hesiod-3.0.2-r1.ebuild,v 1.1 2003/10/20 09:47:19 lanius Exp $

inherit flag-o-matic
filter-flags -fstack-protector

DESCRIPTION="Hesiod is a system which uses existing DNS functionality to provide access to databases of information that changes infrequently."
SRC_URI="ftp://athena-dist.mit.edu/pub/ATHENA/${PN}/${P}.tar.gz"
HOMEPAGE="ftp://athena-dist.mit.edu/pub/ATHENA/hesiod"

SLOT="0"
LICENSE="ISC"
KEYWORDS="~x86 ~ppc ~sparc ~hppa"

DEPEND="virtual/glibc"

src_unpack() {
	unpack ${A}
	#Patches stolen from RH
	epatch ${FILESDIR}/hesiod-${PV}-redhat.patch.gz
	cd ${S}
	for manpage in *.3
	do
		if grep -q '^\.so man3/hesiod.3' ${manpage}
		then
			echo .so hesiod.3 > ${manpage}
		elif grep -q '^\.so man3/hesiod_getmailhost.3' ${manpage}
		then
			echo .so hesiod_getmailhost.3 > ${manpage}
		elif grep -q '^\.so man3/hesiod_getpwnam.3' ${manpage}
		then
			echo .so hesiod_getpwnam.3 > ${manpage}
		elif grep -q '^\.so man3/hesiod_getservbyname.3' ${manpage}
		then
			echo .so hesiod_getservbyname.3 > ${manpage}
		fi
	done
}

src_install () {
	make DESTDIR=${D} install || die
}
