# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/vpopmail/vpopmail-5.2.2.ebuild,v 1.7 2004/08/04 09:49:12 tomk Exp $

IUSE="mysql ipalias clearpasswd"

inherit eutils gnuconfig

# TODO: all ldap, sybase support
HOMEPAGE="http://www.inter7.com/index.php?page=vpopmail"
DESCRIPTION="A collection of programs to manage virtual email domains and accounts on your Qmail or Postfix mail servers."
SRC_URI="http://www.inter7.com/${PN}/${P}.tar.gz
	mysql? ( http://gentoo.twobit.net/misc/${PN}-5.2.1-mysql.diff )"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~sparc"
DEPEND_COMMON="mail-mta/qmail
	mysql? ( >=dev-db/mysql-3.23* )"
DEPEND="sys-apps/sed
		sys-apps/ucspi-tcp
		${DEPEND_COMMON}"
RDEPEND="${DEPEND_COMMON}
	 	 virtual/cron"

# Define vpopmail home dir in /etc/password if different
VPOP_DEFAULT_HOME="/var/vpopmail"
VPOP_HOME="$VPOP_DEFAULT_HOME"

# This makes sure the variable is set, and that it isn't null.
vpopmail_set_homedir() {
	VPOP_HOME=`getent passwd vpopmail | cut -d: -f6`
	if [ -z "$VPOP_HOME" ]; then
		echo -ne "\a"
		eerror "vpopmail's home directory is null in passwd data!"
		eerror "You probably want to check that out."
		eerror "Continuing with default."
		sleep 1; echo -ne "\a"; sleep 1; echo -ne "\a"
		VPOP_HOME="${VPOP_DEFAULT_HOME}"
	else
		einfo "Setting VPOP_HOME to: $VPOP_HOME"
	fi
}

pkg_setup() {
	if [ -z `getent group vpopmail` ]; then
		(groupadd -g 89 vpopmail 2>/dev/null || groupadd vpopmail ) || die "problem adding vpopmail group"
	fi
	if [ -z `getent passwd vpopmail` ]; then
		useradd -g vpopmail -u 89 -d ${VPOP_DEFAULT_HOME} -c "vpopmail_directory" -s /bin/false -m vpopmail || \
		useradd -g vpopmail -u `getent group vpopmail | awk -F":" '{ print $3 }'` -d ${VPOP_DEFAULT_HOME} -c "vpopmail_directory" \
		-s /bin/false -m vpopmail || die "problem adding vpopmail user"
	fi
	upgradewarning
}

src_unpack() {
	cd ${WORKDIR}
	unpack ${P}.tar.gz
	cd ${S}

	epatch ${FILESDIR}/vpopmail-5.2.1-showall.patch

	if use mysql; then
		einfo "Applying MySQL patch..."
		# Thanks to Nicholas Jones (carpaski@gentoo.org)
		epatch ${DISTDIR}/vpopmail-5.2.1-mysql.diff
	fi

	for i in vchkpw.c vconvert.c vdelivermail.c vpopbull.c vpopmail.c vqmaillocal.c vuserinfo.c; do
		sed -e 's|Maildir|.maildir|g' -i $i || die "Failed to change s/Maildir/.maildir/g in $i"
	done

	gnuconfig_update

	# the configure script tries to force root and make directories not using ${D}
	cp configure configure.orig
	#sed -e '1282,1289d' -e '1560,1567d' -e '2349d' -e '2107d' -e '2342d' configure > configure.new
	sed -e '1304,1311d' -e '1582,1589d' -e '2129d' -e '2364d' -e '2371d' -i configure
}

src_compile() {
	vpopmail_set_homedir

	use ipalias && myopts="${myopts} --enable-ip-alias-domains=y" \
		|| myopts="${myopts} --enable-ip-alias-domains=n"

	use mysql && myopts="${myopts} --enable-mysql=y \
			--enable-libs=/usr/include/mysql \
			--enable-sqllibdir=/usr/lib/mysql \
			--enable-mysql-logging=y \
			--enable-auth-logging=y \
			--enable-valias=y \
			--enable-mysql-replication=n" \
		|| myopts="${myopts} --enable-mysql=n"

	# Bug 20127
	use clearpasswd &&
		myopts="${myopts} --enable-clear-passwd=y" ||
		myopts="${myopts} --enable-clear-passwd=n"

	addpredict /var/vpopmail/etc/lib_deps
	addpredict /var/vpopmail/etc/inc_deps

	econf ${myopts} --sbindir=/usr/sbin \
		--bindir=/usr/bin \
		--sysconfdir=${VPOP_HOME}/etc \
		--enable-qmaildir=/var/qmail \
		--enable-qmail-newu=/var/qmail/bin/qmail-newu \
		--enable-qmail-inject=/var/qmail/bin/qmail-inject \
		--enable-qmail-newmrh=/var/qmail/bin/qmail-newmrh \
		--enable-vpopuser=vpopmail \
		--enable-many-domains=y \
		--enable-vpopgroup=vpopmail \
		--enable-file-locking=y \
		--enable-file-sync=y \
		--enable-md5-passwords=y \
		--enable-defaultquota=30000000,1000C \
		--enable-roaming-users=y --enable-relay-clear-minutes=60 \
		--enable-tcprules-prog=/usr/bin/tcprules --enable-tcpserver-file=/etc/tcp.smtp \
		--enable-logging=y \
		--enable-log-name=vpopmail \
		--enable-qmail-ext || die "econf failed"

	use mysql && echo '#define MYSQL_PASSWORD_FILE "/etc/vpopmail.conf"' >> ${S}/config.h

	emake || die "Make failed."
}

src_install () {
	vpopmail_set_homedir

	make DESTDIR=${D} install-strip || die

	into /var/vpopmail
	dobin ${FILESDIR}/vpopmail-Maildir-dotmaildir-fix.sh
	into /usr

	# Install documentation.
	dodoc AUTHORS ChangeLog COPYING FAQ INSTALL NEWS TODO
	dodoc README README.* RELEASE.NOTES UPGRADE.*
	dodoc doc/doc_html/* doc/man_html/*
	rm -rf ${D}/${VPOP_HOME}/doc
	dosym /usr/share/doc/${PF}/ ${VPOP_HOME}/doc

	# Create /etc/vpopmail.conf
	if use mysql; then
		einfo "Installing vpopmail mysql configuration file"
		dodir /etc
		insinto /etc
		doins ${FILESDIR}/vpopmail.conf
		fowners vpopmail:vpopmail /etc/vpopmail.conf
		fperms 600 /etc/vpopmail.conf
	fi

	# Install a proper cronjob instead of the old nastiness
	einfo "Installing cronjob"
	dodir /etc/cron.hourly
	insinto /etc/cron.hourly
	doins ${FILESDIR}/vpopmail.clearopensmtp
	fperms +x /etc/cron.hourly/vpopmail.clearopensmtp

	einfo "Installing env.d entry"
	dodir /etc/env.d
	insinto /etc/env.d
	doins ${FILESDIR}/99vpopmail

	# Configure b0rked. We'll do this manually
	echo "-I${VPOP_HOME}/include" > ${D}/${VPOP_HOME}/etc/inc_deps
	local libs_extra
	use mysql && libs_extra="-L/usr/lib/mysql -lmysqlclient -lz" || libs_extra=""
	echo "-L${VPOP_HOME}/lib -lvpopmail ${libs_extra}" > ${D}/${VPOP_HOME}/etc/lib_deps

	einfo "Locking down vpopmail permissions"
	# secure things more, i don't want the vpopmail user being able to write this stuff!
	chown -R root:root ${D}${VPOP_HOME}/{bin,etc,include}

}

pkg_preinst() {
	vpopmail_set_homedir

	# Keep DATA
	keepdir ${VPOP_HOME}/domains

	# This is a workaround until portage handles binary packages+users better.
	pkg_setup

	upgradewarning
}

pkg_postinst() {
	einfo "Performing post-installation routines for ${P}."

	if use mysql; then
		echo
		einfo "You have 'mysql' turned on in your USE"
		einfo "Vpopmail needs a VALID MySQL USER. Let's call it 'vpopmail'"
		einfo "You MUST add it and then specify its passwd in the /etc/vpopmail.conf file"
		echo
		einfo "First log into mysql as your mysql root user and pass. Then:"
		einfo "> create database vpopmail;"
		einfo "> use mysql;"
		einfo "> grant select, insert, update, delete, create, drop on vpopmail.* to"
		einfo "  vpopmail@localhost identified by 'your password';"
		einfo "> flush privileges;"
		echo
		einfo "If you have problems with vpopmail not accepting mail properly,"
		einfo "please ensure that /etc/vpopmail.conf is chmod 600 and"
		einfo "owned by vpopmail:vpopmail"
	fi
	# do this for good measure
	if [ -e /etc/vpopmail.conf ]; then
		chmod 600 /etc/vpopmail.conf
		chown vpopmail:vpopmail /etc/vpopmail.conf
	fi

	upgradewarning
}

pkg_postrm() {
	vpopmail_set_homedir

	einfo "The vpopmail DATA will NOT be removed automatically."
	einfo "You can delete them manually by removing the ${VPOP_HOME} directory."
}

upgradewarning() {
	ewarn "Massive important warning if you are upgrading to 5.2.1-r8 or older"
	ewarn "The internal structure of the mail storage has changed for"
	ewarn "consistancy with the rest of Gentoo! Please review and utilize the "
	ewarn "script at /var/vpopmail/bin/vpopmail-Maildir-dotmaildir-fix.sh"
	ewarn "to upgrade your system! (It can do conversions both ways)."
	ewarn "You should be able to run it right away without any changes."
}
