# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/teapop/teapop-0.3.5.ebuild,v 1.4 2003/07/13 13:32:32 aliz Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Tiny POP3 server"
SRC_URI="ftp://ftp.toontown.org/pub/teapop/${P}.tar.gz"
HOMEPAGE="http://www.toontown.org/teapop/"
DEPEND="virtual/glibc
	mysql? ( >=dev-db/mysql-3.23.51 )
	postgres? ( >=dev-db/postgresql-7.0 )
	ldap? ( >=net-nds/openldap-2.0.25 )"
IUSE="mysql postgres ldap"
SLOT="0"
LICENSE="as-is"
KEYWORDS="x86 ~sparc "

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

}
