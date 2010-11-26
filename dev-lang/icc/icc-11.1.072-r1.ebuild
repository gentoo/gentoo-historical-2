# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/icc/icc-11.1.072-r1.ebuild,v 1.1 2010/11/26 13:20:12 jlec Exp $

EAPI="3"

inherit rpm versionator check-reqs

PB=cproc
PACKAGEID="l_${PB}_p_${PV}"
RELEASE="$(get_version_component_range 1-2)"
BUILD="$(get_version_component_range 3)"
PID=1768

DESCRIPTION="Intel compiler suite for Linux"
HOMEPAGE="http://www.intel.com/software/products/compilers/clin/"
SRC_COM="http://registrationcenter-download.intel.com/irc_nas/${PID}/${PACKAGEID}"
SRC_URI="amd64? ( ${SRC_COM}_intel64.tgz )
	ia64? ( ${SRC_COM}_ia64.tgz )
	x86?  ( ${SRC_COM}_ia32.tgz )"

LICENSE="Intel-SDP"
SLOT="0"
IUSE="eclipse +idb ipp mkl"
KEYWORDS="~amd64 ~ia64 ~x86 ~amd64-linux ~x86-linux"

RESTRICT="mirror"

DEPEND=""
RDEPEND="~virtual/libstdc++-3.3
	amd64? ( app-emulation/emul-linux-x86-compat )
	eclipse? ( >=dev-util/eclipse-sdk-3.4 )"

DESTINATION="opt/intel/Compiler/${RELEASE}/${BUILD}"
EDESTINATION="${EROOT#/}${DESTINATION}"

QA_TEXTRELS="${EDESTINATION}/*"
QA_EXECSTACK="${EDESTINATION}/*"
QA_PRESTRIPPED="${EDESTINATION}/lib/*/.*libFNP.so ${EDESTINATION}/bin/*/.* ${EDESTINATION}/idb/*/*/.*"
QA_DT_HASH="
	${EDESTINATION}/bin/*/.*
	${EDESTINATION}/lib/*/.*
	${EDESTINATION}/mkl/lib/*/.*
	${EDESTINATION}/mkl/benchmarks/mp_linpack/bin_intel/*/.*
	${EDESTINATION}/idb/*/*/.*"

pkg_setup() {
	CHECKREQS_MEMORY=1024
	CHECKREQS_DISK_BUILD=2048
	use idb && use ipp && use mkl && CHECKREQS_DISK_BUILD=3072
	check_reqs
	IARCH=ia32
	use amd64 && IARCH=intel64
	use ia64 && IARCH=ia64
}

src_unpack() {
	unpack ${A}
	mv "${WORKDIR}"/l_* "${S}"
	cd "${S}"
	# tbb is open source, thus built from sources in dev-cpp/tbb
	rm -f rpm/*tbb*.rpm
	use idb || rm -f rpm/*idb*.rpm
	use ipp || rm -f rpm/*ipp*.rpm
	use mkl || rm -f rpm/*mkl*.rpm
	use eclipse || rm -f rpm/*cdt*.rpm
	if has_version "~dev-lang/ifc-${PV}"; then
		rm -f rpm/*cprolib*.rpm
		use idb && built_with_use dev-lang/ifc idb && rm -f rpm/*idb*.rpm
		use mkl && built_with_use dev-lang/ifc mkl && rm -f rpm/*mkl*.rpm
	fi
	for x in rpm/intel*.rpm; do
		einfo "Extracting $(basename ${x})..."
		rpm_unpack ./${x} || die "rpm_unpack ${x} failed"
	done
}

link_eclipse_plugins() {
	ECLIPSE_V="$1"
	CDT_V="$2"
	einfo "Linking eclipse (v${ECLIPSE_V}) plugin cdt (v${CDT_V})"
	dodir /usr/$(get_libdir)/eclipse-${ECLIPSE_V}/plugins
	dodir /usr/$(get_libdir)/eclipse-${ECLIPSE_V}/features

	for f in "${DESTINATION}/eclipse_support/cdt${CDT_V}/eclipse/plugins"/*; do
		dosym "${EROOT}${f}" /usr/$(get_libdir)/eclipse-${ECLIPSE_V}/plugins
	done

	for f in "${DESTINATION}/eclipse_support/cdt${CDT_V}/eclipse/features"/*; do
		dosym "${EROOT}${f}" /usr/$(get_libdir)/eclipse-${ECLIPSE_V}/features
	done
	eend $?
}

src_prepare() {
	# from the PURGE_UB804_FNP in pset/install_cc.sh
	# rm -f "${DESTINATION}"/lib/*/*libFNP.so || die

	# extract the tag function from the original install
	sed -n \
		-e "s|find \$DESTINATION|find ${DESTINATION}|g" \
		-e "s|@\$DESTINATION|@${EROOT}${DESTINATION}|g" \
		-e '/^UNTAG_CFG_FILES[[:space:]]*(/,/^}/p' \
		pset/install_cc.sh > tag.sh || die
	# fix world writeable files
	[[ -d ${DESTINATION}/mkl ]] && chmod 644 \
		${DESTINATION}/mkl/tools/{environment,builder}/* \
		${DESTINATION}/mkl/tools/plugins/*/*
	# remove for collision (bug #288038)
	has_version "~dev-lang/ifc-${PV}" && \
		rm -f ${DESTINATION}/lib/*/locale/*/flexnet.cat
}

src_install() {
	einfo "Tagging"
	. ./tag.sh
	UNTAG_CFG_FILES

	keepdir /opt/intel/licenses
	einfo "Copying files"
	dodir "/${DESTINATION}"
	cp -pPR \
		${DESTINATION}/* \
		"${ED}"/${DESTINATION}/ \
		|| die "Copying ${PN} failed"

	local envf=05icfc
	cat > ${envf} <<-EOF
		PATH="${EROOT}${DESTINATION}/bin/${IARCH}"
		ROOTPATH="${EROOT}${DESTINATION}/bin/${IARCH}"
		LDPATH="${EROOT}${DESTINATION}/lib/${IARCH}:${EROOT}${DESTINATION}/idb/lib/${IARCH}"
		LIBRARY_PATH="${EROOT}${DESTINATION}/lib/${IARCH}:${EROOT}${DESTINATION}/idb/lib/${IARCH}"
		NLSPATH="${EROOT}${DESTINATION}/lib/locale/en_US/%N"
		MANPATH="${EROOT}${DESTINATION}/man/en_US"
	EOF
	if [[ ! -e "${EROOT}"etc/env.d/${envf} ]] ||
		[[ -n $(diff "${EROOT}"etc/env.d/${envf} ./${envf}) ]]; then
		doenvd ${envf} || die "doenvd ${envf} failed"
	fi
	[[ -d ${DESTINATION}/idb ]] && \
		dosym ../../common/com.intel.debugger.help_1.0.0 \
		${DESTINATION}/idb/gui/${IARCH}/plugins

	if use eclipse; then
		if has_version 'dev-util/eclipse-sdk:3.4'; then
			link_eclipse_plugins "3.4" "5.0" || die
		fi
		if has_version 'dev-util/eclipse-sdk:3.5'; then
			link_eclipse_plugins "3.5" "6.0" || die
		fi
	fi
}

pkg_postinst() {
	elog "Make sure you have recieved the an Intel license."
	elog "To receive a non-commercial license, you need to register at:"
	elog "http://software.intel.com/en-us/articles/non-commercial-software-development/"
	elog "Install the license file into ${EROOT}opt/intel/licenses."
}
