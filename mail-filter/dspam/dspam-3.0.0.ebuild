# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-filter/dspam/dspam-3.0.0.ebuild,v 1.3 2004/06/28 03:23:41 agriffis Exp $

inherit eutils

DESCRIPTION="A statistical-algorithmic hybrid anti-spam filter"
SRC_URI="http://www.nuclearelephant.com/projects/dspam/sources/${P}.tar.gz"
HOMEPAGE="http://www.nuclearelephant.com/projects/dspam/index.html"
LICENSE="GPL-2"

IUSE="debug mysql procmail neural"
DEPEND="mysql? ( >=dev-db/mysql-3.23 ) || ( >=sys-libs/db-4.0 )
		procmail? ( >=mail-filter/procmail-3.22 )"
RDEPEND="virtual/cron
		app-admin/logrotate"
KEYWORDS="~x86 ~ppc"
SLOT="3.0"

# some FHS-like structure
HOMEDIR="/etc/mail/dspam"
DATADIR="/var/spool/dspam"
LOGDIR="/var/log/dspam"
CONFIGDIR="${HOMEDIR}/config"

MYSQL_TABLE_TYPE="space.optimized"

src_compile() {
	local myconf

	# these are the default settings
	myconf="${myconf} --with-signature-life=14"
	use procmail && myconf="${myconf} --with-delivery-agent=/usr/bin/procmail"

	myconf="${myconf} --enable-robinson-pvalues"
	myconf="${myconf} --enable-source-address-tracking"

	# ${HOMEDIR}/data is a symlink to ${DATADIR}
	myconf="${myconf} --with-dspam-home=${HOMEDIR}"
	myconf="${myconf} --with-dspam-mode=4755"
	myconf="${myconf} --with-dspam-owner=root"
	myconf="${myconf} --with-dspam-group=mail"
	myconf="${myconf} --with-dspam-home-owner=root"
	myconf="${myconf} --with-dspam-home-group=mail"

	# enables support for debugging (touch /etc/dspam/.debug to turn on)
	# optional: even MORE debugging output, use with extreme caution!
	use debug && myconf="${myconf} --enable-debug --enable-verbose-debug"

	# select storage driver
	if use mysql ; then
		myconf="${myconf} --with-storage-driver=mysql_drv"
		myconf="${myconf} --with-mysql-includes=/usr/include/mysql"
		myconf="${myconf} --with-mysql-libraries=/usr/lib/mysql"

		# an experimental feature available with MySQL backend
		if use neural ; then
			myconf="${myconf} --enable-neural-networking"
		fi
	else
		myconf="${myconf} --with-storage-driver=libdb4_drv"
		myconf="${myconf} --with-db4-includes=/usr/include"
		myconf="${myconf} --with-db4-libraries=/usr/lib"
	fi

	econf ${myconf} || die
	emake || die

}

