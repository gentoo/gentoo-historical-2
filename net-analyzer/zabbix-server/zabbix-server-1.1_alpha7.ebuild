# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/zabbix-server/zabbix-server-1.1_alpha7.ebuild,v 1.2 2005/07/19 16:50:24 dholm Exp $

inherit eutils

MY_P=${PN//-server/}
MY_PV=${PV//_/}
DESCRIPTION="ZABBIX is software for monitoring of your applications, network and servers. Server part."

HOMEPAGE="http://zabbix.com/"
SRC_URI="mirror://sourceforge/zabbix/${MY_P}-${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64 ~ppc ~sparc ~x86"

IUSE="snmp mysql postgres"

DEPEND="snmp? ( net-analyzer/net-snmp )
	mysql? ( dev-db/mysql )
	postgres? ( dev-db/postgresql )"

# Run-time dependencies, same as DEPEND if RDEPEND isn't defined:"
RDEPEND="net-analyzer/fping"

S=${WORKDIR}/${MY_P}-${MY_PV}

pkg_setup() {
	enewgroup zabbix
	enewuser zabbix -1 /bin/false /dev/null zabbix
}

src_unpack() {
	if ( use mysql && use postgres )
	then
	eerror "You can't use both database in zabbix. Select one database"
	die "Set both database"
	fi
	if (( ! use mysql ) && ( ! use postgres ))
	then
	eerror "Selected mysql or postgresql database"
	die "No select database"
	fi
	unpack ${A}
	epatch ${FILESDIR}/${PV}/zabbix-snmpv3.fix.patch
}

src_compile() {
	local myconf=""
	if use mysql; then
		myconf="--with-mysql"
		einfo "using mysql backend"
	fi
	if use postgres; then
		myconf="--with-pgsql"
		einfo "using postgresql backend"
	fi
	if use snmp; then
		myconf="${myconf} --with-net-snmp"
		einfo "using net-snmp for snmp request"
	fi
	./configure ${myconf} || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	dodir /etc/zabbix /var/log/zabbix /var/run/zabbix /usr/share/zabbix/sripts /usr/share/zabbix/dbms
	keepdir /etc/zabbix /var/log/zabbix /var/run/zabbix
	insinto /etc/zabbix
	doins ${FILESDIR}/${PV}/zabbix_server.conf ${FILESDIR}/${PV}/zabbix_trapper.conf

	insinto /etc/conf.d
	doins ${FILESDIR}/${PV}/conf.d/zabbix-server

	exeinto /etc/init.d
	doexe ${FILESDIR}/${PV}/init.d/zabbix-server

	fowners zabbix:zabbix /etc/zabbix /var/log/zabbix /var/run/zabbix /usr/share/zabbix/sripts /usr/share/zabbix/dbms /etc/zabbix/zabbix_server.conf /etc/zabbix/zabbix_trapper.conf
	fperms 0640 /etc/zabbix/zabbix_server.conf /etc/zabbix/zabbix_trapper.conf

	dosbin bin/zabbix_server bin/zabbix_sender
	fperms 0750 /var/log/zabbix /var/run/zabbix
	dodoc README INSTALL NEWS ChangeLog
	insinto /usr/share/zabbix/dbms
	doins create/data/data.sql
	if use mysql; then
		doins create/mysql/schema.sql
	fi
	if use postgres; then
		doins create/postgresql/schema.sql
	fi
}


pkg_postinst(){
	if ( use mysql ); then
		einfo "You need configure mysql for zabbix."
		einfo "For more info read Zabbix Manual (/usr/share/doc/${P}/Zabbix Manual.pdf)"
	fi
	if ( use postgres ); then
		einfo "You need configure postgresql for zabbix."
		einfo "For more info read Zabbix Manual (/usr/share/doc/${P}/Zabbix Manual.pdf)"
	fi
}
