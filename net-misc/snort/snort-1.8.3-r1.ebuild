# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger achim@gentoo.org
# $Header: /var/cvsroot/gentoo-x86/net-misc/snort/snort-1.8.3-r1.ebuild,v 1.1 2002/02/09 00:00:40 woodchip Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Libpcap-based packet sniffer/logger/lightweight IDS"
SRC_URI="http://www.snort.org/releases/${P}.tar.gz"
HOMEPAGE="http://www.snort.org"

DEPEND="virtual/glibc >=net-libs/libpcap-0.6.2-r1
	mysql? ( >=dev-db/mysql-3.23.26 )
	ssl? ( >=dev-libs/openssl-0.9.6b )"

RDEPEND="virtual/glibc sys-devel/perl
	>=net-libs/libnet-1.0.2a
	mysql? ( >=dev-db/mysql-3.23.26 )
	ssl? ( >=dev-libs/openssl-0.9.6b )"

src_compile() {

	local myconf
	use postgres && myconf="${myconf} --with-postgresql"
	use postgres || myconf="${myconf} --without-postgresql"
	use mysql && myconf="${myconf} --with-mysql"
	use mysql || myconf="${myconf} --without-mysql"
	use ssl && myconf="${myconf} --with-openssl"
	use ssl || myconf="${myconf} --without-openssl"

	./configure \
		--prefix=/usr \
		--without-odbc \
		--without-oracle \
		--enable-pthreads \
		--enable-flexresp \
		--enable-smbalerts \
		--mandir=/usr/share/man \
		--host=${CHOST} ${myconf} || die "bad ./configure"

	emake || die "compile problem"
}

src_install () {

	make DESTDIR=${D} install || die

	dodir /var/log/snort

	insinto /usr/lib/snort/bin
	doins contrib/{create_mysql,snortlog,*.pl}

	dodoc AUTHORS BUGS COPYING CREDITS ChangeLog FAQ INSTALL LICENSE
	dodoc NEWS README* RULES.SAMPLE SnortUsersManual.pdf USAGE
	docinto contrib ; dodoc contrib/*

	insinto /etc/snort
	doins classification.config *.rules
	newins snort.conf snort.conf.distrib

	exeinto /etc/init.d ; newexe ${FILESDIR}/snort.rc6 snort
	insinto /etc/conf.d ; newins ${FILESDIR}/snort.confd snort
}

pkg_postinst() {

	if ! grep -q ^snort: /etc/group ; then
		groupadd snort || die "problem adding group snort"
	fi
	if ! grep -q ^snort: /etc/passwd ; then
		useradd -g snort -s /dev/null -d /var/log/snort -c "snort" snort
		assert "problem adding user snort"
	fi
	usermod -c "snort" snort || die "usermod problem"
	usermod -d "/var/log/snort" snort || die "usermod problem"
	usermod -g "snort" snort || die "usermod problem"
	usermod -s "/dev/null" snort || die "usermod problem"
	echo "ignore any message about CREATE_HOME above..."

	chown root.snort /var/log/snort
	chmod 0770 /var/log/snort
}
