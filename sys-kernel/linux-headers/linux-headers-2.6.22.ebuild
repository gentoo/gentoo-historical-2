# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/linux-headers/linux-headers-2.6.22.ebuild,v 1.1 2007/07/09 04:38:01 vapier Exp $

ETYPE="headers"
H_SUPPORTEDARCH="alpha amd64 arm cris hppa m68k mips ia64 ppc ppc64 s390 sh sparc x86"
inherit kernel-2
detect_version

PATCH_VER="1"
SRC_URI="mirror://gentoo/gentoo-headers-base-${PV}.tar.bz2"
[[ -n ${PATCH_VER} ]] && SRC_URI="${SRC_URI} mirror://gentoo/gentoo-headers-${PV}-${PATCH_VER}.tar.bz2"

KEYWORDS="-* -alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"

DEPEND="dev-util/unifdef"
RDEPEND=""

S=${WORKDIR}/gentoo-headers-base-${PV}

src_unpack() {
	unpack ${A}
	cd "${S}"
	[[ -n ${PATCH_VER} ]] && EPATCH_SUFFIX="patch" epatch "${WORKDIR}"/${PV}
}

src_install() {
	kernel-2_src_install
	cd "${D}"/usr/include
	egrep -r '[[:space:]](asm|volatile|inline)[[:space:](]' .
	headers___fix $(find -type f)
}

src_test() {
	make ARCH=$(tc-arch-kernel) headers_check || die
}
