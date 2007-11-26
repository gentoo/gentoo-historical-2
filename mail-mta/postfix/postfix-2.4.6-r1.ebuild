# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-mta/postfix/postfix-2.4.6-r1.ebuild,v 1.1 2007/11/26 12:09:04 chtekk Exp $

# NOTE: this ebuild is a regular ebuild without mailer-config support!
# Comment lines below "regular ebuild" and uncomment lines below "mailer-config support"
# to turn this ebuild to a mailer-config enabled ebuild.

# regular ebuild
inherit eutils multilib ssl-cert toolchain-funcs flag-o-matic pam
# mailer-config support
#inherit eutils multilib ssl-cert toolchain-funcs flag-o-matic mailer pam

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"

# regular ebuild
IUSE="cdb dovecot-sasl hardened ipv6 ldap mailwrapper mbox mysql nis pam postgres sasl selinux ssl vda"
# mailer-config support
#IUSE="cdb dovecot-sasl hardened ipv6 ldap mbox mysql nis pam postgres sasl selinux ssl vda"

MY_PV="${PV/_rc/-RC}"
MY_SRC="${PN}-${MY_PV}"
MY_URI="ftp://ftp.porcupine.org/mirrors/postfix-release/official"
VDA_P="${P}-vda-ng-r2"
RC_VER="2.2.9"

