# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/net-nds/openldap/openldap-2.0.25-r3.ebuild,v 1.1 2002/09/22 00:34:32 g2boojum Exp $

S=${WORKDIR}/${P}
DESCRIPTION="LDAP suite of application and development tools"
SRC_URI="ftp://ftp.OpenLDAP.org/pub/OpenLDAP/openldap-release/${P}.tgz"
HOMEPAGE="http://www.OpenLDAP.org/"

SLOT="0"
KEYWORDS="x86 ppc"
LICENSE="OPENLDAP"

DEPEND="virtual/glibc
	>=sys-libs/ncurses-5.1
	tcpd?	  ( >=sys-apps/tcp-wrappers-7.6 )
	ssl?	  ( >=dev-libs/openssl-0.9.6 )
	readline? ( >=sys-libs/readline-4.1 )
	sasl?     ( >=dev-libs/cyrus-sasl-1.5.27 )
	berkdb? ( >=sys-libs/db-3.2.9 )
	gdbm?   ( >=sys-libs/gdbm-1.8.0 )"

RDEPEND="virtual/glibc
	>=sys-libs/ncurses-5.1
	gdbm? ( >=sys-libs/gdbm-1.8.0 )"

src_compile() {
	local myconf

	use tcpd \
		&& myconf="${myconf} --enable-wrappers" \
		|| myconf="${myconf} --disable-wrappers"

	use ssl \
		&& myconf="${myconf} --with-tls" \
		|| myconf="${myconf} --without-tls"

	use readline \
		&& myconf="${myconf} --with-readline" \
		|| myconf="${myconf} --without-readline"

	if use berkdb; then
		myconf="${myconf} --enable-ldbm --with-ldbm-api=berkeley"
	elif use gdbm; then
		myconf="${myconf} --enable-ldbm --with-ldbm-api=gdbm"
	elif use ldap-none; then
		myconf="${myconf} --disable-ldbm"
	else
		myconf="${myconf} --enable-ldbm --with-ldbmi-api=auto"
	fi
	use ipv6 && myconf="${myconf} --enable-ipv6" \
		|| myconf="${myconf} --disable-ipv6"
	use sasl && myconf="${myconf} --enable-cyrus-sasl" \
		|| myconf="${myconf} --disable-cyrus-sasl"


	econf \
		--enable-passwd \
		--enable-shell \
		--enable-shared \
		--enable-static \
		--localstatedir=/var/state/openldap \
		--libexecdir=/usr/lib/openldap \
		--sysconfdir=/etc \
		${myconf} || die "bad configure"

	make depend || die
	make || die
	cd tests ; make || die
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"

	dodoc ANNOUNCEMENT CHANGES COPYRIGHT README LICENSE
	docinto rfc ; dodoc doc/rfc/*.txt

	exeinto /etc/init.d
	newexe ${FILESDIR}/slapd.rc6 slapd
	newexe ${FILESDIR}/slurpd.rc6 slurpd
}
