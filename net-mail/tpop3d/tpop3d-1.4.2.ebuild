# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/tpop3d/tpop3d-1.4.2.ebuild,v 1.16 2005/02/16 16:45:36 slarti Exp $

inherit eutils

DESCRIPTION="An extensible POP3 server with vmail-sql/MySQL support."
HOMEPAGE="http://www.ex-parrot.com/~chris/tpop3d/"
SRC_URI="http://www.ex-parrot.com/~chris/tpop3d/${P}.tar.gz
	http://www.ex-parrot.com/~chris/tpop3d/${P}-auth-flatfile-broken.patch"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE="ssl ldap mysql perl pam tcpd maildir debug"

DEPEND="virtual/libc
	ssl?	( >=dev-libs/openssl-0.9.6 )
	ldap? 	( >=net-nds/openldap-2.0.7 )
	mysql? 	( >=dev-db/mysql-3.23.28 )
	perl?	( >=dev-lang/perl-5.6.1 )
	pam?	( >=sys-libs/pam-0.75 )
	tcpd?	( >=sys-apps/tcp-wrappers-7.6 )"

src_unpack() {
	unpack ${P}.tar.gz
	cd ${S}
	epatch ${DISTDIR}/${P}-auth-flatfile-broken.patch
}

src_compile() {
	local myconf
	use mysql		&& myconf="--enable-auth-mysql"
	use ldap		&& myconf="${myconf} --enable-auth-ldap"
	use perl		&& myconf="${myconf} --enable-auth-perl"
	use tcpd		&& myconf="${myconf} --enable-tcp-wrappers"
	use pam			|| myconf="${myconf} --disable-auth-pam"
	use maildir		&& myconf="${myconf} --enable-mbox-maildir"
	use ssl			&& myconf="${myconf} --enable-tls"
	# If you want plaintext /etc/passwd authentication
	if [ ! -z $ENABLE_PASSWD ]; then
		myconf="${myconf} --enable-auth-passwd"
	fi
	# If you want to use /etc/shadow instead.
	# Make sure you also set $ENABLE_PASSWD
	if [ ! -z $ENABLE_SHADOW ]; then
		myconf="${myconf} --enable-shadow-passwords"
	fi
	# authenticate against any passwd-like file
	if [ ! -z $ENABLE_FLATFILE ]; then
		myconf="${myconf} --enable-auth-flatfile"
	fi
	# authenticate via an external program
	if [ ! -z $ENABLE_OTHER ]; then
		myconf="${myconf} --enable-auth-other"
	fi
	# Make it Rated G and safe for the kids
	if [ ! -z $BE_NICE ]; then
		myconf="${myconf} --disable-snide-comments"
	fi
	# Install mail-client/drac for integration with tpop3d
	if [ ! -a $ENABLE_DRAC ]; then
		myconf="${myconf} --enable-drac"
	fi
	if use debug; then
		myconf="${myconf} --enable-electric-fence --enable-backtrace"
	fi
	econf ${myconf} || die "./configure failed"

	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodir /etc/tpop3d

	exeinto /etc/init.d
	newexe ${FILESDIR}/tpop3d-init tpop3d

}

pkg_postinst() {
	einfo "Read the tpop3d.conf manpage"
	einfo "Please create /etc/tpop3d/tpop3d.conf to fit your Configuration"
}
