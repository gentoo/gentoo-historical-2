# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/openib.eclass,v 1.2 2011/08/22 04:46:32 vapier Exp $

# @ECLASS: openib.eclass
# @AUTHOR:
# Original Author: Alexey Shvetsov <alexxy@gentoo.org>
# @BLURB: Simplify working with OFED packages

inherit base eutils rpm versionator

EXPORT_FUNCTIONS src_unpack

HOMEPAGE="http://www.openfabrics.org/"
LICENSE="|| ( GPL-2 BSD-2 )"
SLOT="0"

# @ECLASS-VARIABLE: OFED_VER
# @DESCRIPTION:
# Defines OFED version eg 1.4 or 1.4.0.1

# @ECLASS-VARIABLE: OFED_SUFFIX
# @DESCRIPTION:
# Defines OFED package suffix eg -1.ofed1.4

# @ECLASS-VARIABLE: OFED_SNAPSHOT
# @DESCRIPTION:
# Defines if src tarball is git snapshot

OFED_BASE_VER=$(get_version_component_range 1-3 ${OFED_VER})

SRC_URI="http://www.openfabrics.org/downloads/OFED/ofed-${OFED_BASE_VER}/OFED-${OFED_VER}.tgz"

case ${PN} in
	openib-files)
		MY_PN="ofa_kernel"
		;;
	*)
		MY_PN="${PN}"
		;;
esac

case ${PV} in
	*p*)
		MY_PV="${PV/p/}"
		;;
	*)
		MY_PV="${PV}"
		;;
esac

case ${MY_PN} in
	ofa_kernel)
		EXT="tgz"
		;;
	*)
		EXT="tar.gz"
		;;
esac

S="${WORKDIR}/${MY_PN}-${MY_PV}"

# @FUNCTION: openib_src_unpack
# @DESCRIPTION:
# This function will unpack OFED packages
openib_src_unpack() {
	unpack ${A}
	rpm_unpack "./OFED-${OFED_VER}/SRPMS/${MY_PN}-${MY_PV}-${OFED_SUFFIX}.src.rpm"
	if [ -z ${OFED_SNAPSHOT} ]; then
		unpack ./${MY_PN}-${MY_PV}.${EXT}
	else
		unpack ./${MY_PN}-${MY_PV}-${OFED_SUFFIX}.${EXT}
	fi
}
