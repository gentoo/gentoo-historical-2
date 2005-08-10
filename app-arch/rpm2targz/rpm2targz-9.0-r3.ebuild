# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/rpm2targz/rpm2targz-9.0-r3.ebuild,v 1.10 2005/08/10 15:46:24 blubb Exp $

inherit toolchain-funcs eutils

DESCRIPTION="Convert a .rpm file to a .tar.gz archive"
HOMEPAGE="http://www.slackware.com/config/packages.php"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86"
IUSE=""

# NOTE: rpm2targz autodetects rpm2cpio at runtime, and uses it if available,
#       so we don't explicitly set it as a dependency.
DEPEND="virtual/libc
	app-arch/cpio
	sys-apps/file"
RDEPEND="${DEPEND}
	sys-apps/util-linux
	sys-apps/which"

S=${WORKDIR}

src_unpack() {
	unpack ${A}
	cd ${S}
	# makes rpm2targz extract in current dir
	epatch ${FILESDIR}/${P}-gentoo.patch
	# adds bzip2 detection (#23249)
	epatch ${FILESDIR}/${P}-bzip2.patch
	# adds bzip2 decompression to rpm2targz (#31164)
	epatch ${FILESDIR}/${P}-bzip2_rpm2targz.patch
	# secures temp file handling (#96192)
	epatch ${FILESDIR}/${P}-secure_temp_handling.patch
}

src_compile() {
	$(tc-getCC) ${CFLAGS} -o rpmoffset rpmoffset.c || die
}

src_install() {
	dobin rpmoffset rpm2targz || die
	dodoc rpm2targz.README
}
