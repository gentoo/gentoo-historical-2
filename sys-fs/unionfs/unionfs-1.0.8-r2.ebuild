# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/unionfs/unionfs-1.0.8-r2.ebuild,v 1.2 2005/03/09 13:11:50 satya Exp $

inherit eutils linux-mod

DESCRIPTION="Stackable unification file system, which can appear to merge the contents of several directories"
HOMEPAGE="http://www.fsl.cs.sunysb.edu/project-unionfs.html"
SRC_URI="ftp://ftp.fsl.cs.sunysb.edu/pub/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
KEYWORDS="~x86"
IUSE="${IUSE} acl debug vserver"

MODULE_NAMES="unionfs(fs:)"
BUILD_TARGETS="all"
BUILD_PARAMS="LINUXSRC=${KV_DIR} KERNELVERSION=${KV_MAJOR}.${KV_MINOR}"

#============================================================================
src_unpack() {
	local user_Makefile=fistdev.mk
	local EXTRACFLAGS=""
	#------------------------------------------------------------------------
	unpack ${A}
	cd ${S}
	#------------------------------------------------------------------------
	if use vserver; then
		epatch ${FILESDIR}/${P}-vserver-GFP.patch || die
		if kernel_is 2 4; then
			epatch ${FILESDIR}/${P}-vserver.patch || die
		fi
	fi
	#------------------------------------------------------------------------
	if ! use debug; then
		echo "UNIONFS_DEBUG_CFLAG=" >> ${user_Makefile}
		EXTRACFLAGS="${EXTRACFLAGS} -DNODEBUG"
	fi
	use acl && EXTRACFLAGS="${EXTRACFLAGS} -DUNIONFS_XATTR -DFIST_SETXATTR_CONSTVOID"
	echo "EXTRACFLAGS=${EXTRACFLAGS}" >> ${user_Makefile} || die
}
#============================================================================
src_install() {
	dosbin unionctl uniondbg
	doman man/unionfs.4 man/unionctl.8 man/uniondbg.8

	linux-mod_src_install

	dodoc INSTALL NEWS README ChangeLog
}
