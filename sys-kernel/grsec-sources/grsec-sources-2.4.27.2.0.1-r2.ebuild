# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/grsec-sources/grsec-sources-2.4.27.2.0.1-r2.ebuild,v 1.2 2004/11/10 21:16:18 mr_bones_ Exp $

# We control what versions of what we download based on the KEYWORDS we
# are using for the various arches. Thus if we want grsec1 stable we run
# the with "arch" ACCEPT_KEYWORDS or ~arch and we will get the
# grsec-2.0-preX which has alot more features.

# the only thing that should ever differ in one of these 1.9.x ebuilds
# and 2.x of the same kernel version is the KEYWORDS and header.
# shame cvs symlinks don't exist

ETYPE="sources"
IUSE=""

inherit eutils kernel

[ "$OKV" == "" ] && OKV="2.4.27"

PATCH_BASE="${PV/${OKV}./}"
PATCH_BASE="${PATCH_BASE/_/-}"
EXTRAVERSION="-grsec-${PATCH_BASE}"
KV="${OKV}${EXTRAVERSION}"

PATCH_SRC_BASE="grsecurity-${PATCH_BASE}-${OKV}.patch"
DESCRIPTION="Vanilla sources of the linux kernel with the grsecurity ${PATCH_BASE} patch"
CAN_PATCHES="mirror://linux-2.4.27-nfs3-xdr.patch.bz2"
SRC_URI="http://grsecurity.net/grsecurity-${PATCH_BASE}-${OKV}.patch \
	http://www.kernel.org/pub/linux/kernel/v2.4/linux-${OKV}.tar.bz2 ${CAN_PATCHES}"
#mirror://gentoo/grsecurity-${PATCH_BASE}-${OKV}.patch.bz2

HOMEPAGE="http://www.kernel.org/ http://www.grsecurity.net"
KEYWORDS="x86 sparc ppc alpha amd64 -hppa"

SLOT="${KV}"
S="${WORKDIR}/linux-${KV}"

src_unpack() {
	unpack linux-"${OKV}".tar.bz2 || die "unable to unpack the kernel"
	mv linux-"${OKV}" linux-"${KV}" || die "unable to move the kernel"
	cd linux-"${KV}" || die "unable to cd into the kernel source tree"

	patch_grsec_kernel

	mkdir -p docs
	touch docs/patches.txt
	kernel_universal_unpack
}

patch_grsec_kernel() {
	# users are often confused by what settings should be set.
	# so we provide an  example of what a P4 desktop would look like.
	cp ${FILESDIR}/2.4.24-x86.config gentoo-grsec-custom-example-2.4.24-x86.config


	[ -f "${DISTDIR}/${PATCH_SRC_BASE}" ] || die "File ${PATCH_SRC_BASE} does not exist?"
	ebegin "Patching the kernel with ${PATCH_SRC_BASE}"
	cat  ${DISTDIR}/${PATCH_SRC_BASE} | patch -g0 -p1 --quiet
	[ $? == 0 ] || die "failed patching with ${PATCH_SRC_BASE}"
	eend 0

	# fix format string problem in panic()
	epatch ${FILESDIR}/2.4.26-CAN-2004-0394.patch

	# Potential security issue in /proc/cmdline bug 59905
	epatch ${FILESDIR}/2.4.27-cmdline-race.patch

	# remote denial-of-service. bug 62524
	epatch ${DISTDIR}/linux-2.4.27-nfs3-xdr.patch.bz2

	return 0
}