src_install () {
	# open up perms on /etc/mail/dspam
	diropts -m0775 -o root -g mail
	dodir ${HOMEDIR}
	keepdir ${HOMEDIR}

	# keeps dspam data in /var
	diropts -m0770 -o root -g mail
	dodir ${DATADIR}
	keepdir ${DATADIR}

	# keeps dspam log in /var/log
	diropts -m0770
	diropts -m0775 -o root -g mail
	dodir ${LOGDIR}
	keepdir ${LOGDIR}

	# make install
	make DESTDIR=${D} install || die

	# documentation
	dodoc CHANGELOG LICENSE README RELEASE.NOTES
	dodoc ${FILESDIR}/README.postfix ${FILESDIR}/README.qmail
	if use mysql ; then
		newdoc tools.mysql_drv/README README.MYSQL
	fi

	# install some initial configuration
	insinto ${HOMEDIR}
	insopts -m0640 -o root -g mail
	doins ${FILESDIR}/trusted.users
	doins ${FILESDIR}/untrusted.mailer_args

	# database related configuration and scripts
	if use mysql ; then
		local PASSWORD="${RANDOM}${RANDOM}${RANDOM}${RANDOM}"

		# Replace some variables in the configuration files
		sed -e "s,@HOMEDIR@,${HOMEDIR},g" \
			-e "s,@confdir@,${CONFIGDIR},g" \
			${FILESDIR}/crontab.mysql > ${T}/dspam.cron

		sed -e "s,@password@,${PASSWORD},g" \
			${FILESDIR}/mysql.data > ${T}/mysql.data

		sed -e "s,@password@,${PASSWORD},g" \
			${FILESDIR}/mysql_create_user.sql > ${T}/mysql_setup.sql
		cat ${S}/tools.mysql_drv/mysql_objects.sql.${MYSQL_TABLE_TYPE} >> ${T}/mysql_setup.sql

		sed -e "s,@HOMEDIR@,${HOMEDIR},g" \
			-e "s,@confdir@,${CONFIGDIR},g" \
			${FILESDIR}/mysql_install_db > ${T}/mysql_install_db

		sed -e "s,@HOMEDIR@,${HOMEDIR},g" \
			-e "s,@password@,${PASSWORD},g" \
			-e "s,@confdir@,${CONFIGDIR},g" \
			 ${FILESDIR}/mysql_purge_db > ${T}/mysql_purge_db

		insinto ${CONFIGDIR}
		insopts -m644 -o root -g mail
		doins ${T}/mysql.data
		doins ${T}/mysql_setup.sql
		doins ${FILESDIR}/upgrade.sql
		newins tools.mysql_drv/purge.sql mysql_purge.sql

		exeinto ${CONFIGDIR}
		exeopts -m755 -o root -g mail
		doexe ${T}/mysql_install_db
		doexe ${T}/mysql_purge_db

		einfo "Fresh install: run ${HOMEDIR}/mysql_install_db to setup the dspam database"
		einfo "Upgrades from 2.x: See the README for instructions on updating your tables for dspam-3.0"
	else
		cp ${FILESDIR}/crontab.db4 ${T}/dspam.cron
	fi

	# installs the cron job to the cron directory
	diropts -m0755 -o root -g mail
	dodir /etc/cron.daily
	keepdir /etc/cron.daily
	exeinto /etc/cron.daily
	exeopts -m0755 -o root -g mail
	doexe ${T}/dspam.cron

	# installs the logrotation scripts to the logrotate.d directory
	diropts -m0755 -o root -g mail
	dodir /etc/logrotate.d
	keepdir /etc/logrotate.d
	insinto /etc/logrotate.d
	insopts -m0755 -o root -g mail
	newins ${FILESDIR}/logrotate.dspam dspam

	# Symlinks data to HOMEDIR
	dosym ${DATADIR} ${HOMEDIR}/data

	# Log files for symlinks
	diropts -m0755 -o root -g mail
	dodir ${LOGDIR}
	keepdir ${LOGDIR}
	touch ${D}${LOGDIR}/sql.errors
	touch ${D}${LOGDIR}/system.log
	touch ${D}${LOGDIR}/dspam.debug
	touch ${D}${LOGDIR}/dspam.messages

	# dspam still wants to write to a few files in it's home dir
	dosym ${LOGDIR}/sql.errors ${HOMEDIR}/sql.errors
	dosym ${LOGDIR}/system.log ${HOMEDIR}/system.log
	dosym ${LOGDIR}/dspam.debug ${HOMEDIR}/dspam.debug
	dosym ${LOGDIR}/dspam.messages ${HOMEDIR}/dspam.messages
}

pkg_postinst() {
	if use mysql ; then
		einfo "To setup dspam to run out-of-the-box on your system with a mysql database, run:"
		einfo "ebuild /var/db/pkg/${CATEGORY}/${PF}/${PF}.ebuild config"
	fi
}

pkg_config () {
	if use mysql ; then
		${CONFIGDIR}/mysql_install_db
		mv ${CONFIGDIR}/mysql.data ${HOMEDIR}
	fi
}
