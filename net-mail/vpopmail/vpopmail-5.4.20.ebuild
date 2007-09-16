# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/vpopmail/vpopmail-5.4.20.ebuild,v 1.1 2007/09/16 08:16:28 hollow Exp $

inherit eutils fixheadtails autotools

HOMEPAGE="http://www.inter7.com/index.php?page=vpopmail"
DESCRIPTION="A collection of programs to manage virtual email domains and accounts on your Qmail mail servers."
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~s390 ~sh ~sparc ~x86"
IUSE="clearpasswd ipalias maildrop mysql"

DEPEND="virtual/qmail
	maildrop? ( mail-filter/maildrop )
	mysql? ( virtual/mysql )
"

# This makes sure the variable is set, and that it isn't null.
VPOP_DEFAULT_HOME="/var/vpopmail"

# qmail home directory
QMAIL_HOME="/var/qmail"

vpopmail_set_homedir() {
	VPOP_HOME=$(getent passwd vpopmail | cut -d: -f6)
	if [[ -z "${VPOP_HOME}" ]]; then
		ebeep
		eerror "vpopmail's home directory is null in passwd data!"
		eerror "You probably want to check that out."
		eerror "Continuing with default."
		VPOP_HOME="${VPOP_DEFAULT_HOME}"
	else
		einfo "Setting VPOP_HOME to: $VPOP_HOME"
	fi
}

pkg_setup() {
	enewgroup vpopmail 89
	enewuser vpopmail 89 -1 ${VPOP_DEFAULT_HOME} vpopmail
	upgradewarning
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${PN}-5.4.9-access.violation.patch
	epatch "${FILESDIR}"/${PN}-lazy.patch

	# fix maildir paths
	sed -i -e 's|Maildir|.maildir|g' \
		vchkpw.c vconvert.c vdelivermail.c \
		vpopbull.c vpopmail.c vqmaillocal.c \
		vuserinfo.c maildirquota.c || die

	# remove vpopmail advertisement
	sed -i -e '/printf.*vpopmail/s:vpopmail (:(:' \
		vdelivermail.c vpopbull.c vqmaillocal.c || die

	eautoreconf
	ht_fix_file "${S}"/cdb/Makefile || die "failed to fix file"
}

src_compile() {
	vpopmail_set_homedir

	if use mysql; then
		authopts=" \
			--enable-auth-module=mysql \
			--enable-libs=/usr/include/mysql \
			--enable-libdir=/usr/lib/mysql \
			--enable-sql-logging \
			--enable-valias \
			--disable-mysql-replication \
			--enable-mysql-limits"
	else
		authopts="--enable-auth-module=cdb"
	fi

	econf ${authopts} \
		--sysconfdir=${VPOP_HOME}/etc \
		--enable-non-root-build \
		--enable-qmaildir=${QMAIL_HOME} \
		--enable-qmail-newu=${QMAIL_HOME}/bin/qmail-newu \
		--enable-qmail-inject=${QMAIL_HOME}/bin/qmail-inject \
		--enable-qmail-newmrh=${QMAIL_HOME}/bin/qmail-newmrh \
		--enable-vpopuser=vpopmail \
		--enable-vpopgroup=vpopmail \
		--enable-many-domains \
		--enable-file-locking \
		--enable-file-sync \
		--enable-md5-passwords \
		--enable-logging \
		--enable-auth-logging \
		--enable-log-name=vpopmail \
		--enable-qmail-ext \
		--disable-tcp-rules-prog \
		--disable-tcpserver-file \
		--disable-roaming-users \
		$(use_enable ipalias ip-alias-domains) \
		$(use_enable clearpasswd clear-passwd) \
		$(use_enable maildrop) \
		|| die "configure failed"

	emake || die "make failed"
}

