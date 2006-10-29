# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-filter/dspam/dspam-3.6.8.ebuild,v 1.1 2006/10/29 09:55:43 mrness Exp $

inherit eutils autotools flag-o-matic

DESCRIPTION="A statistical-algorithmic hybrid anti-spam filter"
HOMEPAGE="http://dspam.nuclearelephant.com/"
SRC_URI="http://dspam.nuclearelephant.com/sources/${P}.tar.gz
	mirror://gentoo/${P}-patches-20061029.tar.gz
	http://dspam.nuclearelephant.com/sources/extras/dspam_sa_trainer.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE="clamav daemon debug large-domain ldap logrotate mysql oracle postgres \
	sqlite sqlite3 virtual-users user-homedirs"

DEPEND="clamav?		( >=app-antivirus/clamav-0.86 )
	ldap?		( >=net-nds/openldap-2.2 )
	mysql?		( >=dev-db/mysql-3.23 )
	postgres?	( >=dev-db/postgresql-7.4.3 )
	sqlite?		( <dev-db/sqlite-3 )
	sqlite3?	( =dev-db/sqlite-3* )"

RDEPEND="${DEPEND}
	sys-process/cronbase
	virtual/logger
	logrotate? ( app-admin/logrotate )"

KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"

# some FHS-like structure
HOMEDIR="/var/spool/dspam"
CONFDIR="/etc/mail/dspam"
LOGDIR="/var/log/dspam"

create_dspam_usergroup() {
	local egid euid
	#Need a UID and GID >= 1000, for being able to use suexec in apache
	for euid in $(seq 1000 5000 ) ; do
		[[ -z $(egetent passwd ${euid}) ]] && break
	done
	for egid in $(seq 1000 5000 ) ; do
		[[ -z $(egetent group ${egid}) ]] && break
	done

	enewgroup dspam ${egid}
	enewuser dspam ${euid} -1 ${HOMEDIR} dspam,mail
}

pkg_setup() {
	if use virtual-users && use user-homedirs ; then
		eerror "If the users are virtual, then they probably should not have home directories."
		die "Incompatible USE flag selection"
	fi

	create_dspam_usergroup
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	EPATCH_SUFFIX="patch"
	epatch "${WORKDIR}"/patches

	# Fix Lazy bindings
	append-flags $(bindnow-flags)

	AT_M4DIR="${S}/m4"
	eautoreconf
}

