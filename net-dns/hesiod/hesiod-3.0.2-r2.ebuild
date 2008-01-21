# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dns/hesiod/hesiod-3.0.2-r2.ebuild,v 1.12 2008/01/21 20:17:44 jer Exp $

inherit flag-o-matic eutils

DESCRIPTION="system which uses existing DNS functionality to provide access to databases of information that changes infrequently"
HOMEPAGE="ftp://athena-dist.mit.edu/pub/ATHENA/hesiod"
SRC_URI="ftp://athena-dist.mit.edu/pub/ATHENA/${PN}/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="alpha ~amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc ~sparc-fbsd x86 ~x86-fbsd"
IUSE=""

src_unpack() {
	unpack ${A}
	cd "${S}"

	filter-flags -fstack-protector

	#Patches stolen from RH
	epatch "${FILESDIR}"/hesiod-${PV}-redhat.patch
	autoconf || die "autoconf failed"

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

src_compile() {
	econf --sysconfdir /etc || die 'econf failed'
	emake || die 'emake failed'
}

src_install() {
	make DESTDIR="${D}" install || die
}