DESCRIPTION="A fast and secure drop-in replacement for sendmail."
HOMEPAGE="http://www.postfix.org/"
SRC_URI="${MY_URI}/${MY_SRC}.tar.gz
	vda? ( http://gentoo.longitekk.com/${VDA_P}.patch.gz ) "

LICENSE="IPL-1"
SLOT="0"

# regular ebuild
PROVIDE="virtual/mta virtual/mda"
# mailer-config support
#PROVIDE="${PROVIDE} virtual/mda"

DEPEND=">=sys-libs/db-3.2
		>=dev-libs/libpcre-3.4
		cdb? ( || ( >=dev-db/cdb-0.75-r1 >=dev-db/tinycdb-0.76 ) )
		ldap? ( >=net-nds/openldap-1.2 )
		mysql? ( virtual/mysql )
		pam? ( virtual/pam )
		postgres? ( >=dev-db/postgresql-7.1 )
		sasl? (  >=dev-libs/cyrus-sasl-2 )
		ssl? ( >=dev-libs/openssl-0.9.6g )"

# regular ebuild
RDEPEND="${DEPEND}
		>=net-mail/mailbase-0.00
		!mailwrapper? ( !virtual/mta )
		mailwrapper? ( >=net-mail/mailwrapper-0.2 )
		selinux? ( sec-policy/selinux-postfix )"

# mailer-config support
#RDEPEND="${DEPEND}
#		>=net-mail/mailbase-0.00
#		selinux? ( sec-policy/selinux-postfix )"

S="${WORKDIR}/${MY_SRC}"

group_user_check() {
	einfo "Checking for postfix group ..."
	enewgroup postfix 207
	einfo "Checking for postdrop group ..."
	enewgroup postdrop 208
	einfo "Checking for postfix user ..."
	enewuser postfix 207 -1 /var/spool/postfix postfix,mail
}

pkg_setup() {
	# Do not upgrade live from Postfix <2.4
	if [[ -f /var/lib/init.d/started/postfix ]] ; then
		if has_version '<mail-mta/postfix-2.4.0' ; then
			if [[ "${FORCE_UPGRADE}" ]] ; then
				echo
				ewarn "You are upgrading from an incompatible version and you have"
				ewarn "FORCE_UPGRADE set, will build this package while Postfix is running."
				ewarn "You MUST stop Postfix BEFORE installing this version to your system."
				echo
			else
				echo
				eerror "You are upgrading from an incompatible version."
				eerror "You MUST stop Postfix BEFORE installing this version to your system."
				eerror "If you want minimal downtime, emerge postfix with:"
				eerror "    FORCE_UPGRADE=1 emerge --buildpkgonly postfix"
				eerror "    /etc/init.d/postfix stop"
				eerror "    emerge --usepkgonly postfix"
				eerror "Then run etc-update or dispatch-conf and merge the configuration files."
				eerror "Then restart Postfix with: /etc/init.d/postfix start"
				die "Upgrade from an incompatible version!"
				echo
			fi
		else
			echo
			ewarn "It's safe to upgrade your current version while it's running."
			ewarn "If you don't want to take any chance, please hit Ctrl+C now,"
			ewarn "stop Postfix, then emerge again."
			ewarn "You have been warned!"
			ewarn "Waiting 5 seconds before continuing ..."
			echo
			epause 5
		fi
	fi

	echo
	ewarn "Read \"ftp://ftp.porcupine.org/mirrors/postfix-release/official/${MY_SRC}.RELEASE_NOTES\""
	ewarn "for incompatible changes before continueing."
	ewarn "Bugs should be filed at \"http://bugs.gentoo.org/\" and"
	ewarn "assigned to \"net-mail@gentoo.org\"."
	echo

	# Warnings to work around bug #45764
	if has_version '<=mail-mta/postfix-2.0.18' ; then
		echo
		ewarn "You are upgrading from postfix-2.0.18 or earlier, some of the empty queue"
		ewarn "directories get deleted while unmerging the older version (see bug #45764)."
		ewarn "Please run '/etc/postfix/post-install upgrade-source' to recreate them."
		echo
	fi

	# TLS non-prod warning
	if use ssl ; then
		echo
		ewarn "You have \"ssl\" in your USE flags, TLS will be enabled."
		ewarn "This service is incompatible with the previous TLS patch."
		ewarn "Visit http://www.postfix.org/TLS_README.html for more info."
		echo
	fi

	# IPV6 non-prod warn
	if use ipv6 ; then
		echo
		ewarn "You have \"ipv6\" in your USE flags, IPV6 will be enabled."
		ewarn "Visit http://www.postfix.org/IPV6_README.html for more info."
		echo
	fi

	# SASL non-prod warning
	if use sasl ; then
		echo
		elog "Postfix 2.3 and newer supports two SASL implementations."
		elog "Cyrus SASL and Dovecot protocol version 1 (server only)"
		elog "Visit http://www.postfix.org/SASL_README.html for more info."
		echo
	fi

	# Add postfix, postdrop user/group (bug #77565)
	group_user_check || die "Failed to check/add needed user/group"
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	if use vda ; then
		epatch "${WORKDIR}/${VDA_P}.patch"
	fi

	sed -i -e "/^#define ALIAS_DB_MAP/s|hash:/etc/aliases|hash:/etc/mail/aliases|" \
		src/util/sys_defs.h || die "sed failed"

	# change default paths to better comply with portage standard paths
	sed -i -e "s:/usr/local/:/usr/:g" conf/master.cf || die "sed failed"
}

src_compile() {
	cd "${S}"

	# Added -Wl,-z,now wrt bug #62674
	# Remove -ldl as it is not necessary, solves bug #106446
	# -Wl,-z,now replaced by $(bindnow-flags)
	# make sure LDFLAGS get passed down to the executables.
	local mycc="-DHAS_PCRE" mylibs="$(bindnow-flags) ${LDFLAGS} -lpcre -lcrypt -lpthread"

	use pam && mylibs="${mylibs} -lpam"

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
		if use dovecot-sasl ; then
			# Set dovecot as default.
			mycc="${mycc} -DDEF_SASL_SERVER=\\\"dovecot\\\""
		fi
		mycc="${mycc} -DUSE_SASL_AUTH -DUSE_CYRUS_SASL -I/usr/include/sasl"
		mylibs="${mylibs} -lsasl2"
	elif use dovecot-sasl ; then
		mycc="${mycc} -DUSE_SASL_AUTH -DDEF_SERVER_SASL_TYPE=\\\"dovecot\\\""
	fi

	if ! use nis ; then
		sed -i -e "s|#define HAS_NIS|//#define HAS_NIS|g" \
			src/util/sys_defs.h || die "sed failed"
	fi

	if use cdb ; then
		mycc="${mycc} -DHAS_CDB"
		CDB_LIBS=""

		# Tinycdb is preferred.
		if has_version dev-db/tinycdb ; then
			einfo "Building with dev-db/tinycdb"
			CDB_LIBS="-lcdb"
		else
			einfo "Building with dev-db/cdb"
			CDB_PATH="/usr/$(get_libdir)"
			for i in cdb.a alloc.a buffer.a unix.a byte.a ; do
				CDB_LIBS="${CDB_LIBS} ${CDB_PATH}/${i}"
			done
		fi

		mylibs="${mylibs} ${CDB_LIBS}"
	fi

	mycc="${mycc} -DDEF_DAEMON_DIR=\\\"/usr/$(get_libdir)/postfix\\\""
	mycc="${mycc} -DDEF_MANPAGE_DIR=\\\"/usr/share/man\\\""
	mycc="${mycc} -DDEF_README_DIR=\\\"/usr/share/doc/${PF}/readme\\\""
	mycc="${mycc} -DDEF_HTML_DIR=\\\"/usr/share/doc/${PF}/html\\\""

	# Robin H. Johnson <robbat2@gentoo.org> 17/Nov/2006
	# Fix because infra boxes hit 2Gb .db files that fail a 32-bit fstat signed check.
	mycc="${mycc} -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE"
	filter-lfs-flags

	local my_cc=$(tc-getCC)
	einfo "CC=${my_cc:=gcc}"

	# Workaround for bug #76512
	[[ "$(gcc-version)" == "3.4" ]] && use hardened && replace-flags -O? -Os

	make DEBUG="" CC="${my_cc:=gcc}" OPT="${CFLAGS}" CCARGS="${mycc}" AUXLIBS="${mylibs}" \
		makefiles || die "configure problem"

	emake || die "compile problem"
}

src_install () {
	/bin/sh postfix-install \
		-non-interactive \
		install_root="${D}" \
		config_directory="/usr/share/doc/${PF}/defaults" \
		readme_directory="/usr/share/doc/${PF}/readme" \
		|| die "postfix-install failed"

	# Fix spool removal on upgrade
	rm -Rf "${D}/var"
	keepdir /var/spool/postfix

	# Install rmail for UUCP, closes bug #19127
	dobin auxiliary/rmail/rmail

	# mailwrapper stuff
	if use mailwrapper ; then
		mv "${D}/usr/sbin/sendmail" "${D}/usr/sbin/sendmail.postfix"
		mv "${D}/usr/bin/rmail" "${D}/usr/bin/rmail.postfix"
		# mailer-config support
		#rm "${D}/usr/bin/mailq" "${D}/usr/bin/newaliases"

		mv "${D}/usr/share/man/man1/sendmail.1" \
			"${D}/usr/share/man/man1/sendmail-postfix.1"
		mv "${D}/usr/share/man/man1/newaliases.1" \
			"${D}/usr/share/man/man1/newaliases-postfix.1"
		mv "${D}/usr/share/man/man1/mailq.1" \
			"${D}/usr/share/man/man1/mailq-postfix.1"
		mv "${D}/usr/share/man/man5/aliases.5" \
			"${D}/usr/share/man/man5/aliases-postfix.5"

		# regular ebuild
		insinto /etc/mail
		doins "${FILESDIR}/mailer.conf"
		# mailer-config support
		#mailer_install_conf
	else
		# Provide another link for legacy FSH
		dosym /usr/sbin/sendmail /usr/$(get_libdir)/sendmail
	fi

	# Install qshape tool
	dobin auxiliary/qshape/qshape.pl

	# Performance tuning tools and their manuals
	dosbin bin/smtp-{source,sink} bin/qmqp-{source,sink}
	doman man/man1/smtp-{source,sink}.1 man/man1/qmqp-{source,sink}.1

	# Set proper permissions on required files/directories
	fowners root:postdrop /usr/sbin/post{drop,queue}
	fperms 02711 /usr/sbin/post{drop,queue}

	keepdir /etc/postfix
	mv "${D}"/usr/share/doc/${PF}/defaults/{*.cf,post*-*} "${D}"/etc/postfix
	if use mbox ; then
		mypostconf="mail_spool_directory=/var/spool/mail"
	else
		mypostconf="home_mailbox=.maildir/"
	fi
	"${D}/usr/sbin/postconf" -c "${D}/etc/postfix" \
		-e ${mypostconf} || die "postconf failed"

	insinto /etc/postfix
	newins "${FILESDIR}/smtp.pass" saslpass
	fperms 600 /etc/postfix/saslpass

	newinitd "${FILESDIR}/postfix.rc6.${RC_VER}" postfix || die "newinitd failed"

	mv "${S}/examples" "${D}/usr/share/doc/${PF}/"
	dodoc *README COMPATIBILITY HISTORY INSTALL LICENSE PORTING RELEASE_NOTES*
	dohtml html/*

	pamd_mimic_system smtp auth account

	# Do not install server.{key,pem) SSL certificates if they already exist
	if use ssl && [[ ! -f /etc/ssl/postfix/server.key && ! -f /etc/ssl/postfix/server.pem ]] ; then
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
	# Add postfix, postdrop user/group (bug #77565)
	group_user_check || die "Failed to check/add needed user/group"

	ebegin "Fixing queue directories and permissions"
	"${ROOT}/etc/postfix/post-install" upgrade-permissions
	echo
	ewarn "If you upgraded from Postfix-1.x, you must revisit"
	ewarn "your configuration files. See"
	ewarn "  /usr/share/doc/${PF}/RELEASE_NOTES"
	ewarn "for a list of changes."

	if [[ ! -e /etc/mail/aliases.db ]] ; then
		echo
		ewarn "You must edit /etc/mail/aliases to suit your needs"
		ewarn "and then run /usr/bin/newaliases. Postfix will not"
		ewarn "work correctly without it."
	fi

	# regular ebuild
	if ! use mailwrapper && [[ -e /etc/mailer.conf ]] ; then
		einfo
		einfo "Since you emerged Postfix without mailwrapper in USE,"
		einfo "you may want to 'emerge -C mailwrapper' now."
		einfo
	fi
	# mailer-config support
	#mailer_pkg_postinst
}
