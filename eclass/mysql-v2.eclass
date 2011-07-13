# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/mysql-v2.eclass,v 1.1 2011/07/13 07:01:47 robbat2 Exp $

# @ECLASS: mysql-v2.eclass
# @MAINTAINER:
# Maintainers:
#	- MySQL Team <mysql-bugs@gentoo.org>
#	- Robin H. Johnson <robbat2@gentoo.org>
#	- Jorge Manuel B. S. Vicetto <jmbsvicetto@gentoo.org>
# @BLURB: This eclass provides most of the functions for mysql ebuilds
# @DESCRIPTION:
# The mysql-v2.eclass is the base eclass to build the mysql and
# alternative projects (mariadb) ebuilds.
# This eclass uses the mysql-autotools and mysql-cmake eclasses for the
# specific bits related to the build system.
# It provides the src_unpack, src_prepare, src_configure, src_compile,
# scr_install, pkg_preinst, pkg_postinst, pkg_config and pkg_postrm
# phase hooks.

# @ECLASS-VARIABLE: BUILD
# @DESCRIPTION: Build type of the mysql version
# The default value is autotools
: ${BUILD:=autotools}

case ${BUILD} in
	"cmake")
		BUILD_INHERIT="mysql-cmake"
		;;
	"autotools")
		BUILD_INHERIT="mysql-autotools"

		WANT_AUTOCONF="latest"
		WANT_AUTOMAKE="latest"
		;;
	*)
		die "${BUILD} is not a valid build system for mysql"
		;;
esac

MYSQL_EXTRAS=""

# @ECLASS-VARIABLE: MYSQL_EXTRAS_VER
# @DESCRIPTION: The version of the MYSQL_EXTRAS repo to use to build mysql
[[ "${MY_EXTRAS_VER}" == "live" ]] && MYSQL_EXTRAS="git-2"

inherit eutils flag-o-matic gnuconfig ${MYSQL_EXTRAS} ${BUILD_INHERIT} mysql_fx versionator toolchain-funcs

#
# Supported EAPI versions and export functions
#

case "${EAPI:-0}" in
	2|3|4) ;;
	*) die "Unsupported EAPI: ${EAPI}" ;;
esac

EXPORT_FUNCTIONS src_unpack src_prepare src_configure src_compile src_install

#
# VARIABLES:
#

# Shorten the path because the socket path length must be shorter than 107 chars
# and we will run a mysql server during test phase
S="${WORKDIR}/mysql"

[[ "${MY_EXTRAS_VER}" == "latest" ]] && MY_EXTRAS_VER="20090228-0714Z"
if [[ "${MY_EXTRAS_VER}" == "live" ]]; then
	EGIT_PROJECT=mysql-extras
	EGIT_REPO_URI="git://git.overlays.gentoo.org/proj/mysql-extras.git"
fi

# @ECLASS-VARIABLE: MYSQL_PV_MAJOR
# @DESCRIPTION:
# Upstream MySQL considers the first two parts of the version number to be the
# major version. Upgrades that change major version should always run
# mysql_upgrade.
MYSQL_PV_MAJOR="$(get_version_component_range 1-2 ${PV})"

# Cluster is a special case...
if [[ "${PN}" == "mysql-cluster" ]]; then
	case $PV in
		6.1*|7.0*|7.1*) MYSQL_PV_MAJOR=5.1 ;;
	esac
fi


