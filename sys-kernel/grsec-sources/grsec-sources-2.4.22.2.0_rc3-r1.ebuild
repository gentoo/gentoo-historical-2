# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/grsec-sources/grsec-sources-2.4.22.2.0_rc3-r1.ebuild,v 1.2 2004/01/05 22:10:53 solar Exp $

# Documentation on the patch contained in this kernel will be installed someday

ETYPE="sources"
IUSE=""

inherit eutils
inherit kernel

[ "$OKV" == "" ] && OKV="2.4.22"

PATCH_BASE="${PV/${OKV}./}"
PATCH_BASE=${PATCH_BASE/_/-}
EXTRAVERSION="-grsec-${PATCH_BASE}"
KV=${OKV}${EXTRAVERSION}

###################
DESCRIPTION="Vanilla sources of the linux kernel with the grsecurity ${PATCH_BASE} patch"
SRC_URI="http://www.kernel.org/pub/linux/kernel/v2.4/linux-${OKV}.tar.bz2 \
	http://grsecurity.net/grsecurity-${PATCH_BASE}-${OKV}.patch \
	http://grsecurity.net/grsecurity-${PATCH_BASE}-${OKV}.patch.sign"
HOMEPAGE="http://www.kernel.org/ http://grsecurity.net"
[ ${PATCH_BASE/.*/} == 1 ] && KEYWORDS="x86" || KEYWORDS="~x86 ~sparc ~ppc ~alpha"
SLOT="${OKV}"
S=${WORKDIR}/linux-${KV}
###################

src_unpack() {
	unpack linux-${OKV}.tar.bz2 || die "Unable to unpack the kernel"
	mv linux-${OKV} linux-${KV} || die "Unable to move the kernel"
	cd linux-${KV} || die "Unable to cd into the kernel source tree"
	if [ -f "${DISTDIR}/grsecurity-${PATCH_BASE}-${OKV}.patch" ]; then
		ebegin "Patching the kernel with the grsecurity-${PATCH_BASE}-${OKV} patch"
		cat ${DISTDIR}/grsecurity-${PATCH_BASE}-${OKV}.patch | patch -p 1
		eend $?
	else
		die "Unable to the kernel patch"
	fi

	epatch ${FILESDIR}/do_brk_fix.patch || die "failed to patch for do_brk vuln"

	mkdir -p docs
	touch docs/patches.txt

	kernel_universal_unpack
	# kernel_src_unpack
}

#src_install() {
#	kernel_src_install
#}
