# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/icc/icc-8.1.032.ebuild,v 1.1 2005/05/31 19:17:51 karltk Exp $

inherit rpm

DESCRIPTION="Intel C++ Compiler - Intel's Pentium optimized compiler for Linux"
SRC_URI="l_cc_pc_${PV}.tar.gz"
HOMEPAGE="http://www.intel.com/software/products/compilers/clin/"
LICENSE="icc-7.0"
RDEPEND=">=sys-libs/glibc-2.2.5
	x86? ( sys-libs/lib-compat )"
SLOT="8.1"
KEYWORDS="~x86"
IUSE=""
RESTRICT="nostrip fetch"
S="${WORKDIR}/l_cc_pc_${PV}"

src_unpack() {
	unpack ${A}

	cd ${S} || die

	# The tarball contains rpms for multiple arches, and a lot of
	# auxiliary rpms common across arches. We must throw away 
	# the arch we're not.
	if [ "$ARCH" = "x86" ]
	then
		rm -f intel-*.ia64.rpm
	else
		rm -f intel-*.i386.rpm
	fi

	for x in *.rpm
	do
		# WORKDIR must be set properly for rpm_unpack()
		rpm_unpack ${S}/${x}
	done

	mv ${WORKDIR}/opt ${S}/

}

src_compile() {
	instdir=/opt/intel/compiler81

	for x in opt/intel_cc_80/bin/{iccvars.csh,iccvars.sh} opt/intel_idb_80/bin/idbvars.{csh,sh} ; do
		sed "s|<INSTALLDIR>|${instdir}|g" -i $x
	done

	# == SRC_BASE
	eval `grep "^[ ]*PACKAGEID=" ${S}/install.sh`

	# From UNTAG_SUPPORT() in 'install.sh'
	SUPPORTFILE=${S}/opt/intel_cc_80/doc/csupport
	if [ -f ${SUPPORTFILE} ]
	then
		einfo "Untagging: ${SUPPORTFILE}"
		sed s@\<installpackageid\>@${PACKAGEID}@g ${SUPPORTFILE} > ${SUPPORTFILE}.abs
		mv ${SUPPORTFILE}.abs ${SUPPORTFILE}
		chmod 644 ${SUPPORTFILE}
	fi

	# From UNTAG_SUPPORT_IDB() in 'install.sh'
	SUPPORTFILE=${S}/opt/intel_idb_80/doc/idbsupport
	if [ -f ${SUPPORTFILE} ]
	then
		einfo "Untagging: ${SUPPORTFILE}"
		sed s@\<INSTALLTIMECOMBOPACKAGEID\>@${PACKAGEID}@g ${SUPPORTFILE} > ${SUPPORTFILE}.abs
		mv ${SUPPORTFILE}.abs ${SUPPORTFILE}
		chmod 644 ${SUPPORTFILE}
	fi

	# These should not be executable
	find "${S}/opt/intel_cc_80/"{doc,man,include} -type f -exec chmod -x "{}" ";"
	find "${S}/opt/intel_cc_80/lib" -name \*.a -exec chmod -x "{}" ";"
	find "${S}/opt/intel_idb_80/"{doc,man} -type f -exec chmod -x "{}" ";"
}

src_install () {
	instdir=/opt/intel/compiler81
	dodoc ${S}/lgpltext
	dodoc ${S}/clicense
	dodir ${instdir}
	cp -a opt/intel_cc_80/* ${D}/${instdir}
	cp -a opt/intel_idb_80/* ${D}/${instdir}
	insinto /etc/env.d
	doins ${FILESDIR}/${PVR}/05icc-ifc || die
	exeinto ${instdir}/bin
	doexe ${FILESDIR}/${PVR}/icc || die
	doexe ${FILESDIR}/${PVR}/icpc || die
}

pkg_postinst () {
	instdir=/opt/intel/compiler81

	einfo "http://www.intel.com/software/products/compilers/clin/noncom.htm"
	einfo "From the above url you can get a free, non-commercial"
	einfo "license to use the Intel C++ Compiler emailed to you."
	einfo "You cannot run icc without this license file."
	einfo "Read the website for more information on this license."
	einfo
	einfo "Documentation can be found in ${instdir}/doc/"
	einfo
	einfo "You will need to place your license in ${instdir}/licenses/"
	einfo

	ewarn
	ewarn "Packages compiled with versions of icc older than 8.0 will need"
	ewarn "to be recompiled. Until you do that, old packages will"
	ewarn "work if you edit /etc/ld.so.conf and change '${instdir}'"
	ewarn "to '/opt/intel/compiler70' and run 'ldconfig.' Note that this edit"
	ewarn "won't persist and will require you to re-edit after each"
	ewarn "package you re-install."
	ewarn "BEFORE COMPILING IMPORTANT APPLICATIONS THAT YOUR"
	ewarn "SYSTEM DEPENDS ON, READ THE WARNING ABOVE."
	ewarn "THIS COULD RENDER YOUR SYSTEM UNUSABLE."
	ewarn "THIS IS A PROBLEM WITH INTEL'S SOFTWARE, _NOT_"
	ewarn "WITH GENTOO."

	ewarn "If 'icc' breaks, use 'iccbin' instead and report a bug."
	ewarn "Please use 'source /etc/profile' prior to merging any icc-enabled"
	ewarn "ebuilds."
}
