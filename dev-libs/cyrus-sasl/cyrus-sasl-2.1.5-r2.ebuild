# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/cyrus-sasl/cyrus-sasl-2.1.5-r2.ebuild,v 1.4 2002/10/04 05:14:31 vapier Exp $

DESCRIPTION="The Cyrus SASL (Simple Authentication and Security Layer)"
HOMEPAGE="http://asg.web.cmu.edu/sasl/"

S=${WORKDIR}/${P}
SRC_URI="ftp://ftp.andrew.cmu.edu/pub/cyrus-mail/${P}.tar.gz"
LICENSE="as-is"
SLOT="0"
KEYWORDS="x86 sparc sparc64"

DEPEND="virtual/glibc
	>=sys-libs/db-3.2
	>=sys-libs/pam-0.75
	>=dev-libs/openssl-0.9.6d"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd ${WORKDIR}
	patch -p0 < ${FILESDIR}/cyrus-sasl-iovec.diff
}

src_compile() {
	./configure \
		--prefix=/usr \
		--libdir=/usr/lib \
		--mandir=/usr/share/man \
		--infodir=/usr/share/info \
		--localstatedir=/var/state/sasl2 \
		--with-configdir=/etc/sasl2 \
		--with-pwcheck=/var/lib/sasl2 \
		--with-plugindir=/usr/lib/sasl2 \
		--with-saslauthd=/var/lib/sasl2 \
		--with-dbpath=/var/lib/sasl2/sasl2.db \
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
		--host=${CHOST} \
		--build=${CHOST} \
		--target=${CHOST} \
		--with-openssl=/usr ${myconf} || die "bad ./configure"

	make || die "compile problem"
}

src_install () {
	make DESTDIR=${D} install || die "install problem"

	dodoc AUTHORS ChangeLog COPYING NEWS README doc/*.txt
	docinto examples ; dodoc sample/{*.[ch],Makefile}
	newdoc pwcheck/README README.pwcheck
	dohtml doc/*

	insinto /etc/conf.d ; newins ${FILESDIR}/saslauthd.confd saslauthd
	exeinto /etc/init.d ; newexe ${FILESDIR}/saslauthd2.rc6 saslauthd
	exeinto /etc/init.d ; newexe ${FILESDIR}/pwcheck.rc6 pwcheck
}

pkg_postinst() {
	# empty directories..
	install -d -m0755 ${ROOT}/var/lib/sasl2
	install -d -m0755 ${ROOT}/etc/sasl
}