src_compile() {
	local myconf="--enable-long-username --enable-syslog"

	use large-domain && myconf="${myconf} --enable-large-scale" ||\
			    myconf="${myconf} --enable-domain-scale"

	use user-homedirs && myconf="${myconf} --enable-homedir"

	use debug && myconf="${myconf} --enable-debug --enable-verbose-debug --enable-bnr-debug"

	if use virtual-users ; then
		if use mysql || use postgres || use oracle ; then
			myconf="${myconf} --enable-virtual-users"
		fi
	fi

	if use mysql || use postgres ; then
		myconf="${myconf} --enable-preferences-extension"
	fi

	local STORAGE
	# select storage driver
	if use sqlite ; then
		if [ "$STORAGE" ] ; then STORAGE="${STORAGE}," ; fi
		STORAGE="${STORAGE}sqlite_drv"
	fi
	if use sqlite3 ; then
		if [ "$STORAGE" ] ; then STORAGE="${STORAGE}," ; fi
		STORAGE="${STORAGE}sqlite3_drv"
	fi
	if use mysql; then
		if [ "$STORAGE" ] ; then STORAGE="${STORAGE}," ; fi
		STORAGE="${STORAGE}mysql_drv"
		myconf="${myconf} --with-mysql-includes=/usr/include/mysql"
		myconf="${myconf} --with-mysql-libraries=/usr/lib/mysql"
	fi
	if use postgres ; then
		if [ "$STORAGE" ] ; then STORAGE="${STORAGE}," ; fi
		STORAGE="${STORAGE}pgsql_drv"
		myconf="${myconf} --with-pgsql-includes=/usr/include/postgresql"
		myconf="${myconf} --with-pgsql-libraries=/usr/lib/postgresql"
	fi
	if use oracle ; then
		if [ "$STORAGE" ] ; then STORAGE="${STORAGE}," ; fi
		STORAGE="${STORAGE}ora_drv"
		myconf="${myconf} --with-oracle-home=${ORACLE_HOME}"

		# I am in no way a Oracle specialist. If someone knows
		# how to query the version of Oracle, then let me know.
		if (expr ${ORACLE_HOME/*\/} : 10 1>/dev/null 2>&1); then
			myconf="${myconf} --with-oracle-version=10"
		fi
	fi
	if [[ -z "${STORAGE}" ]]; then
		STORAGE="${STORAGE}hash_drv"
	fi

	econf ${myconf} --with-storage-driver=${STORAGE} \
			--enable-long-usernames \
			--with-dspam-home=${HOMEDIR} \
			--sysconfdir=${CONFDIR} \
			$(use_enable daemon) \
			$(use_enable ldap) \
			$(use_enable clamav) \
		        --with-dspam-group=dspam \
		        --with-dspam-home-group=dspam \
			--with-logdir=${LOGDIR} || die "econf failed"
	emake || die "emake failed"
}

src_install () {
	diropts -m0770 -o dspam -g dspam
	dodir ${CONFDIR}
	insinto ${CONFDIR}
	insopts -m640 -o dspam -g dspam
	doins src/dspam.conf

	dosym /etc/mail/dspam /etc/dspam

	# make install
	make DESTDIR="${D}" install || die "make install failed"
	chgrp dspam "${D}/usr/bin/dspam"
	chmod g+xs,o+x "${D}/usr/bin/dspam"

	dodir /usr/lib/dspam
	mv "${D}"/usr/lib/*drv* "${D}"/usr/lib/dspam/

	diropts -m0755 -o dspam -g dspam
	keepdir /var/run/dspam

	# create logdir
	if use debug ; then
		diropts -m0770 -o dspam -g dspam
		keepdir ${LOGDIR}
	fi

	#clean options
	diropts
	insopts

	if use daemon; then
		# We use sockets for the daemon instead of tcp port 24
		sed -e 's:^#*\(ServerDomainSocketPath[\t ]\{1,\}\).*:\1\"/var/run/dspam/dspam.sock\":gI' \
			-e 's:^#*\(ServerPID[\t ]\{1,\}\).*:\1/var/run/dspam/dspam.pid:gI' \
			-i "${D}/${CONFDIR}/dspam.conf"

		newinitd "${FILESDIR}/dspam.rc" dspam
	fi

	# generate random password
	local PASSWORD="${RANDOM}${RANDOM}${RANDOM}${RANDOM}"

	# database related configuration and scripts
	if use sqlite; then
		insinto ${CONFDIR}
		newins src/tools.sqlite_drv/purge-2.sql sqlite_purge.sql
	fi
	if use sqlite3; then
		insinto ${CONFDIR}
		newins src/tools.sqlite_drv/purge-3.sql sqlite3_purge.sql
	fi
	if use mysql; then
		# Use existing configuration if possible
		if [[ -f "${ROOT}${CONFDIR}/mysql.data" ]]; then
			DSPAM_DB_DATA=( $(sed "s:^[\t ]*$:###:gI" "${ROOT}${CONFDIR}/mysql.data") )
			for DB_DATA_INDEX in $(seq 0 $((${#DSPAM_DB_DATA[@]} - 1))); do
				[[ "${DSPAM_DB_DATA[$DB_DATA_INDEX]}" = "###" ]] && DSPAM_DB_DATA[$DB_DATA_INDEX]=""
			done
		else
			DSPAM_DB_DATA[0]="/var/run/mysqld/mysqld.sock"
			DSPAM_DB_DATA[1]=""
			DSPAM_DB_DATA[2]="dspam"
			DSPAM_DB_DATA[3]="${PASSWORD}"
			DSPAM_DB_DATA[4]="dspam"
			DSPAM_DB_DATA[5]="true"
		fi

		# Modify configuration and create mysql.data file
		sed -e "s:^#*\(MySQLServer[\t ]\{1,\}\).*:\1${DSPAM_DB_DATA[0]}:gI" \
			-e "s:^#*\(MySQLPort[\t ]\{1,\}\).*:\1${DSPAM_DB_DATA[1]}:gI" \
			-e "s:^#*\(MySQLUser[\t ]\{1,\}\).*:\1${DSPAM_DB_DATA[2]}:gI" \
			-e "s:^#*\(MySQLPass[\t ]\{1,\}\).*:\1${DSPAM_DB_DATA[3]}:gI" \
			-e "s:^#*\(MySQLDb[\t ]\{1,\}\).*:\1${DSPAM_DB_DATA[4]}:gI" \
			-e "s:^#*\(MySQLCompress[\t ]\{1,\}\).*:\1${DSPAM_DB_DATA[5]}:gI" \
			-i "${D}"/${CONFDIR}/dspam.conf
		for DB_DATA_INDEX in $(seq 0 $((${#DSPAM_DB_DATA[@]} - 1))); do
			echo "${DSPAM_DB_DATA[$DB_DATA_INDEX]}" >> ${D}/${CONFDIR}/mysql.data
		done

		insinto ${CONFDIR}
		newins src/tools.mysql_drv/mysql_objects-space.sql mysql_objects-space.sql
		newins src/tools.mysql_drv/mysql_objects-speed.sql mysql_objects-speed.sql
		newins src/tools.mysql_drv/mysql_objects-4.1.sql mysql_objects-4.1.sql
		newins src/tools.mysql_drv/virtual_users.sql mysql_virtual_users.sql
		newins src/tools.mysql_drv/purge.sql mysql_purge.sql
		newins src/tools.mysql_drv/purge-4.1.sql mysql_purge-4.1.sql

		fperms 640 ${CONFDIR}/mysql.data
		fowners root:dspam ${CONFDIR}/mysql.data
	fi
	if use postgres ; then
		# Use existing configuration if possible
		if [ -f ${ROOT}${CONFDIR}/pgsql.data ]; then
			DSPAM_DB_DATA=( $(cat "${ROOT}${CONFDIR}/pgsql.data") )
			for DB_DATA_INDEX in $(seq 0 $((${#DSPAM_DB_DATA[@]} - 1))); do
				[[ "${DSPAM_DB_DATA[$DB_DATA_INDEX]}" = "###" ]] && DSPAM_DB_DATA[$DB_DATA_INDEX]=""
			done
		else
			DSPAM_DB_DATA[0]="127.0.0.1"
			DSPAM_DB_DATA[1]="5432"
			DSPAM_DB_DATA[2]="dspam"
			DSPAM_DB_DATA[3]="${PASSWORD}"
			DSPAM_DB_DATA[4]="dspam"
		fi

		# Modify configuration and create pgsql.data file
		sed -e "s:^#*\(PgSQLServer[\t ]\{1,\}\).*:\1${DSPAM_DB_DATA[0]}:gI" \
			-e "s:^#*\(PgSQLPort[\t ]\{1,\}\).*:\1${DSPAM_DB_DATA[1]}:gI" \
			-e "s:^#*\(PgSQLUser[\t ]\{1,\}\).*:\1${DSPAM_DB_DATA[2]}:gI" \
			-e "s:^#*\(PgSQLPass[\t ]\{1,\}\).*:\1${DSPAM_DB_DATA[3]}:gI" \
			-e "s:^#*\(PgSQLDb[\t ]\{1,\}\).*:\1${DSPAM_DB_DATA[4]}:gI" \
			-e "s:^#*\(PgSQLConnectionCache[\t ]*.\):\1:gI" \
			-i ${D}/${CONFDIR}/dspam.conf
		for DB_DATA_INDEX in $(seq 0 $((${#DSPAM_DB_DATA[@]} - 1))); do
			echo "${DSPAM_DB_DATA[$DB_DATA_INDEX]}" >> ${D}/${CONFDIR}/pgsql.data
		done

		insinto ${CONFDIR}
		newins src/tools.pgsql_drv/pgsql_objects.sql pgsql_objects.sql
		newins src/tools.pgsql_drv/virtual_users.sql pgsql_virtual_users.sql
		newins src/tools.pgsql_drv/purge.sql pgsql_purge.sql

		fperms 640 ${CONFDIR}/pgsql.data
		fowners root:dspam ${CONFDIR}/pgsql.data
	fi
	if use oracle ; then
		# Use existing configuration if possible
		if [ -f ${ROOT}${CONFDIR}/oracle.data ]; then
			DSPAM_DB_DATA=( $(cat "${ROOT}${CONFDIR}/oracle.data") )
			for DB_DATA_INDEX in $(seq 0 $((${#DSPAM_DB_DATA[@]} - 1))); do
				[[ "${DSPAM_DB_DATA[$DB_DATA_INDEX]}" = "###" ]] && DSPAM_DB_DATA[$DB_DATA_INDEX]=""
			done
		else
			DSPAM_DB_DATA[0]="(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=127.0.0.1)(PORT=1521))(CONNECT_DATA=(SID=PROD)))"
			DSPAM_DB_DATA[1]="dspam"
			DSPAM_DB_DATA[2]="${PASSWORD}"
			DSPAM_DB_DATA[3]="dspam"
		fi

		# Modify configuration and create oracle.data file
		sed -e "s:^#*\(OraServer[\t ]\{1,\}\).*:\1${DSPAM_DB_DATA[0]}:gI" \
			-e "s:^\(OraUser[\t ]\{1,\}\).*:\1${DSPAM_DB_DATA[1]}:gI" \
			-e "s:^\(OraPass[\t ]\{1,\}\).*:\1${DSPAM_DB_DATA[2]}:gI" \
			-e "s:^\(OraSchema[\t ]\{1,\}\).*:\1${DSPAM_DB_DATA[3]}:gI"\
		   	-i "${D}"/${CONFDIR}/dspam.conf
		for DB_DATA_INDEX in $(seq 0 $((${#DSPAM_DB_DATA[@]} - 1))); do
			echo "${DSPAM_DB_DATA[$DB_DATA_INDEX]}" >> "${D}"/${CONFDIR}/oracle.data
		done

		insinto ${CONFDIR}
		newins src/tools.ora_drv/oral_objects.sql ora_objects.sql
		newins src/tools.ora_drv/virtual_users.sql ora_virtual_users.sql
		newins src/tools.ora_drv/purge.sql ora_purge.sql

		fperms 640 ${CONFDIR}/oracle.data
		fowners root:dspam ${CONFDIR}/oracle.data
	fi

	sed -e "s:^\(Purge.*\):###\1:g" \
		-e "s:^#\(Purge.*\):\1:g" \
		-e "s:^###\(Purge.*\):#\1:g" \
		-i "${D}"/${CONFDIR}/dspam.conf

	# installs the notification messages
	# -> The documentation is wrong! The files need to be in ./txt
	insinto ${CONFDIR}/txt
	doins "${S}"/txt/*.txt

	# Create the opt-in / opt-out directories
	diropts -m0770 -o dspam -g dspam
	dodir ${HOMEDIR}
	keepdir ${HOMEDIR}/opt-in
	keepdir ${HOMEDIR}/opt-out
	diropts

	# logrotation scripts
	if use logrotate && use debug ; then
		insinto /etc/logrotate.d
		newins "${FILESDIR}/logrotate.dspam" dspam
	fi

	# dspam cron job
	exeinto /etc/cron.daily
	doexe "${FILESDIR}/dspam.cron"

	# documentation
	dodoc CHANGELOG README* RELEASE.NOTES UPGRADING
	docinto doc
	dodoc doc/*.txt
	docinto gentoo
	dodoc "${FILESDIR}/README.postfix" "${FILESDIR}/README.qmail"
	docinto sa_train
	dodoc "${WORKDIR}"/dspam_sa_trainer/*
	doman man/dspam*
}

pkg_postinst() {
	# need enewgroup/enewuser in this function for binary install.
	create_dspam_usergroup

	if use mysql || use postgres || use oracle; then
		echo
		einfo "To setup DSPAM to run out-of-the-box on your system with a MySQL,"
		einfo "PostgreSQL or Oracle database, run:"
		einfo "emerge --config =${PF}"
	fi

	if use postgres && has_version ">dev-db/postgresql-8.0"; then
		echo
		einfo "Before executing the configuration command mentioned above you have"
		einfo "to execute the following command:"
		einfo "createlang plpgsql -U postgres dspam"
	fi

	if use daemon; then
		echo
		einfo "If you want to run DSPAM in the new daemon mode remember"
		einfo "to make the DSPAM daemon start during boot:"
		einfo "  rc-update add dspam default"
	fi
	if use daemon ; then
		einfo "To use the DSPAM daemon mode, the used storage driver must be thread-safe."
	fi

	einfo "Edit /etc/mail/dspam.conf with your delivery agent"
	einfo "See http://dspamwiki.expass.de/Installation for more info"
}

pkg_config () {
	if use sqlite || use sqlite3 ; then
		einfo "sqlite_drv will automatically create the necessary database"
	fi
	if use mysql ; then
		DSPAM_DB_DATA=( $(sed "s:^[\t ]*$:###:gI" "${ROOT}${CONFDIR}/mysql.data") )
		for DB_DATA_INDEX in $(seq 0 $((${#DSPAM_DB_DATA[@]} - 1))); do
			[[ "${DSPAM_DB_DATA[$DB_DATA_INDEX]}" = "###" ]] && DSPAM_DB_DATA[$DB_DATA_INDEX]=""
		done
		DSPAM_MySQL_USER="${DSPAM_DB_DATA[2]}"
		DSPAM_MySQL_PWD="${DSPAM_DB_DATA[3]}"
		DSPAM_MySQL_DB="${DSPAM_DB_DATA[4]}"

		ewarn "When prompted for a password, please enter your MySQL root password"
		ewarn

		einfo "Creating DSPAM MySQL database \"${DSPAM_MySQL_DB}\""
		/usr/bin/mysqladmin -u root -p create ${DSPAM_MySQL_DB}


		if has_version ">dev-db/mysql-4.1"; then
			/usr/bin/mysql -u root -p ${DSPAM_MySQL_DB} < ${CONFDIR}/mysql_objects-4.1.sql
		else
			einfo "Creating DSPAM MySQL tables for data objects"
			einfo "  Please select what kind of object database you like to use."
			einfo "    [1] Space optimized database"
			einfo "    [2] Speed optimized database"
			einfo
			while true
			do
				read -n 1 -s -p "  Press 1 or 2 on the keyboard to select database" DSPAM_MySQL_DB_Type
				[[ "${DSPAM_MySQL_DB_Type}" == "1" || "${DSPAM_MySQL_DB_Type}" == "2" ]] && echo && break
			done

			if [ "${DSPAM_MySQL_DB_Type}" == "1" ]
			then
				/usr/bin/mysql -u root -p ${DSPAM_MySQL_DB} < ${CONFDIR}/mysql_objects-space.sql
			else
				/usr/bin/mysql -u root -p ${DSPAM_MySQL_DB} < ${CONFDIR}/mysql_objects-speed.sql
			fi
		fi

		if use virtual-users ; then
			einfo "Creating DSPAM MySQL database for virtual-users users"
			/usr/bin/mysql -u root -p ${DSPAM_MySQL_DB} < ${CONFDIR}/mysql_virtual_users.sql
		fi

		einfo "Creating DSPAM MySQL user \"${DSPAM_MySQL_USER}\""
		/usr/bin/mysql -u root -p -e "GRANT SELECT,INSERT,UPDATE,DELETE ON ${DSPAM_MySQL_DB}.* TO ${DSPAM_MySQL_USER}@localhost IDENTIFIED BY '${DSPAM_MySQL_PWD}';FLUSH PRIVILEGES;" -D mysql
	fi
	if use postgres ; then
		DSPAM_DB_DATA=( $(sed "s:^[\t ]*$:###:gI" "${ROOT}${CONFDIR}/pgsql.data") )
		for DB_DATA_INDEX in $(seq 0 $((${#DSPAM_DB_DATA[@]} - 1))); do
			[[ "${DSPAM_DB_DATA[$DB_DATA_INDEX]}" = "###" ]] && DSPAM_DB_DATA[$DB_DATA_INDEX]=""
		done
		DSPAM_PgSQL_USER="${DSPAM_DB_DATA[2]}"
		DSPAM_PgSQL_PWD="${DSPAM_DB_DATA[3]}"
		DSPAM_PgSQL_DB="${DSPAM_DB_DATA[4]}"

		ewarn "When prompted for a password, please enter your PgSQL postgres password"
		ewarn

		einfo "Creating DSPAM PostgreSQL database \"${DSPAM_PgSQL_DB}\" and user \"${DSPAM_PgSQL_USER}\""
		/usr/bin/psql -h localhost -d template1 -U postgres -c "CREATE USER ${DSPAM_PgSQL_USER} WITH PASSWORD '${DSPAM_PgSQL_PWD}' NOCREATEDB NOCREATEUSER; CREATE DATABASE ${DSPAM_PgSQL_DB}; GRANT ALL PRIVILEGES ON DATABASE ${DSPAM_PgSQL_DB} TO ${DSPAM_PgSQL_USER}; GRANT ALL PRIVILEGES ON SCHEMA public TO ${DSPAM_PgSQL_USER}; UPDATE pg_database SET datdba=(SELECT usesysid FROM pg_shadow WHERE usename='${DSPAM_PgSQL_USER}') WHERE datname='${DSPAM_PgSQL_DB}';"

		einfo "Creating DSPAM PostgreSQL tables"
		PGUSER=${DSPAM_PgSQL_USER} PGPASSWORD=${DSPAM_PgSQL_PWD} /usr/bin/psql -d ${DSPAM_PgSQL_DB} -U ${DSPAM_PgSQL_USER} -f ${CONFDIR}/pgsql_objects.sql 1>/dev/null 2>&1

		if use virtual-users ; then
			einfo "Creating DSPAM PostgreSQL database for virtual-users users"
			PGUSER=${DSPAM_PgSQL_USER} PGPASSWORD=${DSPAM_PgSQL_PWD} /usr/bin/psql -d ${DSPAM_PgSQL_DB} -U ${DSPAM_PgSQL_USER} -f ${CONFDIR}/pgsql_virtual_users.sql 1>/dev/null 2>&1
		fi
	fi
	if use oracle ; then
		einfo "We have not enought Oracle knowledge to configure Oracle"
		einfo "automatically. If you know how, please post a message in"
		einfo "Gentoo Bugzilla."
		einfo
		einfo "You need manually to create the Oracle user for DSPAM and"
		einfo "the necessary database."
		einfo "But the DSPAM configuration file dspam.conf and oracle.data"
		einfo "was already configured with the necessary information to"
		einfo "access the database."
		einfo "Please read your dspam.conf, oracle.data and the README for"
		einfo "more info on how to setup DSPAM with Oracle."
		einfo "objects for each user upon first use of DSPAM by that user."
	fi
}
