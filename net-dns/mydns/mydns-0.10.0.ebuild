# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dns/mydns/mydns-0.10.0.ebuild,v 1.1 2003/09/27 02:13:11 matsuu Exp $

DESCRIPTION="A DNS-Server which gets its data from mysql-databases"
HOMEPAGE="http://mydns.bboy.net/"
SRC_URI="http://mydns.bboy.net/download/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="nls static debug mysql postgres ssl zlib"

RDEPEND="virtual/glibc
	mysql? ( dev-db/mysql )
	postgres? ( dev-db/postgresql )
	openssl? ( dev-libs/openssl )
	zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}
	sys-devel/bison"

src_compile() {
	if [ ! "`use mysql`" -a ! "`use postgres`" ] ; then
		eerror "MyDNS needs either MySQL or PostgreSQL."
		eerror "Please set USE=\"mysql\" or USE=\"postgres\", and try again."
		die
	fi

	econf \
		`use_enable nls` \
		`use_enable debug` \
		`use_enable static static-build` \
		`use_with postgres pgsql` \
		`use_with mysql` \
		`use_with ssl openssl` \
		`use_with zlib` || die

	emake || die
}

src_install() {
	make DESTDIR=${D} install || die

	dodoc ABOUT-NLS AUTHORS BUGS ChangeLog INSTALL NEWS README TODO
	use mysql && dodoc QUICKSTART.mysql
	use postgres && dodoc QUICKSTART.postgres

	exeinto /etc/init.d; newexe ${FILESDIR}/mydns.rc6 mydns || die
}

pkg_postinst() {
	einfo
	einfo "You should now run these commands:"
	einfo
	einfo "# /usr/sbin/mydns --dump-config > /etc/mydns.conf"
	einfo "# chmod 0600 /etc/mydns.conf"
	if [ "`use mysql`" ] ; then
		einfo "# mysqladmin -u <username> -p create mydns"
		einfo "# /usr/sbin/mydns --create-tables | mysql -u <user> -p mydns"
		einfo
		einfo "to create the tables in the MySQL-Database."
		einfo "For more info see QUICKSTART.mysql."
	elif [ "`use postgres`" ] ; then
		einfo "# createdb mydns"
		einfo "# /usr/sbin/mydns --create-tables | psql mydns"
		einfo
		einfo "to create the tables in the PostgreSQL-Database."
		einfo "For more info see QUICKSTART.postgres."
	fi
	einfo

}