src_install() {
	vpopmail_set_homedir

	make DESTDIR="${D}" install || die "make install failed"
	keepdir "${VPOP_HOME}"/domains

	# install helper script for maildir conversion
	into /var/vpopmail
	dobin "${FILESDIR}"/vpopmail-Maildir-dotmaildir-fix.sh
	into /usr

	# install documentation
	dodoc AUTHORS ChangeLog FAQ INSTALL README*
	dohtml doc/doc_html/* doc/man_html/*
	rm -rf "${D}"/"${VPOP_HOME}"/doc
	dosym /usr/share/doc/${PF}/ "${VPOP_HOME}"/doc

	# create /etc/vpopmail.conf
	if use mysql; then
		einfo "Installing vpopmail mysql configuration file"
		dodir /etc
		# config file position
		mv "${D}"/var/vpopmail/etc/vpopmail.mysql "${D}"/etc/vpopmail.conf
		dosym /etc/vpopmail.conf /var/vpopmail/etc/vpopmail.mysql
		sed -e '12d' -i "${D}"/etc/vpopmail.conf
		echo '# Read-only DB' >> "${D}"/etc/vpopmail.conf
		echo 'localhost|0|vpopmail|secret|vpopmail' >> "${D}"/etc/vpopmail.conf
		echo '# Write DB' >>${D}/etc/vpopmail.conf
		echo 'localhost|0|vpopmail|secret|vpopmail' >> "${D}"/etc/vpopmail.conf
		# lock down perms
		fperms 640 /etc/vpopmail.conf
		fowners root:vpopmail /etc/vpopmail.conf
	fi

	einfo "Installing env.d entry"
	dodir /etc/env.d
	doenvd "${FILESDIR}"/99vpopmail

	einfo "Locking down vpopmail permissions"
	fowners root:0 -R "${VPOP_HOME}"/{bin,etc,include}
	fowners root:vpopmail "${VPOP_HOME}"/bin/vchkpw
	fperms 4711 "${VPOP_HOME}"/bin/vchkpw
}

pkg_postinst() {
	einfo "Performing post-installation routines for ${P}"

	if use mysql ; then
		elog
		elog "You have 'mysql' turned on in your USE"
		elog "Vpopmail needs a VALID MySQL USER. Let's call it 'vpopmail'"
		elog "You MUST add it and then specify its passwd in the /etc/vpopmail.conf file"
		elog
		elog "First log into mysql as your mysql root user and pass. Then:"
		elog "> create database vpopmail;"
		elog "> use mysql;"
		elog "> grant select, insert, update, delete, create, drop on vpopmail.* to"
		elog "	 vpopmail@localhost identified by 'your password';"
		elog "> flush privileges;"
		elog
		elog "If you have problems with vpopmail not accepting mail properly,"
		elog "please ensure that /etc/vpopmail.conf is chmod 640 and"
		elog "owned by root:vpopmail"
	fi

	# do this for good measure
	if [ -e /etc/vpopmail.conf ] ; then
		chmod 640 /etc/vpopmail.conf
		chown root:vpopmail /etc/vpopmail.conf
	fi

	upgradewarning
}

pkg_postrm() {
	vpopmail_set_homedir

	elog "The vpopmail DATA will NOT be removed automatically."
	elog "You can delete them manually by removing the ${VPOP_HOME} directory."
}

upgradewarning() {
	ewarn "Massive important warning if you are upgrading to 5.2.1-r8 or older"
	ewarn "The internal structure of the mail storage has changed for"
	ewarn "consistancy with the rest of Gentoo! Please review and utilize the "
	ewarn "script at /var/vpopmail/bin/vpopmail-Maildir-dotmaildir-fix.sh"
	ewarn "to upgrade your system! (It can do conversions both ways)."
	ewarn "You should be able to run it right away without any changes."
	elog
	elog "Use of vpopmail's tcp.smtp[.cdb] is also deprecated now, consider"
	elog "using net-mail/relay-ctrl instead."

	if use mysql; then
		elog
		elog "If you are upgrading from 5.4.17 or older, you have to fix your"
		elog "MySQL tables:"
		elog
		elog 'ALTER TABLE `dir_control` CHANGE `domain` `domain` CHAR(96) NOT NULL;'
		elog 'ALTER TABLE `ip_alias_map` CHANGE domain domain CHAR(96) NOT NULL;'
		elog 'ALTER TABLE `lastauth` CHANGE domain domain CHAR(96) NOT NULL;'
		elog 'ALTER TABLE `valias` CHANGE domain domain CHAR(96) NOT NULL;'
		elog 'ALTER TABLE `vlog` CHANGE domain domain CHAR(96) NOT NULL;'
		elog 'ALTER TABLE `vpopmail` CHANGE domain domain CHAR(96) NOT NULL;'
		elog 'ALTER TABLE `limits` CHANGE domain domain CHAR(96) NOT NULL,'
		elog '    ADD `disable_spamassassin` TINYINT(1) DEFAULT '0' NOT NULL AFTER `disable_smtp`,'
		elog '    ADD `delete_spam` TINYINT(1) DEFAULT '0' NOT NULL AFTER `disable_spamassassin`;'
	fi
}
