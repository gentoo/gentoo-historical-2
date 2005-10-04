# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/freeradius/freeradius-1.0.4.ebuild,v 1.3 2005/10/04 18:37:57 mrness Exp $

inherit eutils

DESCRIPTION="highly configurable free RADIUS server"
SRC_URI="ftp://ftp.freeradius.org/pub/radius/${P}.tar.gz"
HOMEPAGE="http://www.freeradius.org/"

KEYWORDS="~x86 ~amd64 ~ppc ~sparc"
LICENSE="GPL-2"
SLOT="0"
IUSE="edirectory frascend frnothreads frxp kerberos ldap mysql pam postgres snmp ssl udpfromto"

DEPEND="!net-dialup/cistronradius
	!net-dialup/gnuradius
	virtual/libc
	>=sys-libs/db-3.2
	sys-libs/gdbm
	snmp? ( net-analyzer/net-snmp )
	mysql? ( dev-db/mysql )
	postgres? ( dev-db/postgresql )
	pam? ( sys-libs/pam )
	ssl? ( dev-libs/openssl )
	ldap? ( net-nds/openldap )
	kerberos? ( virtual/krb5 )
	frxp? ( dev-lang/python
		dev-lang/perl )"

pkg_setup() {
	if use edirectory && ! use ldap ; then
		eerror "Cannot add integration with Novell's eDirectory without having LDAP support!"
		eerror "Either you select ldap USE flag or remove edirectory"
		die
	fi
	enewgroup radiusd
	enewuser radiusd -1 -1 /var/log/radius radiusd
}

src_unpack() {
	unpack ${P}.tar.gz
	cd ${S}

	epatch ${FILESDIR}/${P}-whole-archive-gentoo.patch

	export WANT_AUTOCONF=2.1
	autoconf
}

src_compile() {
	local myconf=" \
		`use_with snmp` \
		`use_with frascend ascend-binary` \
		`use_with frxp experimental-modules` \
		`use_with udpfromto` \
		`use_with edirectory edir` "

	if useq frnothreads; then
		myconf="${myconf} --without-threads"
	fi
	#fix bug #77613
	if has_version app-crypt/heimdal; then
		myconf="${myconf} --enable-heimdal-krb5"
	fi

	# kill modules we don't use
	if ! use ssl; then
		einfo "removing rlm_eap_tls and rlm_x99_token (no use ssl)"
		rm -rf src/modules/rlm_eap/types/rlm_eap_tls src/modules/rlm_x99_token
	fi
	if ! use ldap; then
		einfo "removing rlm_ldap (no use ldap)"
		rm -rf src/modules/rlm_ldap
	fi
	if ! use kerberos; then
		einfo "removing rlm_krb5 (no use kerberos)"
		rm -rf src/modules/rlm_krb5
	fi
	if ! use pam; then
		einfo "removing rlm_pam (no use pam)"
		rm -rf src/modules/rlm_pam
	fi

	./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var \
		--mandir=/usr/share/man \
		--with-large-files --disable-ltdl-install --disable-static \
		${myconf} || die

	make || die
}

src_install() {
	dodir /etc
	dodir /var/log
	dodir /var/run
	pkg_preinst
	diropts -m0750 -o root -g radiusd
	dodir /etc/raddb
	diropts -m0750 -o radiusd -g radiusd
	dodir /var/log/radius
	dodir /var/log/radius/radacct
	dodir /var/run/radiusd
	diropts

	make R=${D} install || die
	dosed 's:^#user *= *nobody:user = radiusd:;s:^#group *= *nobody:group = radiusd:' \
	    /etc/raddb/radiusd.conf
	chown -R root:radiusd ${D}/etc/raddb/*

	[ -z "${PR}" ] || mv ${D}/usr/share/doc/${P} ${D}/usr/share/doc/${PF}
	gzip -f -9 ${D}/usr/share/doc/${PF}/{rfc/*.txt,*}
	#Copy SQL schemas to doc dir
	docinto sql.schemas
	dodoc src/modules/rlm_sql/drivers/rlm_sql_*/*.sql

	rm ${D}/usr/sbin/rc.radiusd

	exeinto /etc/init.d
	newexe ${FILESDIR}/radius.init radiusd

	insinto /etc/conf.d
	newins ${FILESDIR}/radius.conf radiusd
}

pkg_preinst() {
	enewgroup radiusd
	enewuser radiusd -1 -1 /var/log/radius radiusd
}

pkg_prerm() {
	if [ -n "`${ROOT}/etc/init.d/radiusd status | grep start`" ]; then
		${ROOT}/etc/init.d/radiusd stop
	fi
}

pkg_postrm() {
	if has_version ">${CATEGORY}/${PF}" || has_version "<${CATEGORY}/${PF}" ; then
		ewarn "If radiusd service was running, it had been stopped!"
		echo
		ewarn "You should update the configuration files using etc-update"
		ewarn "and start the radiusd service again by running:"
		einfo "    /etc/init.d/radiusd start"

		ebeep
	fi
}
