# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/snort/snort-2.3.0_rc2.ebuild,v 1.1 2005/01/10 14:33:42 dragonheart Exp $

inherit eutils gnuconfig

MY_P=${P/_rc/RC}

DESCRIPTION="Libpcap-based packet sniffer/logger/lightweight IDS"
HOMEPAGE="http://www.snort.org/"
SRC_URI="http://www.snort.org/dl/${MY_P}.tar.gz
	snortsam? ( mirror://gentoo/snortsam-20050110.tar.gz )
	prelude? ( http://www.prelude-ids.org/download/releases/snort-prelude-reporting-patch-0.3.6.tar.gz )"

#	snortsam? ( http://www.snortsam.net/files/snort-plugin/snortsam-patch.tar.gz )
# Gentoo mirrored because of naming conflict with previous version

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~sparc -alpha ~amd64 ~ppc"
IUSE="ssl postgres mysql flexresp selinux snortsam odbc prelude"

S=${WORKDIR}/${MY_P}

# Local useflag snortsam: patch snort for use with snortsam package.


DEPEND="virtual/libc
	>=dev-libs/libpcre-4.2-r1
	>=net-libs/libpcap-0.7
	flexresp? ( ~net-libs/libnet-1.0.2a )
	postgres? ( >=dev-db/postgresql-7.2 )
	mysql? ( >=dev-db/mysql-3.23.26 )
	ssl? ( >=dev-libs/openssl-0.9.6b )
	prelude? ( >=dev-libs/libprelude-0.8 )
	odbc? ( dev-db/unixODBC )"

RDEPEND="${DEPEND}
	dev-lang/perl
	selinux? ( sec-policy/selinux-snort )
	snortsam? ( net-analyzer/snortsam )"

src_unpack() {
	unpack ${A}
	cd ${S}
	gnuconfig_update

	if use flexresp
	then
		epatch ${FILESDIR}/${PV}-libnet-1.0.patch || die "libnet patch failed"
	fi

	einfo "Patching /etc/snort.conf"
	sed -i "s:var RULE_PATH ../rules:var RULE_PATH /etc/snort:" etc/snort.conf

	if use prelude
	then
		epatch ../snort-2.2.0-prelude-0.3.6.diff || die "prelude patch failed"
		sed -i -e "s:AC_PROG_RANLIB:AC_PROG_LIBTOOL:" configure.in
	fi
	# need to pick up prelude and or flexresp patches
	einfo "Regenerating autoconf/automake files"
	sh ./autogen.sh

	if use snortsam
	then
		cd ..
		einfo "Applying snortsam patch"
		./patchsnort.sh ${S} || die "snortsam patch failed"
		cd ${S}
	fi
}

src_compile() {
	local myconf

	# There is no --diable-flexresp, cannot use use_enable
	use flexresp && myconf="${myconf} --enable-flexresp"

	econf \
		`use_with postgres postgresql` \
		`use_with mysql` \
		`use_with ssl openssl` \
		`use_with odbc` \
		--without-oracle \
		`use_with prelude` \
		${myconf} || die "bad ./configure"

	emake || die "compile problem"
}

pkg_preinst() {
	enewgroup snort
	enewuser snort -1 /dev/null /var/log/snort snort
	usermod -d "/var/log/snort" snort || die "usermod problem"
	usermod -g "snort" snort || die "usermod problem"
	usermod -s "/dev/null" snort || die "usermod problem"
	echo "ignore any message about CREATE_HOME above..."
}

src_install() {
	make DESTDIR=${D} install || die

	keepdir /var/log/snort/

	dodoc COPYING LICENSE doc/*
	docinto schemas ; dodoc schemas/*

	insinto /etc/snort
	doins etc/reference.config etc/classification.config rules/*.rules etc/*.map etc/threshold.conf
	newins etc/snort.conf snort.conf.distrib

	use prelude && doins etc/prelude-classification.config

	exeinto /etc/init.d ; newexe ${FILESDIR}/snort.rc6 snort
	insinto /etc/conf.d ; newins ${FILESDIR}/snort.confd snort

	chown snort:snort ${D}/var/log/snort
	chmod 0770 ${D}/var/log/snort
}

pkg_postinst() {
	if use mysql || use postgres || use odbc
	then
		einfo "To use a database as a backend for snort you will have to"
		einfo "import the correct tables to the database."
		einfo "You will have to setup a database called snort first."
		einfo ""
		use mysql && \
			einfo "  MySQL: zcat /usr/share/doc/${PF}/schema/create_mysql.gz | mysql -p snort"
		use postgres && \
			einfo "  PostgreSQL: import /usr/share/doc/${PF}/schemas/create_postgresql.gz"
		use odbc && einfo "SQL tables need to be created - look at /usr/share/doc/${PF}/schemas/"
		einfo ""
		einfo "Also, read the following Gentoo forums article:"
		einfo '   http://forums.gentoo.org/viewtopic.php?t=78718'
	fi
}
