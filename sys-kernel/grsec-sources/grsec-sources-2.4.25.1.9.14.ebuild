# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/grsec-sources/grsec-sources-2.4.25.1.9.14.ebuild,v 1.1 2004/02/22 02:29:16 solar Exp $

# We control what versions of what we download based on the KEYWORDS we
# are using for the various arches. Thus if we want grsec1 stable we run
# the with "arch" ACCEPT_KEYWORDS or ~arch and we will get the
# grsec-2.0-preX which has alot more features.

# the only thing that should ever differ in one of these 1.9.x ebuilds
# and 2.x of the same kernel version is the KEYWORDS and header. 
# shame cvs symlinks don't exist

ETYPE="sources"
IUSE=""

inherit eutils
inherit kernel

[ "$OKV" == "" ] && OKV="2.4.25"

PATCH_BASE="${PV/${OKV}./}"
PATCH_BASE="${PATCH_BASE/_/-}"
EXTRAVERSION="-grsec-${PATCH_BASE}"
KV="${OKV}${EXTRAVERSION}"

PATCH_SRC_BASE="grsecurity-${PATCH_BASE}-${OKV}.patch"

# hppa takes a special patch and usually has play catch up between
# versions of this package we.

HPPA_SRC_URI=""
if [ "${ARCH}" == "hppa" ]; then
	PARISC_KERNEL_VERSION="pa1"
	KV="${OKV}-${PARISC_KERNEL_VERSION}${EXTRAVERSION}"
	HPPA_PATCH_SRC_BASE="parisc-linux-${OKV}-${PARISC_KERNEL_VERSION}${EXTRAVERSION}.gz"
	HPPA_SRC_URI="mirror://gentoo/${HPPA_PATCH_SRC_BASE} http://dev.gentoo.org/~pappy/gentoo-x86/sys-kernel/grsec-sources/${HPPA_PATCH_SRC_BASE}"
	PATCH_SRC_BASE="${HPPA_PATCH_SRC_BASE}"
fi

DESCRIPTION="Vanilla sources of the linux kernel with the grsecurity ${PATCH_BASE} patch"

DYSFUNCTIONAL_SRC_URI="hppa? ( $HPPA_SRC_URI ) \
	!hppa? ( http://grsecurity.net/grsecurity-${PATCH_BASE}-${OKV}.patch \
		http://grsecurity.net/grsecurity-${PATCH_BASE}-${OKV}.patch.sign ) \
	http://www.kernel.org/pub/linux/kernel/v2.4/linux-${OKV}.tar.bz2"

SRC_URI="http://grsecurity.net/grsecurity-${PATCH_BASE}-${OKV}.patch \
	http://grsecurity.net/grsecurity-${PATCH_BASE}-${OKV}.patch.sign  \
	http://www.kernel.org/pub/linux/kernel/v2.4/linux-${OKV}.tar.bz2"

HOMEPAGE="http://www.kernel.org/ http://www.grsecurity.net"

[ ${PATCH_BASE/.*/} == 1 ] && KEYWORDS="x86 -hppa" || KEYWORDS="~x86 ~sparc ~ppc ~alpha -hppa"

SLOT="${OKV}"
S="${WORKDIR}/linux-${KV}"

src_unpack() {
	unpack linux-"${OKV}".tar.bz2 || die "unable to unpack the kernel"
	mv linux-"${OKV}" linux-"${KV}" || die "unable to move the kernel"
	cd linux-"${KV}" || die "unable to cd into the kernel source tree"

	[ -f "${DISTDIR}/${PATCH_SRC_BASE}" ] || die "File does not exist?"

	# users are often confused by what settings should be set so
	# here lets them an example of what a P4 desktop would look like.
	cp ${FILESDIR}/2.4.24-x86.config gentoo-grsec-custom-example-2.4.24-x86.config

	ebegin "Patching the kernel with ${PATCH_SRC_BASE}"
	case "${ARCH}" in
		hppa)	zcat ${DISTDIR}/${PATCH_SRC_BASE} | patch -g0 -p1 --quiet ;;
		*)	cat  ${DISTDIR}/${PATCH_SRC_BASE} | patch -g0 -p1 --quiet ;;
	esac
	[ $? == 0 ] || die "failed patching with ${PATCH_SRC_BASE}"
	eend 0

	mkdir docs
	touch docs/patches.txt
	kernel_universal_unpack

	# fixed in .24
	#epatch ${FILESDIR}/${PN}-${OKV}.CAN-2003-0985.patch
	#epatch ${FILESDIR}/${PN}-${OKV}.rtc_fix.patch
}
