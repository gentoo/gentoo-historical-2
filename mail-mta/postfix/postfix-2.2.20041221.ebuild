# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-mta/postfix/postfix-2.2.20041221.ebuild,v 1.2 2005/01/02 21:04:26 kloeri Exp $

inherit eutils ssl-cert toolchain-funcs
IUSE="ipv6 pam ldap mysql postgres ssl sasl mailwrapper mbox nis vda"

MY_PV=${PV%.*}-${PV##*.}
PROD_PV=${MY_PV}
TLS_SRC=${PN}-${MY_PV}+tls-nonprod
PROD_SRC=${PN}-${PROD_PV}
#VDA_P="${PN}-2.1.5-trash"
#TLS_P="pfixtls-0.8.18-2.1.3-0.9.7d"
#IPV6="1.25"
#IPV6_P="ipv6-${IPV6}-pf-2.1.5"
#IPV6_TLS_P="tls+${IPV6_P}"
#PGSQL_P="postfix-pg.postfix-2.0.0.2"

DESCRIPTION="A fast and secure drop-in replacement for sendmail."
HOMEPAGE="http://www.postfix.org/"
SRC_URI="ftp://ftp.porcupine.org/mirrors/postfix-release/experimental/${PROD_SRC}.tar.gz
	ssl? ( ftp://ftp.porcupine.org/mirrors/postfix-release/experimental/${TLS_SRC}.tar.gz )"
#	vda? ( http://web.onda.com.br/nadal/postfix/VDA/${VDA_P}.patch.gz )
#	ipv6? ( ftp://ftp.stack.nl/pub/postfix/tls+ipv6/${IPV6}/${IPV6_P}.patch.gz )
#	ipv6? ( ftp://ftp.stack.nl/pub/postfix/tls+ipv6/${IPV6}/${IPV6_TLS_P}.patch.gz )"

LICENSE="IPL-1"
SLOT="0"
KEYWORDS="~x86 ~sparc ~ppc ~alpha ~amd64 ~s390 ~mips ~hppa"
#IUSE="ipv6 pam ldap mysql postgres ssl sasl vda mailwrapper mbox"

PROVIDE="virtual/mta virtual/mda"
DEPEND=">=sys-libs/db-3.2
	>=dev-libs/libpcre-3.4
	>=sys-apps/sed-4
	ldap? ( >=net-nds/openldap-1.2 )
	mysql? ( >=dev-db/mysql-3.23.51 )
	postgres? ( >=dev-db/postgresql-7.1 )
	ssl? ( >=dev-libs/openssl-0.9.6g )
	sasl? ( >=dev-libs/cyrus-sasl-2 )"
RDEPEND="${DEPEND}
	>=net-mail/mailbase-0.00
	!mailwrapper? ( !virtual/mta )
	mailwrapper? ( >=net-mail/mailwrapper-0.2 )"
if use ssl; then
	BASE_SRC=${TLS_SRC}
else
	BASE_SRC=${PROD_SRC}
fi

S=${WORKDIR}/${BASE_SRC}

pkg_setup() {
	# developmental realease warn
	echo
	ewarn "This is a experimental release. Do not use on production system."
	ewarn "Read \"ftp://ftp.porcupine.org/mirrors/postfix-release/experimental/${TLS_SRC}.RELEASE_NOTES\""
	ewarn "for incompatible changes before continue."
	ewarn "\"vda\" has been removed as it isn't available for experimetal Postfix release."
	ewarn "\"vda\" will be added as soon as it's available."
	ewarn "Bugs should be filed at \"http://bugs.gentoo.org\""
	ewarn "assign to \"net-mail@gentoo.org\"."
	einfo "Thanks for testing."
	echo
	epause 5
	# put out warnings to work around bug #45764
	if has_version '<=mail-mta/postfix-2.0.18'; then
		echo
		ewarn "You are upgrading from postfix-2.0.18 or earlier, one of the empty queue"
		ewarn "directory get deleted during unmerge the older version (#45764). Please run"
		ewarn "\`etc/postfix/post-install upgrade-source\` to recreate them."
		echo
	epause 5
	fi

	#TLS non-prod warn
	if use ssl; then
		echo
		ewarn "you have \"ssl\" in your USE flags"
		ewarn "TLS will be enabled. This is a work in progress."
		ewarn "Visit http://www.postfix.org/TLS_README.html for more info."
		ewarn "You have been warned. Thanks for testing."
		echo
	epause 5
	fi

	# VDA error
	if use vda; then
		eerror "VDA patch is not available yet for this snapshot"
		eerror "If you still want to update to this snapshot"
		eerror "please remove \"vda\" from your USE flags."
		die "VDA support is not available!"
	fi

	# logic to fix bug #53324
	if [[ $(ps h -u postfix) ]]; then
		if has_version '<mail-mta/postfix-2.1.3' ; then
			echo
			eerror "You are upgrading from the incompatible version."
			eerror "Please stop Postfix then emerge again."
			die "Upgrade from incompatible version."
		else
			echo
			ewarn "It is safe to upgrade your current version while it's running."
			ewarn "If you don't want to take any chance; please hit Ctrl+C now;"
			ewarn "stop Postfix then emerge again."
			ewarn "You have been warned!"
			ewarn "Waiting 5 seconds before continuing."
			echo
			epause 5
		fi
	fi
}

src_unpack() {
	unpack ${A} && cd "${S}"

	#if use ssl ; then
	#	if use ipv6 ; then
	#		epatch "${WORKDIR}/${IPV6_TLS_P}.patch"
	#	else
	#		epatch "${WORKDIR}/${TLS_P}/pfixtls.diff"
	#		epatch "${DISTDIR}/${PN}-${MY_PV}-tls.tar.bz2" || die "patch failed"
	#	fi
	#elif use ipv6; then
	#	epatch "${WORKDIR}/${IPV6_P}.patch"
	#fi

	#if use vda ; then
	#	epatch "${WORKDIR}/${VDA_P}.patch"
	#fi

	# We don't need this patch anymore
	# http://www.postfix.org/PGSQL_README.html
	# if use postgres ; then
	#	epatch "${DISTDIR}/${PGSQL_P}.patch"
	# fi

	# Verisign name services fixes. Do we need this anymore?
	# epatch "${WORKDIR}/${PN}-2.0-ns-mx-acl-patch"

	# Postfix does not get the FQDN if no hostname is configured.
	epatch "${FILESDIR}/${PN}-2.0.9-get-FQDN.patch" || die "patch failed."

	# Fix install paths.
	sed -e "s:/usr/libexec/postfix:/usr/lib/postfix:" \
		-i src/global/mail_params.h -i conf/main.cf || die "sed failed"
}

src_compile() {
	cd ${S}
	# added -Wl,-z,now wrt 62674.
	local mycc="-DHAS_PCRE" mylibs="-Wl,-z,now -L/usr/lib -lpcre -ldl -lcrypt -lpthread"

	if use pam ; then
		mylibs="${mylibs} -lpam"
	fi
	if use ldap ; then
		mycc="${mycc} -DHAS_LDAP"
		mylibs="${mylibs} -lldap -llber"
	fi
	if use mysql ; then
		mycc="${mycc} -DHAS_MYSQL -I/usr/include/mysql"
		mylibs="${mylibs} -lmysqlclient -lm -lz"
	fi
	if use postgres ; then
		if best_version '=dev-db/postgresql-7.3*' ; then
			mycc="${mycc} -DHAS_PGSQL -I/usr/include/postgresql"
		else
			mycc="${mycc} -DHAS_PGSQL -I/usr/include/postgresql/pgsql"
		fi
		mylibs="${mylibs} -lpq"
	fi
	if use ssl ; then
		mycc="${mycc} -DUSE_TLS"
		mylibs="${mylibs} -lssl -lcrypto"
	fi
	if use sasl ; then
		mycc="${mycc} -DUSE_SASL_AUTH -I/usr/include/sasl"
		mylibs="${mylibs} -lsasl2"
	fi

	if ! use nis; then
		sed -i -e "s|#define HAS_NIS|//#define HAS_NIS|g" src/util/sys_defs.h || \
			die "sed failed"
	fi

	mycc="${mycc} -DDEF_CONFIG_DIR=\\\"/etc/postfix\\\""
	mycc="${mycc} -DDEF_DAEMON_DIR=\\\"/usr/lib/postfix\\\""
	mycc="${mycc} -DDEF_PROGRAM_DIR=\\\"/usr/lib/postfix\\\""
	mycc="${mycc} -DDEF_MANPAGE_DIR=\\\"/usr/share/man\\\""
	mycc="${mycc} -DDEF_README_DIR=\\\"/usr/share/doc/${PF}/readme\\\""

	ebegin "Starting make makefiles..."

	local my_cc=$(tc-getCC)
	einfo "CC=${my_cc:=gcc}"

	make CC="${my_cc:=gcc}" OPT="${CFLAGS}" CCARGS="${mycc}" AUXLIBS="${mylibs}" \
		makefiles || die "configure problem"

	emake || die "compile problem"
}

src_install () {
	/bin/sh postfix-install \
		-non-interactive \
		install_root="${D}" \
		daemon_directory="/usr/lib/postfix" \
		program_directory="/usr/lib/postfix" \
		config_directory="/usr/share/doc/${PF}/defaults" \
		readme_directory="/usr/share/doc/${PF}/readme" \
		manpage_directory="/usr/share/man" \
		mail_owner="postfix" \
		setgid_group="postdrop" || die "postfix-install failed"

	# Fix spool removal on upgrade.
	rm -rf "${D}/var"
	keepdir /var/spool/postfix

	# mailwrapper stuff
	if use mailwrapper
	then
		mv "${D}/usr/sbin/sendmail" "${D}/usr/sbin/sendmail.postfix"
		insinto /etc/mail
		doins "${FILESDIR}/mailer.conf"
	fi


	# Provide another link for legacy FSH.
	dosym /usr/sbin/sendmail /usr/lib/sendmail

	# Install an rmail for UUCP, closing bug #19127.
	dobin auxiliary/rmail/rmail

	# Install qshape tool.
	dobin auxiliary/qshape/qshape.pl

	# Set proper permissions on required files/directories.
	fowners root:postdrop /usr/sbin/post{drop,queue}
	fperms 02711 /usr/sbin/post{drop,queue}

	keepdir /etc/postfix
	mv ${D}/usr/share/doc/${PF}/defaults/{*.cf,post*-*} ${D}/etc/postfix
	if use mbox
	then
		mypostconf="mail_spool_directory=/var/spool/mail"
	else
		mypostconf="home_mailbox=.maildir/"
	fi
	"${D}/usr/sbin/postconf" -c "${D}/etc/postfix" -e \
		"alias_maps=hash:/etc/mail/aliases" \
		"alias_database=hash:/etc/mail/aliases" \
		"local_destination_concurrency_limit=2" \
		"default_destination_concurrency_limit=2" \
		${mypostconf} || die "postconf failed"

	insinto /etc/postfix
	newins "${FILESDIR}/smtp.pass" saslpass
	fperms 600 /etc/postfix/saslpass

	exeinto /etc/init.d
	newexe "${FILESDIR}/postfix.rc6" postfix

	mv "${S}/examples" "${D}/usr/share/doc/${PF}/"
	dodoc *README COMPATIBILITY HISTORY INSTALL LICENSE PORTING RELEASE_NOTES*
	dohtml html/*

	if use pam ; then
		insinto /etc/pam.d
		newins "${FILESDIR}/smtp.pam" smtp
	fi
	if use ssl ; then
		SSL_ORGANIZATION="${SSL_ORGANIZATION:-Postfix SMTP Server}"
		insinto /etc/ssl/postfix
		docert server
		fowners postfix:mail /etc/ssl/postfix/server.{key,pem}
	fi
	if use sasl ; then
		insinto /etc/sasl2
		newins "${FILESDIR}/smtp.sasl" smtpd.conf
	fi
}

pkg_postinst() {
	ebegin "Fixing queue directories and permissions"
	"${ROOT}/etc/postfix/post-install" upgrade-permissions
	echo
	ewarn "If you upgraded from postfix-1.x, you must revisit"
	ewarn "your configuration files.  See"
	ewarn "  /usr/share/doc/${PF}/RELEASE_NOTES"
	ewarn "for a list of changes."

	if [ ! -e /etc/mail/aliases.db ] ; then
		echo
		ewarn "You must edit /etc/mail/aliases to suit your needs"
		ewarn "and then run /usr/bin/newaliases. Postfix will not"
		ewarn "work correctly without it."
	fi

	if ! use mailwrapper && [[ -e /etc/mailer.conf ]]
	then
		einfo
		einfo "Since you emerged $PN without mailwrapper in USE,"
		einfo "you probably want to 'emerge -C mailwrapper' now."
		einfo
	fi
}
