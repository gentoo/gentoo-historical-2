# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author: Donny Davies <woodchip@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/dev-libs/cyrus-sasl/cyrus-sasl-1.5.27.ebuild,v 1.1 2002/02/19 00:36:20 woodchip Exp $

DESCRIPTION="The Cyrus SASL (Simple Authentication and Security Layer)"
HOMEPAGE="http://asg.web.cmu.edu/cyrus/"

S=${WORKDIR}/${P}
SRC_URI="ftp://ftp.andrew.cmu.edu/pub/cyrus-mail/${P}.tar.gz"
DEPEND="virtual/glibc >=sys-libs/db-3.2 >=sys-libs/pam-0.75"

src_unpack() {
	unpack ${A} ; cd ${S}
	# some nice patches...  thanks mandrake ;-)
	patch -p1 < ${FILESDIR}/${PN}-1.5.21-des.patch || die
	patch -p1 < ${FILESDIR}/${PN}-configdir.patch || die
	patch -p1 < ${FILESDIR}/${PN}-saslauthd.patch || die
	patch -p1 < ${FILESDIR}/${PN}-1.5.24-rpath.patch || die
	patch -p0 < ${FILESDIR}/${PN}-1.5.27-scram.patch || die
	automake || die
	autoconf || die
}

src_compile() {
	./configure \
		--prefix=/usr \
		--libdir=/usr/lib \
		--mandir=/usr/share/man \
		--with-configdir=/etc/sasl \
		--with-pwcheck=/var/lib/sasl \
		--with-plugindir=/usr/lib/sasl \
		--with-saslauthd=/var/lib/sasl \
		--with-dbpath=/var/lib/sasl/sasl.db \
		--with-des \
		--with-rc4 \
		--enable-pam \
		--enable-anon \
		--enable-cram \
		--with-gnu-ld \
		--enable-scram \
		--enable-plain \
		--enable-login \
		--disable-krb4 \
		--enable-static \
		--enable-shared \
		--without-mysql \
		--enable-digest \
		--disable-gssapi \
		--disable-sample \
		--with-dblib=berkeley \
		--host=${CHOST} ${myconf} || die "bad ./configure"

	emake || die "compile problem"
}

src_install () {
	make DESTDIR=${D} install || die

	dodoc COPYING AUTHORS INSTALL NEWS README* TODO \
		ChangeLog testing.txt doc/*.txt
	docinto examples ; dodoc sample/{*.[ch],Makefile}
	newdoc pwcheck/README README.pwcheck
	dohtml doc/*

	insinto /etc/conf.d ; newins ${FILESDIR}/saslauthd.confd saslauthd
	exeinto /etc/init.d ; newexe ${FILESDIR}/saslauthd.rc6 saslauthd
	exeinto /etc/init.d ; newexe ${FILESDIR}/pwcheck.rc6 pwcheck
}

pkg_postinst() {
	# empty directories..
	install -d -m0755 ${ROOT}/var/lib/sasl
	install -d -m0755 ${ROOT}/etc/sasl
}
