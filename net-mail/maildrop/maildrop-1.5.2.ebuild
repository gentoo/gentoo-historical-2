# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/maildrop/maildrop-1.5.2.ebuild,v 1.1 2003/02/15 03:47:56 raker Exp $

inherit flag-o-matic
filter-flags -funroll-loops
filter-flags -fomit-frame-pointer

IUSE="mysql ldap gdbm berkdb"
S=${WORKDIR}/${P}
DESCRIPTION="Mail delivery agent/filter"
SRC_URI="mirror://sourceforge/courier/${P}.tar.bz2"
HOMEPAGE="http://www.flounder.net/~mrsam/maildrop/index.html"
DEPEND="sys-devel/perl
	virtual/mta
	berkdb? ( >=sys-libs/db-3.2 )
	gdbm? ( >=sys-libs/gdbm-1.8.0 )
	mysql? ( >=dev-db/mysql-3.23.51 )
	ldap? ( >=net-nds/openldap-2.0.23 )"
PROVIDE="virtual/mda"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~sparc"

src_compile() {
	local myconf
	use mysql && myconf="${myconf} --enable-maildropmysql --with-mysqlconfig=/etc/maildrop/maildropmysql.cf" \
		|| myconf="${myconf} --disable-maildropmysql"
	use ldap && myconf="${myconf} --enable-maildropldap --with-ldapconfig=/etc/maildrop/maildropldap.cf" \
		|| myconf="${myconf} --disable-maildropldap"
	if use berkdb; then
		myconf="${myconf} --with-db=db"
        elif use gdbm; then
		myconf="${myconf} --with-db=gdbm"	
	fi

	econf \
		--with-devel \
		--enable-userdb \
		--disable-tempdir \
		--enable-syslog=1 \
		--enable-use-flock=1 \
		--enable-maildirquota \
		--enable-use-dotlock=1 \
		--enable-restrict-trusted=1 \
		--enable-trusted-users='root mail daemon postmaster qmaild mmdf vmail' \
		--with-default-maildrop=./.maildir/ \
		--enable-sendmail=/usr/sbin/sendmail \
		${myconf}

	emake || die "compile problem"
}

src_install() {
	local i
	make DESTDIR=${D} install || die

	dodoc AUTHORS COPYING ChangeLog INSTALL NEWS README \
		README.postfix UPGRADE maildroptips.txt
	mv ${D}/usr/share/maildrop/html ${D}/usr/share/doc/${PF}
	dohtml {INSTALL,README,UPGRADE}.html

	# this just cleans up /usr/share/maildrop a little bit..
	for i in makedat makeuserdb pw2userdb userdb userdbpw vchkpw2userdb
	do
		rm -f ${D}/usr/bin/$i
		mv -f ${D}/usr/share/maildrop/scripts/$i \
			${D}/usr/share/maildrop
		dosym /usr/share/maildrop/$i /usr/bin/$i
	done
	rm -rf ${D}/usr/share/maildrop/scripts

	insinto /etc/maildrop
	doins ${FILESDIR}/maildroprc
	
	if [ -n "`use mysql`" ]
	then
		cp ${S}/maildropmysql.config ${S}/maildropmysql.cf
		sed -e "s:/var/lib/mysql/mysql.sock:/var/run/mysqld/mysqld.sock:" \
		 	${S}/maildropmysql.config > ${S}/maildropmysql.cf
		newins ${S}/maildropmysql.cf maildropmysql.cf
	fi
	use ldap && newins ${S}/maildropldap.config maildropldap.cf
}
