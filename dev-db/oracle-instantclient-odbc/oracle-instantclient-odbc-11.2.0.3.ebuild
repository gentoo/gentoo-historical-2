# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/oracle-instantclient-odbc/oracle-instantclient-odbc-11.2.0.3.ebuild,v 1.1 2012/03/07 14:23:05 haubi Exp $

EAPI="4"

inherit eutils

MY_PLAT_x86="Linux x86"
MY_A_x86="${PN/oracle-/}-linux-${PV}.0.zip"

MY_PLAT_amd64="Linux x86-64"
MY_A_amd64="${PN/oracle-/}-linux.x64-${PV}.0.zip"

DESCRIPTION="Oracle 11g Instant Client: ODBC supplement"
HOMEPAGE="http://www.oracle.com/technetwork/database/features/instant-client/index.html"
SRC_URI="
	x86?   ( ${MY_A_x86}                             )
	amd64? ( ${MY_A_amd64} multilib? ( ${MY_A_x86} ) )
"

LICENSE="OTN"
SLOT="0"
KEYWORDS="~x86 ~amd64"
RESTRICT="fetch"
IUSE="multilib"

DEPEND="app-arch/unzip"
RDEPEND="~dev-db/oracle-instantclient-basic-${PV}"

S="${WORKDIR}"

default_abi() {
	[[ ${DEFAULT_ABI} == 'default' ]] && echo ${ARCH} || echo ${DEFAULT_ABI}
}

abi_list() {
	if use multilib; then
		echo ${MULTILIB_ABIS}
	elif [[ ${DEFAULT_MULTILIB} == default ]]; then
		# no multilib-able platform
		echo ${ARCH}
	else
		echo ${DEFAULT_ABI}
	fi
	return 0
}

set_abivars() {
	local abi=$1
	# platform name
	MY_PLAT=MY_PLAT_${abi}
	MY_PLAT=${!MY_PLAT}
	# runtime distfile
	MY_A=MY_A_${abi}
	MY_A=${!MY_A}
	# abi sourcedir
	MY_S="${S}/${abi}/instantclient_11_2"
	# abi libdir
	MY_LIBDIR=$(ABI=${abi} get_libdir)
}

pkg_nofetch() {
	eerror "Please go to"
	eerror "  ${HOMEPAGE%/*}/index-097480.html"
	eerror "  and download"
	local abi
	for abi in $(abi_list)
	do
		set_abivars ${abi}
		eerror "Instant Client for ${MY_PLAT}"
		eerror "    ODBC: ${MY_A}"
	done
	eerror "After downloading, put them in:"
	eerror "    ${DISTDIR}/"
}

src_unpack() {
	local abi
	for abi in $(abi_list)
	do
		set_abivars ${abi}
		mkdir -p "${MY_S%/*}" || die
		cd "${MY_S%/*}" || die
		unpack ${MY_A}
	done
}

src_install() {
	# all binaries go here
	local oracle_home=/usr/$(get_libdir)/oracle/${PV}/client
	into "${oracle_home}"

	local abi
	for abi in $(abi_list)
	do
		set_abivars ${abi}
		einfo "Installing runtime for ${MY_PLAT} ..."

		cd "${MY_S}" || die

		ABI=${abi} dolib.so libsqora*$(get_libname)*

		# ensure to be linkable
		[[ -e libsqora$(get_libname) ]] ||
		dosym libsqora$(get_libname 11.1) \
			"${oracle_home}"/${MY_LIBDIR}/libsqora$(get_libname)

		eend $?
	done

	set_abivars $(default_abi)
	cd "${MY_S}" || die
	dobin odbc_update_ini.sh
	dodoc *htm*
}
