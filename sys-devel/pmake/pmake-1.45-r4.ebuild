# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/pmake/pmake-1.45-r4.ebuild,v 1.7 2004/07/02 08:42:32 eradicator Exp $

inherit eutils
EPATCH_SOURCE="${FILESDIR}"
EPATCH_SUFFIX="patch"

DESCRIPTION="BSD build tool to create programs in parallel"
HOMEPAGE="http://www.netbsd.org/"
SRC_URI="mirror://gentoo/${PN}_${PV}-11.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="x86 ppc sparc ~mips alpha arm amd64 ia64"
IUSE=""

RDEPEND="virtual/libc"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4"

src_unpack() {
	unpack ${A} && cd ${S} || die

	# We do not want all patches in ${FILESDIR}, as 01_all_groffpatch.patch is
	# not longer valid for this version.
	epatch ${FILESDIR}/02_all_mktemp.patch

	# pmake makes the assumption that . and .. are the first two
	# entries in a directory, which doesn't always appear to be the
	# case on ext3...  (05 Apr 2004 agriffis)
	epatch ${FILESDIR}/skipdots.patch

	# Clean up headers to reduce warnings
	sed -i -e 's|^#endif.*|#endif|' *.h */*.h
}

src_compile() {
	local a=$ARCH
	[[ $a = x86 ]] && a=i386

	# The following CFLAGS are almost directly from Red Hat 8.0 and
	# debian/rules, so assume it's okay to void out the __COPYRIGHT
	# and __RCSID.  I've checked the source and don't see the point,
	# but whatever...  (07 Feb 2004 agriffis)
	CFLAGS="${CFLAGS} -Wall -D_GNU_SOURCE \
		-D__COPYRIGHT\(x\)= -D__RCSID\(x\)= -I. \
		-DMACHINE=\\\"gentoo\\\" -DMACHINE_ARCH=\\\"${a}\\\""
	make -f Makefile.boot CFLAGS="${CFLAGS}"
}

src_install() {
	dodir /usr/share/mk
	insinto /usr/share/mk
	rm -f mk/*~
	doins mk/*

	mv bmake pmake
	dobin pmake || die
	dobin mkdep
	mv make.1 pmake.1
	doman mkdep.1 pmake.1
	dodoc PSD.doc/tutorial.ms
}
