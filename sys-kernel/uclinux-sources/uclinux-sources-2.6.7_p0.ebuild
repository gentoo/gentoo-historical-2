# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/uclinux-sources/uclinux-sources-2.6.7_p0.ebuild,v 1.1 2004/06/25 20:15:29 plasmaroo Exp $

IUSE=""

ETYPE="sources"
inherit kernel eutils
OKV="`echo ${PV}|sed -e 's:^\([0-9]\+\.[0-9]\+\.[0-9]\+\).*:\1:'`"

EXTRAVERSION="uc${PV/*_p/}"
[ "${PR}" != "r0" ] && EXTRAVERSION="${EXTRAVERSION}-${PR}"
KV="${OKV}-${EXTRAVERSION}"

# Get the major & minor kernel version
MMV=`echo $PV | awk -F. '{print $1"."$2}'`

patch="diff"
base="uClinux"
if [ ${MMV} == "2.6" ]; then
	patch="patch"
	base="linux"
fi

MY_P=linux-${PV/_p/-uc}

S=${WORKDIR}/linux-${KV}
DESCRIPTION="uCLinux kernel patches for CPUs without MMUs"
SRC_URI="mirror://kernel/v${MMV}/linux-${OKV}.tar.bz2
	http://www.uclinux.org/pub/uClinux/uClinux-${MMV}.x/${MY_P/linux/${base}}.${patch}.gz"

HOMEPAGE="http://www.uclinux.org/"
KEYWORDS="~x86 -ppc"
SLOT="${KV}"

src_unpack() {
	unpack ${A}
	mv linux-${OKV} linux-${KV} || die

	cd linux-${KV}
	epatch ../${MY_P/linux/${base}}.${patch} || die "Failed to apply uClinux patch!"

	set MY_ARCH=${ARCH}
	unset ARCH
	rm ../${MY_P/linux/${base}}.${patch}

	kernel_universal_unpack
	set ARCH=${MY_ARCH}
}
