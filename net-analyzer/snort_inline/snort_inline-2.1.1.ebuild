# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/snort_inline/snort_inline-2.1.1.ebuild,v 1.5 2004/07/05 12:20:02 eldad Exp $

inherit eutils

DESCRIPTION="Intrusion Prevention System (IPS) based on Snort"
HOMEPAGE="http://snort-inline.sf.net/"
SRC_URI="mirror://sourceforge/snort-inline/${P}.tgz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="ssl postgres mysql"
DEPEND="virtual/libc
	>=dev-libs/libpcre-4.2-r1
	>=net-libs/libpcap-0.6.2-r1
	>=net-firewall/iptables-1.2.7a-r4
	<net-libs/libnet-1.1
	>=net-libs/libnet-1.0.2a-r3
	postgres? ( >=dev-db/postgresql-7.2 )
	mysql? ( >=dev-db/mysql-3.23.26 )
	ssl? ( >=dev-libs/openssl-0.9.6b )"

RDEPEND="virtual/libc
	>=dev-libs/libpcre-4.2-r1
	dev-lang/perl
	net-firewall/iptables
	net-firewall/ebtables
	>=net-libs/libpcap-0.6.2-r1
	<net-libs/libnet-1.1
	>=net-libs/libnet-1.0.2a-r3
	postgres? ( >=dev-db/postgresql-7.2 )
	mysql? ( >=dev-db/mysql-3.23.26 )
	ssl? ( >=dev-libs/openssl-0.9.6b )"

S=${WORKDIR}/${P}

src_unpack() {
	unpack ${A}
	cd ${S}

	epatch ${FILESDIR}/${PV}-libnet-1.0.patch
	epatch ${FILESDIR}/${P}-gcc3.patch
	epatch ${FILESDIR}/snort-drop-calculation.diff

	sed -i -e "s:^var RULE_PATH.*:var RULE_PATH /etc/snort_inline/rules:" \
		-e "s:\$RULE_PATH/classification.config:classification.config:" \
		-e "s:\$RULE_PATH/reference.config:reference.config:" \
		etc/snort_inline.conf
}

src_compile() {
	local myconf

	if [ -r /usr/include/libipq/libipq.h ]; then
		myconf="${myconf} --with-libipq-includes=/usr/include/libipq/"
	fi

	econf 	${myconf} \
		`use_with postgres postgresql` \
		`use_with mysql` \
		`use_with ssl openssl` \
		--without-odbc \
		--without-oracle || die "configure failed"

	emake || die "make failed"
}

src_install() {
	make DESTDIR=${D} install || die

	dodir /var/log/snort_inline
	keepdir /var/log/snort_inline/

	insinto /usr/lib/snort_inline/bin
	doins contrib/{create_mysql,snortlog,*.pl}

	dodoc COPYING LICENSE doc/*
	docinto contrib ; dodoc contrib/*

	newman snort.8 snort_inline.8
	rm ${D}/usr/share/man/man8/snort.8

	insinto /etc/snort_inline
	doins etc/reference.config etc/classification.config etc/*.map etc/threshold.conf
	newins etc/snort_inline.conf snort_inline.conf.distrib

	insinto /etc/snort_inline/rules
	doins rules/*.rules

	exeinto /etc/init.d ; newexe ${FILESDIR}/snort_inline.initd snort_inline
	insinto /etc/conf.d ; newins ${FILESDIR}/snort_inline.confd snort_inline
}

pkg_postinst() {
	enewgroup snort_inline
	enewuser snort_inline -1 /dev/null /var/log/snort_inline snort_inline
	usermod -d "/var/log/snort_inline" snort_inline || die "usermod problem"
	usermod -g "snort_inline" snort_inline || die "usermod problem"
	usermod -s "/dev/null" snort_inline || die "usermod problem"
	echo "ignore any message about CREATE_HOME above..."

	chown snort_inline:snort_inline /var/log/snort_inline
	chmod 0770 /var/log/snort_inline

	einfo "snort_inline requires a kernel with ebtables support. 2.6.x"
	einfo "kernels have this built-in, while 2.4.x kernels needs to be"
	einfo "patched. ebtables can be found at http://ebtables.sf.net"
}
