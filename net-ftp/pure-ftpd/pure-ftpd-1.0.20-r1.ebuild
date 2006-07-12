# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-ftp/pure-ftpd/pure-ftpd-1.0.20-r1.ebuild,v 1.11 2006/07/12 15:16:24 kugelfang Exp $

inherit eutils

DESCRIPTION="fast, production-quality, standard-conformant FTP server"
HOMEPAGE="http://www.pureftpd.org/"
SRC_URI="ftp://ftp.pureftpd.org/pub/pure-ftpd/releases/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86"
IUSE="pam mysql postgres ldap ssl caps vchroot selinux"

DEPEND="virtual/libc
	pam? ( >=sys-libs/pam-0.75 )
	mysql? ( >=dev-db/mysql-3 )
	postgres? ( >=dev-db/postgresql-7.2.2 )
	ldap? ( >=net-nds/openldap-2.0.25 )
	ssl? ( >=dev-libs/openssl-0.9.6g )"

RDEPEND="${DEPEND}
	selinux? ( sec-policy/selinux-ftpd )"

src_compile() {
	local myconf="--with-privsep"

	use pam && myconf="${myconf} --with-pam"
	use ldap && myconf="${myconf} --with-ldap"
	use mysql && myconf="${myconf} --with-mysql"
	use postgres && myconf="${myconf} --with-pgsql"
	use ssl && myconf="${myconf} --with-tls"
	use caps && myconf="${myconf} --with-capabilities"
	!(use caps) && myconf="${myconf} --without-capabilities"
	use vchroot && myconf="${myconf} --with-virtualchroot"
	#!(use vchroot) && myconf="${myconf} --without-virtualchroot"

	# adjust max user length to something more appropriate
	# for virtual hosts.  See bug #62472 for details.
	sed -e "s:# define MAX_USER_LENGTH 32U:# define MAX_USER_LENGTH 127U:" -i ${S}/src/ftpd.h

	econf \
		--with-altlog --with-extauth \
		--with-puredb --with-cookie \
		--with-throttling --with-ratios \
		--with-quotas --with-ftpwho \
		--with-uploadscript --with-virtualhosts \
		--with-diraliases --with-peruserlimits \
		--with-largefile \
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
