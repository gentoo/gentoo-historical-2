# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-ftp/pure-ftpd/pure-ftpd-1.0.18-r1.ebuild,v 1.9 2004/07/04 17:53:12 hansmi Exp $

inherit eutils

DESCRIPTION="fast, production-quality, standard-conformant FTP server"
HOMEPAGE="http://www.pureftpd.org/"
SRC_URI="ftp://ftp.pureftpd.org/pub/pure-ftpd/releases/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="x86 ppc sparc alpha hppa ~amd64 ia64"
IUSE="pam mysql postgres ldap ssl"

DEPEND="virtual/libc
	pam? ( >=sys-libs/pam-0.75 )
	mysql? ( >=dev-db/mysql-3* )
	postgres? ( >=dev-db/postgresql-7.2.2 )
	ldap? ( >=net-nds/openldap-2.0.25 )
	ssl? ( >=dev-libs/openssl-0.9.6g )"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-fcntl.patch
}

src_compile() {
	local myconf=""

	use pam && myconf="${myconf} --with-pam"
	use ldap && myconf="${myconf} --with-ldap"
	use mysql && myconf="${myconf} --with-mysql"
	use postgres && myconf="${myconf} --with-pgsql"
	use ssl && myconf="${myconf} --with-tls"

	econf \
		--with-altlog --with-extauth \
		--with-puredb --with-cookie \
		--with-throttling --with-ratios \
		--with-quotas --with-ftpwho \
		--with-uploadscript --with-virtualhosts \
		--with-virtualchroot --with-diraliases \
		--with-peruserlimits --with-largefile \
		${myconf} || die "econf failed"

	emake || die "compile problem"
}

src_install() {
	einstall || die

	dodoc AUTHORS CONTACT ChangeLog FAQ HISTORY INSTALL README* NEWS

	use pam && cp ${FILESDIR}/ftpusers ${D}/etc/ftpusers
	use pam && insinto /etc/pam.d && doins pam/pure-ftpd

	dodir /etc/{conf.d,init.d}

	cp ${FILESDIR}/pure-ftpd.conf_d ${D}/etc/conf.d/pure-ftpd

	exeopts -m 0744
	exeinto /etc/init.d
	newexe ${FILESDIR}/pure-ftpd.rc6-r1 pure-ftpd

	insopts -m 0644
	insinto /etc/xinetd.d
	newins ${FILESDIR}/pure-ftpd.xinetd pure-ftpd

	if use ldap ; then
		dodir /etc/openldap/schema
		insinto /etc/openldap/schema
		doins pureftpd.schema
		insinto /etc/openldap
		doins pureftpd-ldap.conf
	fi
}

pkg_postinst() {
	einfo "Before starting Pure-FTPd, you have to edit the /etc/conf.d/pure-ftpd file."
	echo
	ewarn "It's *really* important to read the README provided with Pure-FTPd."
	ewarn "Check out - http://www.pureftpd.org/README"
	ewarn "And for SSL/TLS help - http://www.pureftpd.org/README.TLS"
}
