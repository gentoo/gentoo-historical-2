# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/mips-sources/mips-sources-2.4.28.ebuild,v 1.1 2005/01/06 05:20:39 kumba Exp $


# Version Data
OKV=${PV/_/-}
CVSDATE="20050105"			# Date of diff between kernel.org and lmo CVS
COBALTPATCHVER="1.4"			# Tarball version for cobalt patches
SECPATCHVER="1.9"			# Tarball version for security patches
GENPATCHVER="1.5"			# Tarball version for generic patches
EXTRAVERSION="-mipscvs-${CVSDATE}"
KV="${OKV}${EXTRAVERSION}"

# Miscellaneous stuff
S=${WORKDIR}/linux-${OKV}-${CVSDATE}

# Eclass stuff
ETYPE="sources"
inherit kernel eutils


# INCLUDED:
# 1) linux sources from kernel.org
# 2) linux-mips.org CVS snapshot diff from 12 Jul 2004
# 3) patch to fix arch/mips[64]/Makefile to pass appropriate CFLAGS
# 4) patch to fix the mips64 Makefile to allow building of mips64 kernels
# 5) iso9660 fix
# 6) Patches for Cobalt support


DESCRIPTION="Linux-Mips CVS sources for MIPS-based machines, dated ${CVSDATE}"
SRC_URI="mirror://kernel/linux/kernel/v2.4/linux-${OKV}.tar.bz2
		mirror://gentoo/mipscvs-${OKV}-${CVSDATE}.diff.bz2
		mirror://gentoo/${PN}-security_patches-${SECPATCHVER}.tar.bz2
		mirror://gentoo/${PN}-generic_patches-${GENPATCHVER}.tar.bz2
		cobalt? ( mirror://gentoo/cobalt-patches-24xx-${COBALTPATCHVER}.tar.bz2 )"

HOMEPAGE="http://www.linux-mips.org/"
SLOT="${OKV}"
PROVIDE="virtual/linux-sources"
KEYWORDS="-* ~mips"
IUSE="cobalt"


src_unpack() {
	unpack ${A}
	mv ${WORKDIR}/linux-${OKV} ${WORKDIR}/linux-${OKV}-${CVSDATE}
	cd ${S}

	# Update the vanilla sources with linux-mips CVS changes
	epatch ${WORKDIR}/mipscvs-${OKV}-${CVSDATE}.diff

	# Security Fixes
	echo -e ""
	ebegin ">>> Applying Security Fixes"
		epatch ${WORKDIR}/security/CAN-2004-0814-2.4.26-tty_race_conditions.patch
		epatch ${WORKDIR}/security/CAN-2004-1016-dos-scm_send.patch
		epatch ${WORKDIR}/security/CAN-2004-1056-2.4-dos_drm.patch
		epatch ${WORKDIR}/security/CAN-2004-1074-2.4-kernel_dos_aout.patch
		epatch ${WORKDIR}/security/CAN-2004-1074-2.4.28-kernel_dos_vma.patch
		epatch ${WORKDIR}/security/CAN-2004-1137-igmp_vuln.patch
		epatch ${WORKDIR}/security/security-2.4-proc_race.patch
	eend


	# Cobalt Patches
	if use cobalt; then
		echo -e ""
		einfo ">>> Patching kernel for Cobalt support ..."
		for x in ${WORKDIR}/cobalt-patches-24xx-${COBALTPATCHVER}/*.patch; do
			epatch ${x}
		done
		cp ${WORKDIR}/cobalt-patches-24xx-${COBALTPATCHVER}/cobalt-patches.txt ${S}
		cd ${WORKDIR}
		mv ${WORKDIR}/linux-${OKV}-${CVSDATE} ${WORKDIR}/linux-${OKV}-${CVSDATE}.cobalt
		S="${S}.cobalt"
	fi

	kernel_universal_unpack
}
