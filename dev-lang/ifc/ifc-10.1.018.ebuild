# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/ifc/ifc-10.1.018.ebuild,v 1.5 2011/09/03 19:08:50 dilfridge Exp $

inherit rpm eutils check-reqs

PID=1208
PB=fc
PEXEC="ifort"
DESCRIPTION="Intel FORTRAN 77/95 optimized compiler for Linux"
HOMEPAGE="http://software.intel.com/en-us/articles/fortran-compilers/"

###
# everything below common to ifc and icc
# no eclass: very likely to change for next versions
###
PACKID="l_${PB}_p_${PV}"
KEYWORDS="~amd64 ~ia64 ~x86"
SRC_COM="http://registrationcenter-download.intel.com/irc_nas/${PID}/${PACKID}"
SRC_URI="amd64? ( ${SRC_COM}_intel64.tar.gz )
	ia64? ( ${SRC_COM}_ia64.tar.gz )
	x86?  ( ${SRC_COM}_ia32.tar.gz )"

LICENSE="Intel-SDP"
SLOT="0"

RESTRICT="test mirror"
IUSE=""
DEPEND=""
RDEPEND="~virtual/libstdc++-3.3
	amd64? ( app-emulation/emul-linux-x86-compat )"

DESTINATION="opt/intel/fc.*/${PV}"
QA_TEXTRELS="*"
QA_EXECSTACK="*"
QA_DT_HASH="${DESTINATION}/lib/.* ${DESTINATION}/bin/.*"

pkg_setup() {
	# Check if we have enough RAM and free diskspace
	CHECKREQS_MEMORY="512"
	local disk_req="300"
	use amd64 && disk_req="400"
	use ia64 && disk_req="350"
	CHECKREQS_DISK_BUILD=${disk_req}
	check_reqs
}

src_unpack() {
	unpack ${A}
	mv "${WORKDIR}"/l_* "${S}"
	cd "${S}"

	local ext=
	use amd64 && ext=e
	INSTALL_DIR=/opt/intel/${PB}${ext}/${PV}

	# debugger installed with dev-lang/idb
	rm -f data/intel*idb*.rpm

	for x in data/intel*.rpm; do
		einfo "Extracting $(basename ${x})..."
		rpm_unpack "${S}/${x}" || die "rpm_unpack ${x} failed"
	done

	einfo "Fixing paths and tagging"
	cd "${S}"/${INSTALL_DIR}/bin
	sed -e "s|<INSTALLDIR>|${INSTALL_DIR}|g" \
		-e 's|export -n IA32ROOT;||g' \
		-i ${PEXEC} *sh \
		|| die "sed fixing shells and paths failed"

	cd "${S}"/${INSTALL_DIR}/doc
	sed -e "s|\<installpackageid\>|${PACKID}|g" \
		-e "s|\<INSTALLTIMECOMBOPACKAGEID\>|${PACKID}|g" \
		-i *support \
		|| die "sed support file failed"
	chmod 644 *support
}

src_install() {
	einfo "Copying files"
	dodir ${INSTALL_DIR}
	cp -pPR \
		"${S}"/${INSTALL_DIR}/* \
		"${D}"/${INSTALL_DIR}/ \
		|| die "Copying ${PN} failed"

	local env_file=05${PN}
	cat > ${env_file} <<-EOF
		PATH=${INSTALL_DIR}/bin
		ROOTPATH=${INSTALL_DIR}/bin
		LDPATH=${INSTALL_DIR}/lib
		MANPATH=${INSTALL_DIR}/man
	EOF
	doenvd ${env_file} || die "doenvd ${env_file} failed"
}

pkg_postinst () {
	# remove left over from unpacking
	rm -f "${ROOT}"/opt/intel/{intel_sdp_products.db,.*.log} \
		|| die "remove logs failed"

	elog "Make sure you have recieved the a license for ${PN},"
	elog "you cannot run ${PN} without a license file."
	elog "To receive a non-commercial license, you need to register."
	elog "Read the website for more information on this license:"
	elog "${HOMEPAGE}"
	elog "Then put the license file into ${ROOT}/opt/intel/licenses."
	elog "\nTo use ${PN} issue first \n\tsource ${ROOT}/etc/profile"
	elog "Debugger is installed with dev-lang/idb"
}
