# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/postfix/postfix-2.0.15.ebuild,v 1.1 2003/09/08 21:50:00 lostlogic Exp $

IUSE="ssl mysql sasl ldap ipv6 maildir mbox postgres"

inherit eutils
TLS_P="pfixtls-0.8.15-2.0.14-0.9.7b"
IPV6="1.18"
IPV6_P="ipv6-${IPV6}-pf-2.0.14"
IPV6_TLS_P="tls+ipv6-${IPV6}-pf-2.0.14"
PGSQL_P="postfix-pg.postfix-2.0.0.2"

DESCRIPTION="A fast and secure drop-in replacement for sendmail"
HOMEPAGE="http://www.postfix.org"
SRC_URI="ftp://ftp.porcupine.org/mirrors/postfix-release/official/${P}.tar.gz
	ssl? ( ftp://ftp.aet.tu-cottbus.de/pub/postfix_tls/${TLS_P}.tar.gz )
	ipv6? ( ftp://ftp.stack.nl/pub/postfix/tls+ipv6/${IPV6}/${IPV6_P}.patch.gz )
	ipv6? ( ftp://ftp.stack.nl/pub/postfix/tls+ipv6/${IPV6}/${IPV6_TLS_P}.patch.gz )"

SLOT="0"
LICENSE="IPL-1"
KEYWORDS="~x86 ~sparc ~ppc"

PROVIDE="virtual/mta
	virtual/mda"

DEPEND=">=sys-libs/db-3.2
	>=sys-apps/sed-4
	>=dev-libs/libpcre-3.4
	ldap? ( >=net-nds/openldap-1.2 )
	mysql? ( >=dev-db/mysql-3.23.51 )
	ssl? ( >=dev-libs/openssl-0.9.6g )
	sasl? ( dev-libs/cyrus-sasl )
	postgres? ( >=dev-db/postgresql-7.1 )"

RDEPEND="${DEPEND}
	>=net-mail/mailbase-0.00
	!virtual/mta"

is_postfix_installed() {
	if [ -d /etc/postfix ] ; then
		return 1
	fi

	return 0
}

pkg_setup() {
	if ! grep -q ^postdrop: /etc/group ; then
		groupadd postdrop || die "problem adding group postdrop"
	fi

	if ! grep -q ^mail:.*postfix /etc/group ; then
		usermod -G mail postfix || die "problem adding user postfix to group mail"
	fi

	# Prevent mangling the smtpd.conf file
	if [ ! -L ${ROOT}/usr/lib/sasl2/smtpd.conf ]
	then
		if [ -f ${ROOT}/usr/lib/sasl2/smtpd.conf ]
		then
			ebegin "Protecting your smtpd.conf file"
			if [ ! -d ${ROOT}/etc/sasl2 ]
			then
				mkdir -p ${ROOT}/etc/sasl2
			fi

			# This shouldn't be necessary, but apparently
			# Without it things can still get messy.
			if [ -L ${ROOT}/etc/sasl2/smtpd.conf ]
			then
				rm ${ROOT}/etc/sasl2/smtpd.conf
			fi

			# If both files exist, make sure that we
			# preserve a copy of each with the ._cfg
			# system
			if [ -f ${ROOT}/etc/sasl2/smtpd.conf ]
			then
				mv ${ROOT}/etc/sasl2/smtpd.conf \
					${ROOT}/etc/sasl2/._cfg0000_smtpd.conf
			fi
			mv ${ROOT}/usr/lib/sasl2/smtpd.conf ${ROOT}/etc/sasl2
			eend
		fi
	fi

}

src_unpack() {
	unpack ${P}.tar.gz
	cd ${S}

	if [ "`use ssl`" ]; then
		if [ "`use ipv6`" ]; then
			epatch ${DISTDIR}/${IPV6_TLS_P}.patch.gz
		else
			unpack ${TLS_P}.tar.gz
			epatch ${WORKDIR}/${P}/${TLS_P}/pfixtls.diff
		fi
		CCARGS="${CCARGS} -DHAS_SSL"
		AUXLIBS="${AUXLIBS} -lssl -lcrypto"
	elif [ "`use ipv6`" ]; then
		epatch ${DISTDIR}/${IPV6_P}.patch.gz
	fi

	if [ "`use postgres`" ]; then
		epatch ${FILESDIR}/${PGSQL_P}.patch.bz2
		CCARGS="${CCARGS} -DHAS_PGSQL -I/usr/include/postgresql"
		AUXLIBS="${AUXLIBS} -lpq"
	fi

	cd ${S}/conf
	sed -i -e "s:/usr/libexec/postfix:/usr/lib/postfix:" main.cf

	if [ "`use sasl`" ] ; then
		# sasl 2
		if [ -f /usr/include/sasl/sasl.h ]; then
			AUXLIBS="${AUXLIBS} -lsasl2"
			CCARGS="${CCARGS} -I/usr/include/sasl -DUSE_SASL_AUTH"
		# sasl 1
		elif [ -f /usr/include/sasl.h ]; then
			AUXLIBS="${AUXLIBS} -lsasl"
			CCARGS="${CCARGS} -DUSE_SASL_AUTH"
		fi
	fi

	cd ${S}/src/global
	sed -i -e "s:/usr/libexec/postfix:/usr/lib/postfix:" mail_params.h

	if [ "`use mysql`" ] ; then
		CCARGS="${CCARGS} -DHAS_MYSQL -I/usr/include/mysql"
		AUXLIBS="${AUXLIBS} -lmysqlclient -lm -lz"
	fi

	if [ "`use ldap`" ] ; then
		CCARGS="${CCARGS} -DHAS_LDAP"
		AUXLIBS="${AUXLIBS} -lldap -llber"
	fi

	if [ "`use pam`" ] ; then
		AUXLIBS="${AUXLIBS} -lpam"
	fi

	CCARGS="${CCARGS} -DHAS_PCRE"
	AUXLIBS="${AUXLIBS} -L/usr/lib -lpcre -ldl -lcrypt"

	DEBUG=""

	cd ${S}
	make makefiles CC="${CC}" OPT="${CFLAGS}" DEBUG="${DEBUG}" \
		CCARGS="${CCARGS}" AUXLIBS="${AUXLIBS}" \
		|| die "creating makefiles failed"

	# Postfix do not get the FQDN if no hostname is configured
	epatch ${FILESDIR}/${PN}-2.0.9-get-FQDN.patch
}

src_compile() {
	#this is a bug fix for gcc-2.95.3-r5 (bug 16547)
	export CC=gcc
	emake || die "compile problem"
}

src_install () {
	dodir /usr/bin /usr/sbin /usr/lib/postfix /etc/postfix/sample
	keepdir /var/spool/postfix/tmp

	cd ${S}/bin
	dosbin post* sendmail
	fowners root:postdrop /usr/sbin/{postdrop,postqueue}
	fperms 2755 /usr/sbin/{postdrop,postqueue}

	dosym /usr/sbin/sendmail /usr/bin/mailq
	dosym /usr/sbin/sendmail /usr/bin/newaliases
	dosym /usr/sbin/sendmail /usr/lib/sendmail

	cd ${S}/libexec
	exeinto /usr/lib/postfix
	doexe *

	cd ${S}/man
	doman man*/*

	cd ${S}
	dodoc *README COMPATIBILITY HISTORY INSTALL LICENSE PORTING RELEASE_NOTES*
	cd README_FILES
	find . -type l |xargs rm
	dodoc *

	cd ${S}
	dohtml html/*

	cd ${S}/conf
	insinto /etc/postfix/sample
	doins access aliases canonical pcre_table regexp_table \
		relocated transport virtual *.cf

	exeinto /etc/postfix
	doexe postfix-script post-install postfix-files

	insinto /etc/postfix
	doins ${S}/conf/{main,master}.cf ${FILESDIR}/saslpass
	cd ${D}/etc/postfix
	epatch ${FILESDIR}/postfix-2.0.14/main.cf.diff
	sed -i -e "s|/usr/share/doc/POSTFIX|/usr/share/doc/${PF}|" main.cf
	chmod 644 main.cf
	rm -f main.cf~
	fperms 600 /etc/postfix/saslpass

	exeinto /etc/init.d ; doexe ${FILESDIR}/postfix
	insinto /etc/pam.d ; newins ${FILESDIR}/smtp.pam smtp

	if [ "`use sasl`" ]; then
		insinto /etc/sasl2
		doins ${FILESDIR}/smtpd-2.0.conf smtpd.conf
		dodir /usr/lib/sasl2
		dosym ../../../etc/sasl2/smtpd.conf /usr/lib/sasl2/smtpd.conf
	fi

	cd ${D}/etc/postfix
	if [ "`use maildir`" ]; then
		sed -i -e "s:^#\(home_mailbox = \)Maildir/:\1.maildir/:" main.cf
	elif [ "`use mbox`" ]; then
		sed -i -e "s:^#\(mail_spool_directory = /var/spool/mail\):\1:" main.cf
	fi

	#install an rmail for UUCP, closing bug #19127
	cd ${S}/auxiliary/rmail
	dobin rmail

	if [ "`use postgres`" ]; then
		cd ${S}/README_FILES
		dodoc PGSQL_README
		cd ${S}
	fi
}

pkg_postinst() {
	install -d -m 0755 ${ROOT}/var/spool/postfix

	ewarn "If you upgraded from <postfix-2, you must revisit your configuration files."
	ewarn "See /usr/share/doc/${PF}/RELEASE_NOTES for a list of changes."

	if [ ! -e /etc/mail/aliases.db ] ; then
		echo
		ewarn "You must edit /etc/mail/aliases to suit your needs and then run"
		ewarn "/usr/bin/newaliases. Postfix will not work correctly without it."
	fi
}
