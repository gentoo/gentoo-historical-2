# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/teapop/teapop-0.3.7-r1.ebuild,v 1.5 2004/09/22 08:33:10 ticho Exp $

DESCRIPTION="Tiny POP3 server"
SRC_URI="ftp://ftp.toontown.org/pub/teapop/${P}.tar.gz"
HOMEPAGE="http://www.toontown.org/teapop/"
DEPEND="virtual/libc
	mysql? ( >=dev-db/mysql-3.23.51 )
	postgres? ( >=dev-db/postgresql-7.0 )
	ldap? ( >=net-nds/openldap-2.0.25 )
	tcpd? ( sys-apps/tcp-wrappers )
	java? ( virtual/jre )"
IUSE="ipv6 java ldap mysql postgres tcpd"
SLOT="0"
LICENSE="as-is"
KEYWORDS="x86 ~sparc"

src_compile() {
	local myconf
	use mysql && myconf="${myconf} --with-mysql=/usr"
	use postgres && myconf="${myconf} --with-pgsql=/usr"
	use ldap && myconf="${myconf} --with-ldap=openldap"

	econf \
		--enable-lock=flock,dotlock \
		--enable-homespool=mail \
		--enable-mailspool=/var/spool/mail \
		--enable-apop \
		$( use_enable ipv6 ) \
		$( use_with tcpd ) \
		$( use_with java ) \
		${myconf} || die "./configure failed"
	emake || die
}

src_install () {
	make DESTDIR=${D} install || die

	dodir /usr/sbin
	mv ${D}/usr/libexec/teapop ${D}/usr/sbin/

	dodoc doc/{CREDITS,ChangeLog,INSTALL,TODO}

	docinto contrib
	dodoc contrib/{README,popauther3.pl,teapop+exim.txt}
	dohtml contrib/*.html

	docinto rfc
	dodoc rfc/rfc*.txt

	exeinto /etc/init.d
	newexe ${FILESDIR}/teapop-init teapop

	insinto /etc/conf.d
	newins ${FILESDIR}/teapop-confd teapop
}
