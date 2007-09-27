# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/rpm2targz/rpm2targz-9.0-r6.ebuild,v 1.5 2007/09/27 15:24:23 josejx Exp $

inherit toolchain-funcs eutils

DESCRIPTION="Convert a .rpm file to a .tar.gz archive"
HOMEPAGE="http://www.slackware.com/config/packages.php"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="alpha ~amd64 ~arm hppa ia64 ~m68k mips ppc ppc64 ~s390 ~sh sparc x86 ~x86-fbsd"
IUSE=""

# NOTE: rpm2targz autodetects rpm2cpio at runtime, and uses it if available,
#       so we don't explicitly set it as a dependency.
DEPEND="app-arch/cpio
	sys-apps/file"
RDEPEND="${DEPEND}
	userland_GNU? (
		sys-apps/util-linux
		sys-apps/which )"

S=${WORKDIR}

src_unpack() {
	unpack ${A}
	cd "${S}"
	# makes rpm2targz extract in current dir
	epatch "${FILESDIR}"/${P}-gentoo.patch
	# adds bzip2 detection (#23249)
	epatch "${FILESDIR}"/${P}-bzip2.patch
	# adds bzip2 decompression to rpm2targz (#31164)
	epatch "${FILESDIR}"/${P}-bzip2_rpm2targz.patch
	# secures temp file handling (#96192)
	epatch "${FILESDIR}"/${P}-secure_temp_handling.patch
	# add supprot for a quicker rpm2tar
	epatch "${FILESDIR}"/${P}-rpm2tar.patch
	# non-gnu portability with which
	epatch "${FILESDIR}"/${P}-portability.patch
	# remove bashisms to be compatible with other sh
	epatch "${FILESDIR}"/${P}-sh.patch
	# remove warnings from the compiler (and QA warnings too)
	epatch "${FILESDIR}"/${P}-warnings.patch
}

src_compile() {
	emake rpmoffset CC=$(tc-getCC) || die
}

src_install() {
	dobin rpmoffset rpm2targz || die
	dosym rpm2targz /usr/bin/rpm2tar
	dodoc rpm2targz.README
}