# @ECLASS-VARIABLE: MYSQL_VERSION_ID
# @DESCRIPTION:
# MYSQL_VERSION_ID will be:
# major * 10e6 + minor * 10e4 + micro * 10e2 + gentoo revision number, all [0..99]
# This is an important part, because many of the choices the MySQL ebuild will do
# depend on this variable.
# In particular, the code below transforms a $PVR like "5.0.18-r3" in "5001803"
# We also strip off upstream's trailing letter that they use to respin tarballs
MYSQL_VERSION_ID=""
tpv="${PV%[a-z]}"
tpv=( ${tpv//[-._]/ } ) ; tpv[3]="${PVR:${#PV}}" ; tpv[3]="${tpv[3]##*-r}"
for vatom in 0 1 2 3 ; do
	# pad to length 2
	tpv[${vatom}]="00${tpv[${vatom}]}"
	MYSQL_VERSION_ID="${MYSQL_VERSION_ID}${tpv[${vatom}]:0-2}"
done
# strip leading "0" (otherwise it's considered an octal number by BASH)
MYSQL_VERSION_ID=${MYSQL_VERSION_ID##"0"}

# This eclass should only be used with at least mysql-5.1.50
mysql_version_is_at_least "5.1.50" || die "This eclass should only be used with >=mysql-5.1.50"

# @ECLASS-VARIABLE: MYSQL_COMMUNITY_FEATURES
# @DESCRIPTION:
# Specifiy if community features are available. Possible values are 1 (yes)
# and 0 (no).
# Community features are available in mysql-community
# AND in the re-merged mysql-5.0.82 and newer
if [ "${PN}" == "mysql-community" -o "${PN}" == "mariadb" ]; then
	MYSQL_COMMUNITY_FEATURES=1
elif [ "${MYSQL_PV_MAJOR}" == "5.1" ]; then
	MYSQL_COMMUNITY_FEATURES=1
elif mysql_version_is_at_least "5.4.0"; then
	MYSQL_COMMUNITY_FEATURES=1
else
	MYSQL_COMMUNITY_FEATURES=0
fi


# @ECLASS-VARIABLE: XTRADB_VER
# @DEFAULT_UNSET
# @DESCRIPTION:
# Version of the XTRADB storage engine

# @ECLASS-VARIABLE: PERCONA_VER
# @DEFAULT_UNSET
# @DESCRIPTION:
# Designation by PERCONA for a MySQL version to apply an XTRADB release

# Work out the default SERVER_URI correctly
if [ -z "${SERVER_URI}" ]; then
	[ -z "${MY_PV}" ] && MY_PV="${PV//_/-}"
	if [ "${PN}" == "mariadb" ]; then
		MARIA_FULL_PV="$(replace_version_separator 3 '-' ${PV})"
		MARIA_FULL_P="${PN}-${MARIA_FULL_PV}"
		SERVER_URI="
		http://ftp.osuosl.org/pub/mariadb/${MARIA_FULL_P}/kvm-tarbake-jaunty-x86/${MARIA_FULL_P}.tar.gz
		http://ftp.rediris.es/mirror/MariaDB/${MARIA_FULL_P}/kvm-tarbake-jaunty-x86/${MARIA_FULL_P}.tar.gz
		http://maria.llarian.net/download/${MARIA_FULL_P}/kvm-tarbake-jaunty-x86/${MARIA_FULL_P}.tar.gz
		http://launchpad.net/maria/${MYSQL_PV_MAJOR}/ongoing/+download/${MARIA_FULL_P}.tar.gz
		http://mirrors.fe.up.pt/pub/${PN}/${MARIA_FULL_P}/kvm-tarbake-jaunty-x86/${MARIA_FULL_P}.tar.gz
		http://ftp-stud.hs-esslingen.de/pub/Mirrors/${PN}/${MARIA_FULL_P}/kvm-tarbake-jaunty-x86/${MARIA_FULL_P}.tar.gz
		"
	# The community and cluster builds are on the mirrors
	elif [[ "${MYSQL_COMMUNITY_FEATURES}" == "1" || ${PN} == "mysql-cluster" ]] ; then
		if [[ "${PN}" == "mysql-cluster" ]] ; then
			URI_DIR="MySQL-Cluster"
			URI_FILE="mysql-cluster-gpl"
		else
			URI_DIR="MySQL"
			URI_FILE="mysql"
		fi
		URI_A="${URI_FILE}-${MY_PV}.tar.gz"
		MIRROR_PV=$(get_version_component_range 1-2 ${PV})
		# Recently upstream switched to an archive site, and not on mirrors
		SERVER_URI="http://downloads.mysql.com/archives/${URI_FILE}-${MIRROR_PV}/${URI_A}
					mirror://mysql/Downloads/${URI_DIR}-${PV%.*}/${URI_A}"
	# The (old) enterprise source is on the primary site only
	elif [ "${PN}" == "mysql" ]; then
		SERVER_URI="ftp://ftp.mysql.com/pub/mysql/src/mysql-${MY_PV}.tar.gz"
	fi
fi

# Define correct SRC_URIs
SRC_URI="${SERVER_URI}"

# Gentoo patches to MySQL
[[ ${MY_EXTRAS_VER} != live ]] \
&& SRC_URI="${SRC_URI}
		mirror://gentoo/mysql-extras-${MY_EXTRAS_VER}.tar.bz2
		http://g3nt8.org/patches/mysql-extras-${MY_EXTRAS_VER}.tar.bz2
		http://dev.gentoo.org/~robbat2/distfiles/mysql-extras-${MY_EXTRAS_VER}.tar.bz2"

DESCRIPTION="A fast, multi-threaded, multi-user SQL database server."
HOMEPAGE="http://www.mysql.com/"
if [[ "${PN}" == "mariadb" ]]; then
	HOMEPAGE="http://mariadb.org/"
	DESCRIPTION="MariaDB is a MySQL fork with 3rd-party patches and additional storage engines merged."
fi
if [[ "${PN}" == "mysql-community" ]]; then
	DESCRIPTION="${DESCRIPTION} (obsolete, move to dev-db/mysql)"
fi
LICENSE="GPL-2"
SLOT="0"

case "${BUILD}" in
	"autotools")
		IUSE="big-tables debug embedded minimal +perl selinux ssl static test"
		;;
	"cmake")
		IUSE="debug embedded minimal +perl selinux ssl static test"
		;;
esac

IUSE="${IUSE} latin1"

IUSE="${IUSE} extraengine"
if [[ ${PN} != "mysql-cluster" ]] ; then
	IUSE="${IUSE} cluster"
fi

IUSE="${IUSE} max-idx-128"
IUSE="${IUSE} berkdb"

[[ ${MYSQL_COMMUNITY_FEATURES} == 1 ]] \
&& IUSE="${IUSE} +community profiling"

[[ ${PN} == "mariadb" ]] \
&& IUSE="${IUSE} libevent"

[[ ${PN} == "mariadb" ]] \
&& mysql_version_is_at_least "5.2" \
&& IUSE="${IUSE} oqgraph"

[[ ${PN} == "mariadb" ]] \
&& mysql_version_is_at_least "5.2.5" \
&& IUSE="${IUSE} sphinx"


#
# DEPENDENCIES:
#

# Be warned, *DEPEND are version-dependant
# These are used for both runtime and compiletime
DEPEND="
	ssl? ( >=dev-libs/openssl-0.9.6d )
	userland_GNU? ( sys-process/procps )
	>=sys-apps/sed-4
	>=sys-apps/texinfo-4.7-r1
	>=sys-libs/readline-4.1
	>=sys-libs/zlib-1.2.3
"

[[ ${PN} == mariadb ]] \
&& DEPEND="${DEPEND} libevent? ( >=dev-libs/libevent-1.4 )"

# Having different flavours at the same time is not a good idea
for i in "mysql" "mysql-community" "mysql-cluster" "mariadb" ; do
	[[ ${i} == ${PN} ]] ||
	DEPEND="${DEPEND} !dev-db/${i}"
done

RDEPEND="${DEPEND}
	!minimal? ( dev-db/mysql-init-scripts )
	selinux? ( sec-policy/selinux-mysql )
"

DEPEND="${DEPEND} static? ( || ( sys-libs/ncurses[static-libs] <=sys-libs/ncurses-5.7-r3 ) )"

# compile-time-only
DEPEND="${DEPEND} >=dev-util/cmake-2.4.3"

# compile-time-only
mysql_version_is_at_least "5.5.8" \
&& DEPEND="${DEPEND} >=dev-util/cmake-2.6.3"

[[ "${PN}" == "mariadb" ]] \
&& mysql_version_is_at_least "5.2" \
&& DEPEND="${DEPEND} oqgraph? ( >=dev-libs/boost-1.40.0 )"

[[ "${PN}" == "mariadb" ]] \
&& mysql_version_is_at_least "5.2.5" \
&& DEPEND="${DEPEND} sphinx? ( app-misc/sphinx )"

# dev-perl/DBD-mysql is needed by some scripts installed by MySQL
PDEPEND="perl? ( >=dev-perl/DBD-mysql-2.9004 )"

# For other stuff to bring us in
PDEPEND="${PDEPEND} =virtual/mysql-${MYSQL_PV_MAJOR}"


#
# External patches
#

# MariaDB has integrated PBXT
# PBXT_VERSION means that we have a PBXT patch for this PV
# PBXT was only introduced after 5.1.12
pbxt_patch_available() {
	[[ ${PN} != "mariadb" ]] \
	&& [[ -n "${PBXT_VERSION}" ]]
	return $?
}

pbxt_available() {
	pbxt_patch_available || [[ ${PN} == "mariadb" ]]
	return $?
}

# Get the percona tarball if XTRADB_VER and PERCONA_VER are both set
# MariaDB has integrated XtraDB
# XTRADB_VERS means that we have a XTRADB patch for this PV
# XTRADB was only introduced after 5.1.26
xtradb_patch_available() {
	[[ ${PN} != "mariadb" ]] \
	&& [[ -n "${XTRADB_VER}" && -n "${PERCONA_VER}" ]]
	return $?
}


if pbxt_patch_available; then

	PBXT_P="pbxt-${PBXT_VERSION}"
	PBXT_SRC_URI="http://www.primebase.org/download/${PBXT_P}.tar.gz mirror://sourceforge/pbxt/${PBXT_P}.tar.gz"
	SRC_URI="${SRC_URI} pbxt? ( ${PBXT_SRC_URI} )"

	# PBXT_NEWSTYLE means pbxt is in storage/ and gets enabled as other plugins
	# vs. built outside the dir
	if pbxt_available; then

		IUSE="${IUSE} pbxt"
		PBXT_NEWSTYLE=1
	fi
fi

if xtradb_patch_available; then
	XTRADB_P="percona-xtradb-${XTRADB_VER}"
	XTRADB_SRC_URI_COMMON="${PERCONA_VER}/source/${XTRADB_P}.tar.gz"
	XTRADB_SRC_B1="http://www.percona.com/"
	XTRADB_SRC_B2="${XTRADB_SRC_B1}/percona-builds/"
	XTRADB_SRC_URI1="${XTRADB_SRC_B2}/Percona-Server/Percona-Server-${XTRADB_SRC_URI_COMMON}"
	XTRADB_SRC_URI2="${XTRADB_SRC_B2}/xtradb/${XTRADB_SRC_URI_COMMON}"
	XTRADB_SRC_URI3="${XTRADB_SRC_B1}/${PN}/xtradb/${XTRADB_SRC_URI_COMMON}"
	SRC_URI="${SRC_URI} xtradb? ( ${XTRADB_SRC_URI1} ${XTRADB_SRC_URI2} ${XTRADB_SRC_URI3} )"
	IUSE="${IUSE} xtradb"
fi

#
# HELPER FUNCTIONS:
#

# @FUNCTION: mysql-v2_disable_test
# @DESCRIPTION:
# Helper function to disable specific tests.
mysql-v2_disable_test() {
	${BUILD_INHERIT}_disable_test "$@"
}

# @FUNCTION: mysql-v2_configure_minimal
# @DESCRIPTION:
# Helper function to configure minimal build
configure_minimal() {
	${BUILD_INHERIT}_configure_minimal "$@"
}

# @FUNCTION: mysql-v2_configure_common
# @DESCRIPTION:
# Helper function to configure common builds
configure_common() {
	${BUILD_INHERIT}_configure_common "$@"
}

#
# EBUILD FUNCTIONS
#

# @FUNCTION: mysql-v2_pkg_setup
# @DESCRIPTION:
# Perform some basic tests and tasks during pkg_setup phase:
#   die if FEATURES="test", USE="-minimal" and not using FEATURES="userpriv"
#   check for conflicting use flags
#   create new user and group for mysql
#   warn about deprecated features
mysql-v2_pkg_setup() {

	if has test ${FEATURES} ; then
		if ! use minimal ; then
			if [[ $UID -eq 0 ]]; then
				eerror "Testing with FEATURES=-userpriv is no longer supported by upstream. Tests MUST be run as non-root."
			fi
		fi
	fi

	# Check for USE flag problems in pkg_setup
	if use static && use ssl ; then
		M="MySQL does not support being built statically with SSL support enabled!"
		eerror "${M}"
		die "${M}"
	fi

	if ! mysql_version_is_at_least "5.2" \
		&& use debug ; then
		# Also in package.use.mask
		die "Bug #344885: Upstream has broken USE=debug for 5.1 series >=5.1.51"
	fi

	if ( use cluster || use extraengine || use embedded ) \
	&& use minimal ; then
		M="USE flags 'cluster', 'extraengine', 'embedded' conflict with 'minimal' USE flag!"
		eerror "${M}"
		die "${M}"
	fi

	if xtradb_patch_available \
	&& use xtradb \
	&& use embedded ; then
		M="USE flags 'xtradb' and 'embedded' conflict and cause build failures"
		eerror "${M}"
		die "${M}"
	fi

	# This should come after all of the die statements
	enewgroup mysql 60 || die "problem adding 'mysql' group"
	enewuser mysql 60 -1 /dev/null mysql || die "problem adding 'mysql' user"

	if [ "${PN}" != "mysql-cluster" ] && use cluster; then
		ewarn "Upstream has noted that the NDB cluster support in the 5.0 and"
		ewarn "5.1 series should NOT be put into production. In the near"
		ewarn "future, it will be disabled from building."
		ewarn ""
		ewarn "If you need NDB support, you should instead move to the new"
		ewarn "mysql-cluster package that represents that upstream NDB"
		ewarn "development."
	fi
}

# @FUNCTION: mysql-v2_src_unpack
# @DESCRIPTION:
# Unpack the source code
mysql-v2_src_unpack() {

	# Initialize the proper variables first
	mysql_init_vars

	unpack ${A}
	# Grab the patches
	[[ "${MY_EXTRAS_VER}" == "live" ]] && S="${WORKDIR}/mysql-extras" git-2_src_unpack

	mv -f "${WORKDIR}/${MY_SOURCEDIR}" "${S}"
}

# @FUNCTION: mysql-v2_src_prepare
# @DESCRIPTION:
# Apply patches to the source code and remove unneeded bundled libs.
mysql-v2_src_prepare() {
	${BUILD_INHERIT}_src_prepare "$@"
}

# @FUNCTION: mysql-v2_src_configure
# @DESCRIPTION:
# Configure mysql to build the code for Gentoo respecting the use flags.
mysql-v2_src_configure() {
	${BUILD_INHERIT}_src_configure "$@"
}

# @FUNCTION: mysql-v2_src_compile
# @DESCRIPTION:
# Compile the mysql code.
mysql-v2_src_compile() {
	${BUILD_INHERIT}_src_compile "$@"
}

# @FUNCTION: mysql-v2_src_install
# @DESCRIPTION:
# Install mysql.
mysql-v2_src_install() {
	${BUILD_INHERIT}_src_install "$@"
}

# @FUNCTION: mysql-v2_pkg_preinst
# @DESCRIPTION:
# Create the user and groups for mysql - die if that fails.
mysql-v2_pkg_preinst() {
	enewgroup mysql 60 || die "problem adding 'mysql' group"
	enewuser mysql 60 -1 /dev/null mysql || die "problem adding 'mysql' user"
}

# @FUNCTION: mysql-v2_pkg_postinst
# @DESCRIPTION:
# Run post-installation tasks:
#   create the dir for logfiles if non-existant
#   touch the logfiles and secure them
#   install scripts
#   issue required steps for optional features
#   issue deprecation warnings
mysql-v2_pkg_postinst() {

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
			[[ -f "${script}" ]] \
			&& dodoc "${script}"
		done

		docinto "scripts"
		for script in scripts/mysql* ; do
			[[ -f "${script}" ]] \
			&& [[ "${script%.sh}" == "${script}" ]] \
			&& dodoc "${script}"
		done

		einfo
		elog "You might want to run:"
		elog "\"emerge --config =${CATEGORY}/${PF}\""
		elog "if this is a new install."
		einfo

		einfo
		elog "If you are upgrading major versions, you should run the"
		elog "mysql_upgrade tool."
		einfo
	fi

	if pbxt_available && use pbxt ; then
		# TODO: explain it better
		elog "    mysql> INSTALL PLUGIN pbxt SONAME 'libpbxt.so';"
		elog "    mysql> CREATE TABLE t1 (c1 int, c2 text) ENGINE=pbxt;"
		elog "if, after that, you cannot start the MySQL server,"
		elog "remove the ${MY_DATADIR}/mysql/plugin.* files, then"
		elog "use the MySQL upgrade script to restore the table"
		elog "or execute the following SQL command:"
		elog "    CREATE TABLE IF NOT EXISTS plugin ("
		elog "      name char(64) binary DEFAULT '' NOT NULL,"
		elog "      dl char(128) DEFAULT '' NOT NULL,"
		elog "      PRIMARY KEY (name)"
		elog "    ) CHARACTER SET utf8 COLLATE utf8_bin;"
	fi

	mysql_check_version_range "4.0 to 5.0.99.99" \
	&& use berkdb \
	&& elog "Berkeley DB support is deprecated and will be removed in future versions!"
}

# @FUNCTION: mysql-v2_pkg_config
# @DESCRIPTION:
# Configure mysql environment.
mysql-v2_pkg_config() {

	local old_MY_DATADIR="${MY_DATADIR}"

	# Make sure the vars are correctly initialized
	mysql_init_vars

	[[ -z "${MY_DATADIR}" ]] && die "Sorry, unable to find MY_DATADIR"

	if built_with_use ${CATEGORY}/${PN} minimal ; then
		die "Minimal builds do NOT include the MySQL server"
	fi

	if [[ ( -n "${MY_DATADIR}" ) && ( "${MY_DATADIR}" != "${old_MY_DATADIR}" ) ]]; then
		local MY_DATADIR_s="$(strip_duplicate_slashes ${ROOT}/${MY_DATADIR})"
		local old_MY_DATADIR_s="$(strip_duplicate_slashes ${ROOT}/${old_MY_DATADIR})"

		if [[ -d "${old_MY_DATADIR_s}" ]]; then
			if [[ -d "${MY_DATADIR_s}" ]]; then
				ewarn "Both ${old_MY_DATADIR_s} and ${MY_DATADIR_s} exist"
				ewarn "Attempting to use ${MY_DATADIR_s} and preserving ${old_MY_DATADIR_s}"
			else
				elog "Moving MY_DATADIR from ${old_MY_DATADIR_s} to ${MY_DATADIR_s}"
				mv --strip-trailing-slashes -T "${old_MY_DATADIR_s}" "${MY_DATADIR_s}" \
				|| die "Moving MY_DATADIR failed"
			fi
		else
			ewarn "Previous MY_DATADIR (${old_MY_DATADIR_s}) does not exist"
			if [[ -d "${MY_DATADIR_s}" ]]; then
				ewarn "Attempting to use ${MY_DATADIR_s}"
			else
				eerror "New MY_DATADIR (${MY_DATADIR_s}) does not exist"
				die "Configuration Failed!  Please reinstall ${CATEGORY}/${PN}"
			fi
		fi
	fi

	local pwd1="a"
	local pwd2="b"
	local maxtry=15

	if [ -z "${MYSQL_ROOT_PASSWORD}" -a -f "${ROOT}/root/.my.cnf" ]; then
		MYSQL_ROOT_PASSWORD="$(sed -n -e '/^password=/s,^password=,,gp' "${ROOT}/root/.my.cnf")"
	fi

	if [[ -d "${ROOT}/${MY_DATADIR}/mysql" ]] ; then
		ewarn "You have already a MySQL database in place."
		ewarn "(${ROOT}/${MY_DATADIR}/*)"
		ewarn "Please rename or delete it if you wish to replace it."
		die "MySQL database already exists!"
	fi

	# Bug #213475 - MySQL _will_ object strenously if your machine is named
	# localhost. Also causes weird failures.
	[[ "${HOSTNAME}" == "localhost" ]] && die "Your machine must NOT be named localhost"

	if [ -z "${MYSQL_ROOT_PASSWORD}" ]; then

		einfo "Please provide a password for the mysql 'root' user now, in the"
		einfo "MYSQL_ROOT_PASSWORD env var or through the /root/.my.cnf file."
		ewarn "Avoid [\"'\\_%] characters in the password"
		read -rsp "    >" pwd1 ; echo

		einfo "Retype the password"
		read -rsp "    >" pwd2 ; echo

		if [[ "x$pwd1" != "x$pwd2" ]] ; then
			die "Passwords are not the same"
		fi
		MYSQL_ROOT_PASSWORD="${pwd1}"
		unset pwd1 pwd2
	fi

	local options=""
	local sqltmp="$(emktemp)"

	local help_tables="${ROOT}${MY_SHAREDSTATEDIR}/fill_help_tables.sql"
	[[ -r "${help_tables}" ]] \
	&& cp "${help_tables}" "${TMPDIR}/fill_help_tables.sql" \
	|| touch "${TMPDIR}/fill_help_tables.sql"
	help_tables="${TMPDIR}/fill_help_tables.sql"

	pushd "${TMPDIR}" &>/dev/null
	"${ROOT}/usr/bin/mysql_install_db" >"${TMPDIR}"/mysql_install_db.log 2>&1
	if [ $? -ne 0 ]; then
		grep -B5 -A999 -i "ERROR" "${TMPDIR}"/mysql_install_db.log 1>&2
		die "Failed to run mysql_install_db. Please review /var/log/mysql/mysqld.err AND ${TMPDIR}/mysql_install_db.log"
	fi
	popd &>/dev/null
	[[ -f "${ROOT}/${MY_DATADIR}/mysql/user.frm" ]] \
	|| die "MySQL databases not installed"
	chown -R mysql:mysql "${ROOT}/${MY_DATADIR}" 2>/dev/null
	chmod 0750 "${ROOT}/${MY_DATADIR}" 2>/dev/null

	# Figure out which options we need to disable to do the setup
	helpfile="${TMPDIR}/mysqld-help"
	${ROOT}/usr/sbin/mysqld --verbose --help >"${helpfile}" 2>/dev/null
	for opt in grant-tables host-cache name-resolve networking slave-start bdb \
		federated innodb ssl log-bin relay-log slow-query-log external-locking \
		ndbcluster \
		; do
		optexp="--(skip-)?${opt}" optfull="--skip-${opt}"
		egrep -sq -- "${optexp}" "${helpfile}" && options="${options} ${optfull}"
	done
	# But some options changed names
	egrep -sq external-locking "${helpfile}" && \
	options="${options/skip-locking/skip-external-locking}"

	# Filling timezones, see
	# http://dev.mysql.com/doc/mysql/en/time-zone-support.html
	"${ROOT}/usr/bin/mysql_tzinfo_to_sql" "${ROOT}/usr/share/zoneinfo" > "${sqltmp}" 2>/dev/null

	if [[ -r "${help_tables}" ]] ; then
		cat "${help_tables}" >> "${sqltmp}"
	fi

	einfo "Creating the mysql database and setting proper"
	einfo "permissions on it ..."

	local socket="${ROOT}/var/run/mysqld/mysqld${RANDOM}.sock"
	local pidfile="${ROOT}/var/run/mysqld/mysqld${RANDOM}.pid"
	local mysqld="${ROOT}/usr/sbin/mysqld \
		${options} \
		--user=mysql \
		--basedir=${ROOT}/usr \
		--datadir=${ROOT}/${MY_DATADIR} \
		--max_allowed_packet=8M \
		--net_buffer_length=16K \
		--default-storage-engine=MyISAM \
		--socket=${socket} \
		--pid-file=${pidfile}"
	#einfo "About to start mysqld: ${mysqld}"
	ebegin "Starting mysqld"
	${mysqld} &
	rc=$?
	while ! [[ -S "${socket}" || "${maxtry}" -lt 1 ]] ; do
		maxtry=$((${maxtry}-1))
		echo -n "."
		sleep 1
	done
	eend $rc

	if ! [[ -S "${socket}" ]]; then
		die "Completely failed to start up mysqld with: ${mysqld}"
	fi

	ebegin "Setting root password"
	# Do this from memory, as we don't want clear text passwords in temp files
	local sql="UPDATE mysql.user SET Password = PASSWORD('${MYSQL_ROOT_PASSWORD}') WHERE USER='root'"
	"${ROOT}/usr/bin/mysql" \
		--socket=${socket} \
		-hlocalhost \
		-e "${sql}"
	eend $?

	ebegin "Loading \"zoneinfo\", this step may require a few seconds ..."
	"${ROOT}/usr/bin/mysql" \
		--socket=${socket} \
		-hlocalhost \
		-uroot \
		-p"${MYSQL_ROOT_PASSWORD}" \
		mysql < "${sqltmp}"
	rc=$?
	eend $?
	[ $rc -ne 0 ] && ewarn "Failed to load zoneinfo!"

	# Stop the server and cleanup
	einfo "Stopping the server ..."
	kill $(< "${pidfile}" )
	rm -f "${sqltmp}"
	wait %1
	einfo "Done"
}

# @FUNCTION: mysql-v2_pkg_postrm
# @DESCRIPTION:
# Remove mysql symlinks.
mysql-v2_pkg_postrm() {

	: # mysql_lib_symlinks "${D}"
}
