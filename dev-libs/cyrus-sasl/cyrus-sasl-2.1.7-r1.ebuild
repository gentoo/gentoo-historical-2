# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/dev-libs/cyrus-sasl/cyrus-sasl-2.1.7-r1.ebuild,v 1.1 2002/08/22 17:58:14 raker Exp $

S=${WORKDIR}/${P}

DESCRIPTION="The Cyrus SASL (Simple Authentication and Security Layer)"
HOMEPAGE="http://asg.web.cmu.edu/sasl/"
SRC_URI="ftp://ftp.andrew.cmu.edu/pub/cyrus-mail/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="x86 -ppc -sparc -sparc64"

DEPEND="virtual/glibc
	>=sys-libs/db-3.2
	>=sys-libs/pam-0.75
	>=dev-libs/openssl-0.9.6d
	cyrus-gdbm? ( >=sys-libs/gdbm-1.8.0 )
	cyrus-berkdb? ( >=sys-libs/db-3.2.9 )
	cyrus-ldap? ( >=net-nds/openldap-2.0.25 )
	cyrus-mysql? ( >=dev-db/mysql-3.23.51 )"
RDEPEND="${DEPEND}"

src_unpack() {

	unpack ${A}
	cd ${S}
	patch -p1 < ${FILESDIR}/cyrus-sasl-iovec.diff || die
	patch -p1 < ${FILESDIR}/crypt.diff || die

}

src_compile() {

	local myconf

	use sasl-ldap && myconf="${myconf} --with-ldap" \
		|| myconf="${myconf} --without-ldap"

	use sasl-mysql && myconf="${myconf} --with-mysql" \
		|| myconf="${myconf} --without-mysql"

	if use cyrus-berkdb; then
		myconf="${myconf} --with-dblib=berkeley"
	elif use cyrus-gdbm; then
		myconf="${myconf} --with-dblib=gdbm --with-gdbm=/usr"
	else
		myconf="${myconf} --with-dblib=berkeley"
	fi

	use sasl-anon && myconf="${myconf} --enable-anon" \
		|| myconf="${myconf} --disable-anon"

	use sasl-login && myconf="${myconf} --enable-login" \
		|| myconf="${myconf} --disable-login"

	use sasl-scram && myconf="${myconf} --enable-scram" \
		|| myconf="${myconf} --disable-scram"

	use sasl-plain && myconf="${myconf} --enable-plain" \
		|| myconf="${myconf} --disable-plain"

	use sasl-krb4 && myconf="${myconf} --enable-krb4" \
		|| myconf="${myconf} --disable-krb4"

	use sasl-gssapi && myconf="${myconf} --enable-gssapi" \
		|| myconf="${myconf} --disable-gssapi"

	use sasl-opie && myconf="${myconf} --enable-opie" \
		|| myconf="${myconf} --disable-opie"

	use static && myconf="${myconf} --enable-static --with-staticsasl" \
		|| myconf="${myconf} --disable-static --without-staticsasl"

	econf \
		--with-saslauthd=/var/lib/sasl2 \
		--with-pwcheck=/var/lib/sasl2 \
		--with-configdir=/etc/sasl2 \
		--with-openssl=/usr \
		--with-plugindir=/usr/lib/sasl2 \
		--with-dbpath=/etc/sasl2/sasldb2 \
		--with-des \
		--with-rc4 \
		--enable-pam \
		--enable-login \
		--with-gnu-ld \
		--enable-shared \
		--disable-sample \
		--enable-cram \
		--enable-digest \
		${myconf} || die "bad ./configure"

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
	install -d -m0755 ${ROOT}/etc/sasl2
}
