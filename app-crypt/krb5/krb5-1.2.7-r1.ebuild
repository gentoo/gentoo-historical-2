# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/krb5/krb5-1.2.7-r1.ebuild,v 1.1 2003/03/21 17:07:26 wmertens Exp $

inherit eutils

S=${WORKDIR}/${P}/src
SRC_URI="http://www.mirrors.wiretapped.net/security/cryptography/apps/kerberos/krb5-mit/unix/${P}.tar.gz
	http://www.galiette.com/krb5/${P}.tar.gz
	http://munitions.vipul.net/software/system/auth/kerberos/${P}.tar.gz"
DESCRIPTION="MIT Kerberos V (set up for pam)"
HOMEPAGE="http://web.mit.edu/kerberos/www/"

IUSE=""
SLOT="0"
LICENSE="as-is"
KEYWORDS="~x86 ~sparc ~ppc"
PROVIDE="virtual/krb5"

DEPEND="virtual/glibc"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${PN}-1.2.2-gentoo.diff

	# Fix bad errno definitions (bug #16450 and #16267)
	ebegin Fixing errno definitions
	find . -name '*.[ch]' | xargs grep -l 'extern.*int.*errno' \
	  | xargs -n1 perl -pi.orig -e '
		$.==1 && s/^/#include <errno.h>\n/;
		s/extern\s+int\s+errno\s*\;//;'
	eend 0
}

src_compile() {
	econf \
		--with-krb4 \
		--enable-shared \
		--enable-dns || die
	make || die
}

src_install () {
	make DESTDIR=${D} install || die
	cd ..
	dodoc README

	# Begin client rename and install
	for i in {telnetd,ftpd}
	do
		mv ${D}/usr/share/man/man8/${i}.8.gz ${D}/usr/share/man/man8/k${i}.8.gz
		mv ${D}/usr/sbin/${i} ${D}/usr/sbin/k${i}
	done
	for i in {rcp,rsh,telnet,v4rcp,ftp,rlogin}
	do
		mv ${D}/usr/share/man/man1/${i}.1.gz ${D}/usr/share/man/man1/k${i}.1.gz
		mv ${D}/usr/bin/${i} ${D}/usr/bin/k${i}
	done
	
}
