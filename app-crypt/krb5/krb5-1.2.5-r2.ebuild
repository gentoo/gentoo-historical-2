# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/krb5/krb5-1.2.5-r2.ebuild,v 1.5 2002/12/09 04:17:37 manson Exp $

SRC_URI="http://www.crypto-publish.org/dist/mit-kerberos5/${P}.tar.gz"
DESCRIPTION="MIT Kerberos V (set up for pam)"
HOMEPAGE="http://web.mit.edu/kerberos/www/"

SLOT="0"
LICENSE="as-is"
KEYWORDS="x86 sparc "

S=${WORKDIR}/${P}/src

src_compile() {
	patch -p0 < ${FILESDIR}/${PN}-1.2.2-gentoo.diff || die

	cd ${S}/lib/rpc
	patch -p0 < ${FILESDIR}/${P}-r2.patch || die
	cd ${S}

	econf \
		--with-krb4 \
		--enable-shared \
		--enable-dns

	mv Makefile Makefile.orig
	#Don't install the ftp, telnet, r* apps; use pam instead
	sed -e 's/ appl / /' Makefile.orig > Makefile
	make || die
}

src_install() {
	make DESTDIR=${D} install || die
	cd ..
	dodoc README
}

pkg_postinst() {
	ewarn 'NOTE: ftp, telnet, r* apps not installed.  Install pam-krb5!'
}
