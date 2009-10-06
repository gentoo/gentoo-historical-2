# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/ifc/ifc-11.1.056.ebuild,v 1.1 2009/10/06 20:43:45 bicatali Exp $

EAPI=2

inherit rpm versionator check-reqs

PB=cprof
PACKAGEID="l_${PB}_p_${PV}"
RELEASE="$(get_version_component_range 1-2)"
BUILD="$(get_version_component_range 3)"
PID=1582

DESCRIPTION="Intel FORTRAN compiler suite for Linux"
HOMEPAGE="http://www.intel.com/software/products/compilers/clin/"
SRC_COM="http://registrationcenter-download.intel.com/irc_nas/${PID}/${PACKAGEID}"
SRC_URI="amd64? ( ${SRC_COM}_intel64.tgz )
	ia64? ( ${SRC_COM}_ia64.tgz )
	x86?  ( ${SRC_COM}_ia32.tgz )"

LICENSE="Intel-SDP"
SLOT="0"
IUSE="idb +mkl"
KEYWORDS="~amd64 ~ia64 ~x86"

RESTRICT="mirror strip binchecks"

DEPEND=""
RDEPEND="~virtual/libstdc++-3.3
	amd64? ( app-emulation/emul-linux-x86-compat )"

DESTINATION="opt/intel/Compiler/${RELEASE}/${BUILD}"

pkg_setup() {
	CHECKREQS_MEMORY=1024
	CHECKREQS_DISK_BUILD=1536
	use idb && use mkl && CHECKREQS_DISK_BUILD=2048
	check_reqs
	IARCH=ia32
	use amd64 && IARCH=intel64
	use ia64 && IARCH=ia64
}

src_unpack() {
	unpack ${A}
	mv "${WORKDIR}"/l_* "${S}"
	cd "${S}"
	use idb || rm -f rpm/*idb*.rpm
	use mkl || rm -f rpm/*mkl*.rpm
	if has_version "~dev-lang/icc-${PV}"; then
		rm -f rpm/*cprolib*.rpm
		use idb && built_with_use dev-lang/icc idb && rm -f rpm/*idb*.rpm
		use mkl && built_with_use dev-lang/icc mkl && rm -f rpm/*mkl*.rpm
	fi
	for x in rpm/intel*.rpm; do
		einfo "Extracting $(basename ${x})..."
		rpm_unpack ./${x} || die "rpm_unpack ${x} failed"
	done
}

src_prepare() {
	# from the PURGE_UB804_FNP in pset/install_fc.sh
	# rm -f "${DESTINATION}"/lib/*/*libFNP.so || die

	# extract the tag function from the original install
	sed -n \
		-e "s|find \$DESTINATION|find ${DESTINATION}|g" \
		-e "s|@\$DESTINATION|@${ROOT}${DESTINATION}|g" \
		-e '/^UNTAG_CFG_FILES[[:space:]]*(/,/^}/p' \
		pset/install_fc.sh > tag.sh || die
	# fix world writeable files
	[ -d ${DESTINATION}/mkl ]  && chmod 644 \
		${DESTINATION}/mkl/tools/{environment,builder}/* \
		${DESTINATION}/mkl/tools/plugins/*/*
}

src_install() {
	einfo "Tagging"
	. ./tag.sh
	UNTAG_CFG_FILES

	keepdir /opt/intel/licenses
	einfo "Copying files"
	dodir "${DESTINATION}"
	cp -pPR \
		${DESTINATION}/* \
		"${D}"/${DESTINATION}/ \
		|| die "Copying ${PN} failed"

	local envf=05icfc
	cat > ${envf} <<-EOF
		PATH="${ROOT}${DESTINATION}/bin/${IARCH}"
		ROOTPATH="${ROOT}${DESTINATION}/bin/${IARCH}"
		LDPATH="${ROOT}${DESTINATION}/lib/${IARCH}"
		LIBRARY_PATH="${ROOT}${DESTINATION}/lib/${IARCH}"
		NLSPATH="${ROOT}${DESTINATION}/lib/locale/en_US/%N"
		MANPATH="${ROOT}${DESTINATION}/man/en_US"
	EOF
	if [ -n "$(diff ${ROOT}etc/env.d/${envf} ./${envf})" ]; then
		doenvd ${envf} || die "doenvd ${envf} failed"
	fi
	[ -d ${DESTINATION}/idb ] && \
		dosym ../../common/com.intel.debugger.help_1.0.0 \
		${DESTINATION}/idb/gui/${IARCH}/plugins
}

pkg_postinst() {
	elog "Make sure you have recieved the an Intel license."
	elog "To receive a non-commercial license, you need to register at:"
	elog "http://software.intel.com/en-us/articles/non-commercial-software-development/"
	elog "Install the license file into ${ROOT}opt/intel/licenses."
}
