# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/horde.eclass,v 1.23 2005/07/06 23:07:38 swegener Exp $
#
# Help manage the horde project http://www.horde.org/
#
# Author: Mike Frysinger <vapier@gentoo.org>
# CVS additions by Chris Aniszczyk <zx@mea-culpa.net>
# SNAP additions by Jonathan Polansky <jpolansky@lsit.ucsb.edu>
#
# This eclass provides generic functions to make the writing of horde
# ebuilds fairly trivial since there are many horde applications and 
# they all share the same basic install process.

# EHORDE_SNAP
# This variable tracks whether the user is using a snapshot version
#
# EHORDE_SNAP_BRANCH
# You set this via the ebuild to whatever branch you wish to grab a
# snapshot of.  Typically this is 'HEAD' or 'RELENG'.
#
# EHORDE_CVS
# This variable tracks whether the user is using a cvs version

inherit webapp eutils
[[ ${PN} != ${PN/-cvs} ]] && inherit cvs

IUSE="vhosts"

EXPORT_FUNCTIONS pkg_setup src_unpack src_install pkg_postinst

[[ -z ${HORDE_PN} ]] && HORDE_PN="${PN/horde-}"
[[ -z ${HORDE_MAJ} ]] && HORDE_MAJ=""

EHORDE_CVS="false"
EHORDE_SNAP="false"
if [[ ${PN} != ${PN/-cvs} ]] ; then
	EHORDE_CVS="true"
	HORDE_PN=${HORDE_PN/-cvs}

	ECVS_SERVER="anoncvs.horde.org:/repository"
	ECVS_MODULE="${HORDE_PN}"
	ECVS_TOP_DIR="${DISTDIR}/cvs-src/${PN}"
	ECVS_USER="cvsread"
	ECVS_PASS="horde"

	SRC_URI=""
	S=${WORKDIR}/${HORDE_PN}

elif [[ ${PN} != ${PN/-snap} ]] ; then
	EHORDE_SNAP="true"
	EHORDE_SNAP_BRANCH=${EHORDE_SNAP_BRANCH:-HEAD}
	SNAP_PV=${PV:0:4}-${PV:4:2}-${PV:6:2}

	HORDE_PN=${HORDE_PN/-snap}

	SRC_URI="http://ftp.horde.org/pub/snaps/${SNAP_PV}/${HORDE_PN}-${EHORDE_SNAP_BRANCH}-${SNAP_PV}.tar.gz"
	S=${WORKDIR}/${HORDE_PN}

else
	SRC_URI="http://ftp.horde.org/pub/${HORDE_PN}/${HORDE_PN}${HORDE_MAJ}-${PV/_/-}.tar.gz"
	S=${WORKDIR}/${HORDE_PN}${HORDE_MAJ}-${PV/_/-}
fi
HOMEPAGE="http://www.horde.org/${HORDE_PN}"

LICENSE="LGPL-2"

# INSTALL_DIR is used by webapp.eclass when USE=-vhosts
INSTALL_DIR="/horde"
[[ ${HORDE_PN} != "horde" ]] && INSTALL_DIR="${INSTALL_DIR}/${HORDE_PN}"

horde_pkg_setup() {
	webapp_pkg_setup

	if [[ ! -z ${HORDE_PHP_FEATURES} ]] ; then
		local param
		if [[ ${HORDE_PHP_FEATURES:0:2} = "-o" ]] ; then
			param="-o"
			HORDE_PHP_FEATURES=${HORDE_PHP_FEATURES:2}
		fi
		if ! built_with_use ${param} mod_php ${HORDE_PHP_FEATURES} ; then
			eerror "You MUST re-emerge mod_php with at least one of"
			eerror "the following options in your USE:"
			eerror " ${HORDE_PHP_FEATURES}"
			die "current mod_php install cannot support ${HORDE_PN}"
		fi
	fi
}

horde_src_unpack() {
	if [[ ${EHORDE_CVS} = "true" ]] ; then
		cvs_src_unpack
	else
		unpack ${A}
	fi
	cd "${S}"
	[[ -f test.php ]] && chmod 000 test.php
	[[ -n ${EHORDE_PATCHES} ]] && epatch ${EHORDE_PATCHES}
}

horde_src_install() {
	webapp_src_preinst

	local destdir=${MY_HTDOCSDIR}

	# Work-around when dealing with CVS sources
	[[ ${EHORDE_CVS} = "true" ]] && cd ${HORDE_PN}

	dodoc README docs/*
	rm -rf COPYING LICENSE README docs

	dodir ${destdir}
	cp -r . ${D}/${destdir}/
	webapp_serverowned ${MY_HTDOCSDIR}

	webapp_src_install
}

horde_pkg_postinst() {
	if [[ -e ${ROOT}/usr/share/doc/${PF}/INSTALL.gz ]] ; then
		einfo "Please read /usr/share/doc/${PF}/INSTALL.gz"
	fi
	einfo "Before this package will work, you have to setup"
	einfo "the configuration files.  Please review the"
	einfo "config/ subdirectory of ${HORDE_PN} in the webroot."
	if [[ ${HORDE_PN} != "horde" ]] ; then
		ewarn
		ewarn "Make sure ${HORDE_PN} is accounted for in horde's root"
		ewarn "    config/registry.php"
	fi
	if [[ ${EHORDE_CVS} = "true" ]] ; then
		ewarn
		ewarn "Use these CVS versions at your own risk."
		ewarn "They tend to break things when working with" 
		ewarn "the non CVS versions of horde."
	fi
	if use vhosts ; then
		echo
		ewarn "When installing horde into a vhost dir, you will"
		ewarn "need to use the -d option so that it is installed"
		ewarn "into the proper location."
	fi
	webapp_pkg_postinst
}
