# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/ppc-sources/ppc-sources-2.4.22-r3.ebuild,v 1.2 2004/01/08 06:22:58 iggy Exp $

IUSE=""

ETYPE="sources"
inherit kernel

# OKV=original kernel version, KV=patched kernel version.  They can be the same.
OKV="`echo ${PV}|sed -e 's:^\([0-9]\+\.[0-9]\+\.[0-9]\+\).*:\1:'`"
EXTRAVERSION="-${PN/-*/}"
[ ! "${PR}" == "r0" ] && EXTRAVERSION="${EXTRAVERSION}-${PR/3/2}"
KV="${OKV}${EXTRAVERSION}"

S=${WORKDIR}/linux-${KV}

MY_R=`echo $PR | sed "s:r:ben:g"`

DESCRIPTION="PowerPC kernel tree based on benh's patches, -r corresponds to ben{r} versioning"
SRC_URI="http://www.kernel.org/pub/linux/kernel/v2.4/linux-${OKV}.tar.bz2
	 http://www.kernel.org/pub/linux/kernel/people/benh/patch-${OKV}-${MY_R/3/2}.bz2"
HOMEPAGE="http://www.kernel.org/pub/linux/kernel/people/benh/"
KEYWORDS="-x86 ppc -sparc -alpha"
PROVIDE="virtual/linux-sources"
LICENSE="GPL-2"
SLOT="${KV}"
DEPEND=">=sys-devel/binutils-2.11.90.0.31"
RDEPEND=">=sys-libs/ncurses-5.2 dev-lang/perl virtual/modutils sys-devel/make"

src_unpack() {
	unpack ${A}
	mv linux-${OKV} ${PF} || die

	cd ${PF}
	patch -p1 < ${WORKDIR}/patch-${OKV}-${MY_R/3/2} || die "patch failed"

	epatch ${FILESDIR}/do_brk_fix.patch || die "failed to patch for do_brk vuln"

	use xfs && ( ewarn "XFS is no longer included!" )
}

src_install() {
	dodir /usr/src
	cd ${S}
	rm ${WORKDIR}/patch-${OKV}-${MY_R}
	echo ">>> Copying sources..."
	mv ${WORKDIR}/* ${D}/usr/src
}
