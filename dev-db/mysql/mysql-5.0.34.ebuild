# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/mysql/mysql-5.0.34.ebuild,v 1.1 2007/03/04 12:31:49 vivo Exp $

MY_EXTRAS_VER="20070217"
SERVER_URI="ftp://ftp.mysql.com/pub/mysql/src/mysql-${PV//_/-}.tar.gz"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~sparc-fbsd ~x86 ~x86-fbsd"


# Both MYSQL_VERSION_ID and MYSQL_PATCHSET_REV must be set in the ebuild too!
# Note that MYSQL_VERSION_ID must be empty!

WANT_AUTOCONF="latest"
WANT_AUTOMAKE="latest"

inherit eutils flag-o-matic gnuconfig autotools mysql_fx

# Shorten the path because the socket path length must be shorter than 107 chars
# and we will run a mysql server during test phase
S="${WORKDIR}/mysql"

# MYSQL_VERSION_ID will be:
# major * 10e6 + minor * 10e4 + micro * 10e2 + gentoo revision number, all [0..99]
# This is an important part, because many of the choices the MySQL ebuild will do
# depend on this variable.
# In particular, the code below transforms a $PVR like "5.0.18-r3" in "5001803"

MYSQL_VERSION_ID=""
tpv=( ${PV//[-._]/ } ) ; tpv[3]="${PVR:${#PV}}" ; tpv[3]="${tpv[3]##*-r}"
for vatom in 0 1 2 3 ; do
	# pad to length 2
	tpv[${vatom}]="00${tpv[${vatom}]}"
	MYSQL_VERSION_ID="${MYSQL_VERSION_ID}${tpv[${vatom}]:0-2}"
done
# strip leading "0" (otherwise it's considered an octal number by BASH)
MYSQL_VERSION_ID=${MYSQL_VERSION_ID##"0"}

# Be warned, *DEPEND are version-dependant
DEPEND="ssl? ( >=dev-libs/openssl-0.9.6d )
		userland_GNU? ( sys-process/procps )
		>=sys-apps/sed-4
		>=sys-apps/texinfo-4.7-r1
		>=sys-libs/readline-4.1
		>=sys-libs/zlib-1.2.3"

# Having different flavours at the same time is not a good idea
for i in "" "-community" ; do
	[[ "${i}" == ${PN#mysql} ]] ||
	DEPEND="${DEPEND} !dev-db/mysql${i}"
done

mysql_version_is_at_least "5.1.12" \
&& DEPEND="${DEPEND} innodb? ( >=dev-util/cmake-2.4.3 )"

# dev-perl/DBD-mysql is needed by some scripts installed by MySQL
PDEPEND="perl? ( >=dev-perl/DBD-mysql-2.9004 )"

# Define correct SRC_URIs
SRC_URI="${SERVER_URI}
		http://g3nt8.org/patches/mysql-extras-${MY_EXTRAS_VER}.tar.bz2"

DESCRIPTION="A fast, multi-threaded, multi-user SQL database server."
HOMEPAGE="http://www.mysql.com/"
LICENSE="GPL-2"
SLOT="0"
IUSE="big-tables debug embedded minimal perl selinux ssl static"
RESTRICT="confcache"

mysql_version_is_at_least "4.1" \
&& IUSE="${IUSE} latin1"

mysql_version_is_at_least "4.1.3" \
&& IUSE="${IUSE} cluster extraengine"

mysql_version_is_at_least "5.0" \
|| IUSE="${IUSE} raid"

mysql_version_is_at_least "5.0.18" \
&& IUSE="${IUSE} max-idx-128"

RDEPEND="${DEPEND}
		!minimal? ( dev-db/mysql-init-scripts )
		selinux? ( sec-policy/selinux-mysql )"

#
# HELPER FUNCTIONS:
#

mysql_disable_test() {
	local testname="${1}" ; shift
	local reason="${@}"
	local mysql_disable_file="${S}/mysql-test/t/disabled.def"
	echo ${testname} : ${reason} >> "${mysql_disable_file}"
	ewarn "test '${testname}' disabled: '${reason}'"
}

# void mysql_init_vars()
#
# Initialize global variables
# 2005-11-19 <vivo@gentoo.org>

mysql_init_vars() {
	MY_SHAREDSTATEDIR=${MY_SHAREDSTATEDIR="/usr/share/mysql"}
	MY_SYSCONFDIR=${MY_SYSCONFDIR="/etc/mysql"}
	MY_LIBDIR=${MY_LIBDIR="/usr/$(get_libdir)/mysql"}
	MY_LOCALSTATEDIR=${MY_LOCALSTATEDIR="/var/lib/mysql"}
	MY_LOGDIR=${MY_LOGDIR="/var/log/mysql"}
	MY_INCLUDEDIR=${MY_INCLUDEDIR="/usr/include/mysql"}

	if [[ -z "${DATADIR}" ]] ; then
		DATADIR=""
		if [[ -f "${MY_SYSCONFDIR}/my.cnf" ]] ; then
			DATADIR=`"my_print_defaults" mysqld 2>/dev/null \
				| sed -ne '/datadir/s|^--datadir=||p' \
				| tail -n1`
			if [[ -z "${DATADIR}" ]] ; then
				DATADIR=`grep ^datadir "${MY_SYSCONFDIR}/my.cnf" \
				| sed -e 's/.*=\s*//'`
			fi
		fi
		if [[ -z "${DATADIR}" ]] ; then
			DATADIR="${MY_LOCALSTATEDIR}"
			einfo "Using default DATADIR"
		fi
		elog "MySQL DATADIR is ${DATADIR}"

		if [[ -z "${PREVIOUS_DATADIR}" ]] ; then
			if [[ -e "${DATADIR}" ]] ; then
				elog "Previous datadir found, it's YOUR job to change"
				elog "ownership and take care of it"
				PREVIOUS_DATADIR="yes"
			else
				PREVIOUS_DATADIR="no"
			fi
			export PREVIOUS_DATADIR
		fi
	fi

	MY_SOURCEDIR=${SERVER_URI##*/}
	MY_SOURCEDIR=${MY_SOURCEDIR%.tar*}

	export MY_SHAREDSTATEDIR MY_SYSCONFDIR
	export MY_LIBDIR MY_LOCALSTATEDIR MY_LOGDIR
	export MY_INCLUDEDIR DATADIR MY_SOURCEDIR
}

configure_minimal() {
	# These are things we exclude from a minimal build, please
	# note that the server actually does get built and installed,
	# but we then delete it before packaging.
	local minimal_exclude_list="server embedded-server extra-tools innodb bench berkeley-db row-based-replication"

	for i in ${minimal_exclude_list} ; do
		myconf="${myconf} --without-${i}"
	done
	myconf="${myconf} --with-extra-charsets=none"
	myconf="${myconf} --enable-local-infile"

	if use static ; then
		myconf="${myconf} --with-client-ldflags=-all-static"
		myconf="${myconf} --disable-shared"
	else
		myconf="${myconf} --enable-shared --enable-static"
	fi

	if mysql_version_is_at_least "4.1" && ! use latin1 ; then
		myconf="${myconf} --with-charset=utf8"
		myconf="${myconf} --with-collation=utf8_general_ci"
	else
		myconf="${myconf} --with-charset=latin1"
		myconf="${myconf} --with-collation=latin1_swedish_ci"
	fi
}

configure_common() {
	myconf="${myconf} $(use_with big-tables)"
	myconf="${myconf} --enable-local-infile"
	myconf="${myconf} --with-extra-charsets=all"
	myconf="${myconf} --with-mysqld-user=mysql"
	myconf="${myconf} --with-server"
	myconf="${myconf} --with-unix-socket-path=/var/run/mysqld/mysqld.sock"
	myconf="${myconf} --without-libwrap"

	if use static ; then
		myconf="${myconf} --with-mysqld-ldflags=-all-static"
		myconf="${myconf} --with-client-ldflags=-all-static"
		myconf="${myconf} --disable-shared"
	else
		myconf="${myconf} --enable-shared --enable-static"
	fi

	if use debug ; then
		myconf="${myconf} --with-debug=full"
	else
		myconf="${myconf} --without-debug"
		mysql_version_is_at_least "4.1.3" \
		&& use cluster \
		&& myconf="${myconf} --without-ndb-debug"
	fi

	if mysql_version_is_at_least "4.1" && ! use latin1 ; then
			myconf="${myconf} --with-charset=utf8"
			myconf="${myconf} --with-collation=utf8_general_ci"
		else
			myconf="${myconf} --with-charset=latin1"
			myconf="${myconf} --with-collation=latin1_swedish_ci"
	fi

	if use embedded ; then
		myconf="${myconf} --with-embedded-privilege-control"
		myconf="${myconf} --with-embedded-server"
	else
		myconf="${myconf} --without-embedded-privilege-control"
		myconf="${myconf} --without-embedded-server"
	fi

}

configure_40_41_50() {
	myconf="${myconf} $(use_with perl bench)"
	myconf="${myconf} --enable-assembler"
	myconf="${myconf} --with-extra-tools"
	myconf="${myconf} --with-innodb"
	myconf="${myconf} --without-readline"
	mysql_version_is_at_least "5.0" || myconf="${myconf} $(use_with raid)"

	# --with-vio is not needed anymore, it's on by default and
	# has been removed from configure
	if use ssl ; then
		 mysql_version_is_at_least "5.0.4" || myconf="${myconf} --with-vio"
	fi

	myconf="${myconf} $(use_with ssl openssl)"

	# The following fix is due to a bug with bdb on SPARC's. See:
	# http://www.geocrawler.com/mail/msg.php3?msg_id=4754814&list=8
	# It comes down to non-64-bit safety problems.
	if use alpha || use amd64 || use hppa || use mips || use sparc ; then
		elog "Berkeley DB support was disabled due to incompatible arch"
		myconf="${myconf} --without-berkeley-db"
	else
		if use berkdb ; then
			myconf="${myconf} --with-berkeley-db=./bdb"
		else
			myconf="${myconf} --without-berkeley-db"
		fi
	fi

	if mysql_version_is_at_least "4.1.3" ; then
		myconf="${myconf} --with-geometry"
		myconf="${myconf} $(use_with cluster ndbcluster)"
	fi

	if mysql_version_is_at_least "4.1.3" && use extraengine ; then
		# http://dev.mysql.com/doc/mysql/en/archive-storage-engine.html
		myconf="${myconf} --with-archive-storage-engine"

		# http://dev.mysql.com/doc/mysql/en/csv-storage-engine.html
		myconf="${myconf} --with-csv-storage-engine"

		# http://dev.mysql.com/doc/mysql/en/blackhole-storage-engine.html
		myconf="${myconf} --with-blackhole-storage-engine"

		# http://dev.mysql.com/doc/mysql/en/federated-storage-engine.html
		# http://dev.mysql.com/doc/mysql/en/federated-description.html
		# http://dev.mysql.com/doc/mysql/en/federated-limitations.html
		if mysql_version_is_at_least "5.0.3" ; then
			elog "Before using the Federated storage engine, please be sure to read"
			elog "http://dev.mysql.com/doc/mysql/en/federated-limitations.html"
			myconf="${myconf} --with-federated-storage-engine"
		fi
	fi

	mysql_version_is_at_least "5.0.18" \
	&& use max-idx-128 \
	&& myconf="${myconf} --with-max-indexes=128"
}

#
# EBUILD FUNCTIONS
#

pkg_setup() {
	enewgroup mysql 60 || die "problem adding 'mysql' group"
	enewuser mysql 60 -1 /dev/null mysql || die "problem adding 'mysql' user"

	# Check for USE flag problems in pkg_setup
	if use static && use ssl ; then
		eerror "MySQL does not support being built statically with SSL support enabled!"
		die "MySQL does not support being built statically with SSL support enabled!"
	fi

	if ! mysql_version_is_at_least "5.0" \
	&& use raid \
	&& use static ; then
		eerror "USE flags 'raid' and 'static' conflict, you cannot build MySQL statically"
		eerror "with RAID support enabled."
		die "USE flags 'raid' and 'static' conflict!"
	fi

	if mysql_version_is_at_least "4.1.3" \
	&& ( use cluster || use extraengine ) \
	&& use minimal ; then
		eerror "USE flags 'cluster' and 'extraengine' conflict with 'minimal' USE flag!"
		die "USE flags 'cluster' and 'extraengine' conflict with 'minimal' USE flag!"
	fi

	mysql_check_version_range "4.0 to 5.0.99.99" \
	&& use berkdb \
	&& elog "Berkeley DB support is deprecated and will be removed in future versions!"
}

src_unpack() {
	# Initialize the proper variables first
	mysql_init_vars

	unpack ${A}
	mv -f "${WORKDIR}/${MY_SOURCEDIR}" "${S}"
	cd "${S}"

	# Apply the patches for this MySQL version
	EPATCH_SUFFIX="patch"
	mkdir -p "${EPATCH_SOURCE}" || die "Unable to create epatch directory"
	mysql_mv_patches
	epatch

	# Additional checks, remove bundled zlib
	rm -f "${S}/zlib/"*.[ch]
	sed -i -e "s/zlib\/Makefile dnl/dnl zlib\/Makefile/" "${S}/configure.in"
	rm -f "scripts/mysqlbug"

	# Make charsets install in the right place
	find . -name 'Makefile.am' \
		-exec sed --in-place -e 's!$(pkgdatadir)!'${MY_SHAREDSTATEDIR}'!g' {} \;

	if mysql_version_is_at_least "4.1" ; then
		# Remove what needs to be recreated, so we're sure it's actually done
		find . -name Makefile \
			-o -name Makefile.in \
			-o -name configure \
			-exec rm -f {} \;
		rm -f "ltmain.sh"
		rm -f "scripts/mysqlbug"
	fi

	local rebuilddirlist d

	rebuilddirlist=". innobase"

	for d in ${rebuilddirlist} ; do
		einfo "Reconfiguring dir '${d}'"
		pushd "${d}" &>/dev/null
		AT_GNUCONF_UPDATE="yes" eautoreconf
		popd &>/dev/null
	done

	if mysql_check_version_range "4.1 to 5.0.99.99" \
	&& use berkdb ; then
		[[ -w "bdb/dist/ltmain.sh" ]] && cp -f "ltmain.sh" "bdb/dist/ltmain.sh"
		pushd "bdb/dist" \
		&& sh s_all \
		|| die "Failed bdb reconfigure" \
		&>/dev/null
		popd &>/dev/null
	fi
}

src_compile() {
	# Make sure the vars are correctly initialized
	mysql_init_vars

	# $myconf is modified by the configure_* functions
	local myconf=""

	if use minimal ; then
		configure_minimal
	else
		configure_common
		configure_40_41_50
	fi

	# Bug #114895, bug #110149
	filter-flags "-O" "-O[01]"

	# glib-2.3.2_pre fix, bug #16496
	append-flags "-DHAVE_ERRNO_AS_DEFINE=1"

	CXXFLAGS="${CXXFLAGS} -fno-exceptions -fno-strict-aliasing"
	CXXFLAGS="${CXXFLAGS} -felide-constructors -fno-rtti"
	mysql_version_is_at_least "5.0" \
	&& CXXFLAGS="${CXXFLAGS} -fno-implicit-templates"
	export CXXFLAGS

	econf \
		--libexecdir="/usr/sbin" \
		--sysconfdir="${MY_SYSCONFDIR}" \
		--localstatedir="${MY_LOCALSTATEDIR}" \
		--sharedstatedir="${MY_SHAREDSTATEDIR}" \
		--libdir="${MY_LIBDIR}" \
		--includedir="${MY_INCLUDEDIR}" \
		--with-low-memory \
		--with-client-ldflags=-lstdc++ \
		--enable-thread-safe-client \
		--with-comment="Gentoo Linux ${PF}" \
		--without-docs \
		${myconf} || die "econf failed"

	# TODO: Move this before autoreconf !!!
	find . -type f -name Makefile -print0 \
	| xargs -0 -n100 sed -i \
	-e 's|^pkglibdir *= *$(libdir)/mysql|pkglibdir = $(libdir)|;s|^pkgincludedir *= *$(includedir)/mysql|pkgincludedir = $(includedir)|'

	emake || die "emake failed"
}

src_install() {
	# Make sure the vars are correctly initialized
	mysql_init_vars

	emake install DESTDIR="${D}" benchdir_root="${MY_SHAREDSTATEDIR}" || die "emake install failed"

	insinto "${MY_INCLUDEDIR}"
	doins "${MY_INCLUDEDIR}"/my_{config,dir}.h

	# Convenience links
	dosym "/usr/bin/mysqlcheck" "/usr/bin/mysqlanalyze"
	dosym "/usr/bin/mysqlcheck" "/usr/bin/mysqlrepair"
	dosym "/usr/bin/mysqlcheck" "/usr/bin/mysqloptimize"

	# Various junk (my-*.cnf moved elsewhere)
	rm -Rf "${D}/usr/share/info"
	for removeme in  "mysql-log-rotate" mysql.server* \
		binary-configure* my-*.cnf mi_test_all*
	do
		rm -f "${D}"/usr/share/mysql/${removeme}
	done

	# Clean up stuff for a minimal build
	if use minimal ; then
		rm -Rf "${D}${MY_SHAREDSTATEDIR}"/{mysql-test,sql-bench}
		rm -f "${D}"/usr/bin/{mysql{_install_db,manager*,_secure_installation,_fix_privilege_tables,hotcopy,_convert_table_format,d_multi,_fix_extensions,_zap,_explain_log,_tableinfo,d_safe,_install,_waitpid,binlog,test},myisam*,isam*,pack_isam}
		rm -f "${D}/usr/sbin/mysqld"
		rm -f "${D}${MY_LIBDIR}"/lib{heap,merge,nisam,my{sys,strings,sqld,isammrg,isam},vio,dbug}.a
	fi

	# Configuration stuff
	if mysql_version_is_at_least "4.1" ; then
		mysql_mycnf_version="4.1"
	else
		mysql_mycnf_version="4.0"
	fi
	insinto "${MY_SYSCONFDIR}"
	doins scripts/mysqlaccess.conf
	sed -e "s!@DATADIR@!${DATADIR}!g" \
		"${FILESDIR}/my.cnf-${mysql_mycnf_version}" \
		> "${TMPDIR}/my.cnf.ok"
	if mysql_version_is_at_least "4.1" && use latin1 ; then
		sed -e "s|utf8|latin1|g" -i "${TMPDIR}/my.cnf.ok"
	fi
	newins "${TMPDIR}/my.cnf.ok" my.cnf

	# Minimal builds don't have the MySQL server
	if ! use minimal ; then
		# Empty directories ...
		diropts "-m0750"
		if [[ "${PREVIOUS_DATADIR}" != "yes" ]] ; then
			dodir "${DATADIR}"
			keepdir "${DATADIR}"
			chown -R mysql:mysql "${D}/${DATADIR}"
		fi

		diropts "-m0755"
		for folder in "${MY_LOGDIR}" "/var/run/mysqld" ; do
			dodir "${folder}"
			keepdir "${folder}"
			chown -R mysql:mysql "${D}/${folder}"
		done
	fi

	# Docs
	dodoc README COPYING ChangeLog EXCEPTIONS-CLIENT INSTALL-SOURCE

	# Minimal builds don't have the MySQL server
	if ! use minimal ; then
		docinto "support-files"
		for script in \
			support-files/my-*.cnf \
			support-files/magic \
			support-files/ndb-config-2-node.ini
		do
			dodoc "${script}"
		done

		docinto "scripts"
		for script in scripts/mysql* ; do
			[[ "${script%.sh}" == "${script}" ]] && dodoc "${script}"
		done
	fi

	mysql_lib_symlinks "${D}"
}

pkg_preinst() {
	enewgroup mysql 60 || die "problem adding 'mysql' group"
	enewuser mysql 60 -1 /dev/null mysql || die "problem adding 'mysql' user"
}

pkg_postinst() {
	# Make sure the vars are correctly initialized
	mysql_init_vars

	# Check FEATURES="collision-protect" before removing this
	[[ -d "${ROOT}/var/log/mysql" ]] || install -d -m0750 -o mysql -g mysql "${ROOT}${MY_LOGDIR}"

	# Secure the logfiles
	touch "${ROOT}${MY_LOGDIR}"/mysql.{log,err}
	chown mysql:mysql "${ROOT}${MY_LOGDIR}"/mysql*
	chmod 0660 "${ROOT}${MY_LOGDIR}"/mysql*

	# Minimal builds don't have the MySQL server
	if ! use minimal ; then
		docinto "support-files"
		for script in \
			support-files/my-*.cnf \
			support-files/magic \
			support-files/ndb-config-2-node.ini
		do
			dodoc "${script}"
		done

		docinto "scripts"
		for script in scripts/mysql* ; do
			[[ "${script%.sh}" == "${script}" ]] && dodoc "${script}"
		done

		einfo
		elog "You might want to run:"
		elog "\"emerge --config =${CATEGORY}/${PF}\""
		elog "if this is a new install."
		einfo
	fi

	mysql_check_version_range "4.0 to 5.0.99.99" \
	&& use berkdb \
	&& elog "Berkeley DB support is deprecated and will be removed in future versions!"
}

pkg_config() {
	# Make sure the vars are correctly initialized
	mysql_init_vars

	[[ -z "${DATADIR}" ]] && die "Sorry, unable to find DATADIR"

	if built_with_use ${CATEGORY}/${PN} minimal ; then
		die "Minimal builds do NOT include the MySQL server"
	fi

	local pwd1="a"
	local pwd2="b"
	local maxtry=5

	if [[ -d "${ROOT}/${DATADIR}/mysql" ]] ; then
		ewarn "You have already a MySQL database in place."
		ewarn "(${ROOT}/${DATADIR}/*)"
		ewarn "Please rename or delete it if you wish to replace it."
		die "MySQL database already exists!"
	fi

	einfo "Creating the mysql database and setting proper"
	einfo "permissions on it ..."

	einfo "Insert a password for the mysql 'root' user"
	ewarn "Avoid [\"'\\_%] characters in the password"
	read -rsp "    >" pwd1 ; echo

	einfo "Retype the password"
	read -rsp "    >" pwd2 ; echo

	if [[ "x$pwd1" != "x$pwd2" ]] ; then
		die "Passwords are not the same"
	fi

	local options=""
	local sqltmp="$(emktemp)"

	local help_tables="${ROOT}${MY_SHAREDSTATEDIR}/fill_help_tables.sql"
	[[ -r "${help_tables}" ]] \
	&& cp "${help_tables}" "${TMPDIR}/fill_help_tables.sql" \
	|| touch "${TMPDIR}/fill_help_tables.sql"
	help_tables="${TMPDIR}/fill_help_tables.sql"

	pushd "${TMPDIR}" &>/dev/null
	"${ROOT}/usr/bin/mysql_install_db" | grep -B5 -A999 -i "ERROR"
	popd &>/dev/null
	[[ -f "${ROOT}/${DATADIR}/mysql/user.frm" ]] \
	|| die "MySQL databases not installed"
	chown -R mysql:mysql "${ROOT}/${DATADIR}" 2> /dev/null
	chmod 0750 "${ROOT}/${DATADIR}" 2> /dev/null

	if mysql_version_is_at_least "4.1.3" ; then
		options="--skip-ndbcluster"

		# Filling timezones, see
		# http://dev.mysql.com/doc/mysql/en/time-zone-support.html
		"${ROOT}/usr/bin/mysql_tzinfo_to_sql" "${ROOT}/usr/share/zoneinfo" > "${sqltmp}" 2>/dev/null

		if [[ -r "${help_tables}" ]] ; then
			cat "${help_tables}" >> "${sqltmp}"
		fi
	fi

	local socket="${ROOT}/var/run/mysqld/mysqld${RANDOM}.sock"
	local pidfile="${ROOT}/var/run/mysqld/mysqld${RANDOM}.pid"
	local mysqld="${ROOT}/usr/sbin/mysqld \
		${options} \
		--user=mysql \
		--skip-grant-tables \
		--basedir=${ROOT}/usr \
		--datadir=${ROOT}/${DATADIR} \
		--skip-innodb \
		--skip-bdb \
		--skip-networking \
		--max_allowed_packet=8M \
		--net_buffer_length=16K \
		--socket=${socket} \
		--pid-file=${pidfile}"
	${mysqld} &
	while ! [[ -S "${socket}" || "${maxtry}" -lt 1 ]] ; do
		maxtry=$((${maxtry}-1))
		echo -n "."
		sleep 1
	done

	# Do this from memory, as we don't want clear text passwords in temp files
	local sql="UPDATE mysql.user SET Password = PASSWORD('${pwd1}') WHERE USER='root'"
	"${ROOT}/usr/bin/mysql" \
		--socket=${socket} \
		-hlocalhost \
		-e "${sql}"

	einfo "Loading \"zoneinfo\", this step may require a few seconds ..."

	"${ROOT}/usr/bin/mysql" \
		--socket=${socket} \
		-hlocalhost \
		-uroot \
		-p"${pwd1}" \
		mysql < "${sqltmp}"

	# Stop the server and cleanup
	kill $(< "${pidfile}" )
	rm -f "${sqltmp}"
	einfo "Stopping the server ..."
	wait %1
	einfo "Done"
}

pkg_postrm() {
	: # mysql_lib_symlinks "${D}"
}

src_test() {
	make check || die "make check failed"
	if ! use "minimal" ; then
		cd "${S}"
		einfo ">>> Test phase [test]: ${CATEGORY}/${PF}"
		local retstatus
		local t
		addpredict /this-dir-does-not-exist/t9.MYI

		# mysqladmin start before dir creation
		mkdir -p "${S}"/mysql-test/var{,/log}

		if ! hasq "userpriv" ${FEATURES} ; then
			mysql_disable_test	"im_daemon_life_cycle"	"fails as root"
			mysql_disable_test	"im_life_cycle"			"fails as root"
			mysql_disable_test	"im_options_set"		"fails as root"
			mysql_disable_test	"im_options_unset"		"fails as root"
			mysql_disable_test	"im_utils"				"fails as root"
		fi

		for t in \
		loaddata_autocom_ndb \
		ndb_{alter_table{,2},autodiscover{,2,3},basic,bitfield,blob} \
		ndb_{cache{,2},cache_multi{,2},charset,condition_pushdown,config} \
		ndb_{database,gis,index,index_ordered,index_unique,insert,limit} \
		ndb_{loaddatalocal,lock,minmax,multi,read_multi_range,rename,replace} \
		ndb_{restore,subquery,transaction,trigger,truncate,types,update} \
		ps_7ndb rpl_ndb_innodb_trans strict_autoinc_5ndb \
		mysql_upgrade
		do
			mysql_disable_test	"${t}"	"fails with sandbox enabled"
		done

		use "extraengine" && mysql_disable_test "federated" "fails with extraengine USE"
		use "ssl" && mysql_disable_test "ssl_des" "fails requiring PEM passphrase"

		make test-force
		retstatus=$?

		# Just to be sure ;)
		pkill -9 -f "${S}/ndb" 2>/dev/null
		pkill -9 -f "${S}/sql" 2>/dev/null
		[[ $retstatus -eq 0 ]] || die "make test failed"
	else
		einfo "Skipping server tests due to minimal build."
	fi
}
