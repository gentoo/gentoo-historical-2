# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/mtd-utils/mtd-utils-20090630.ebuild,v 1.5 2010/02/13 18:44:40 robbat2 Exp $

inherit eutils

# Git ID for the snapshot
MY_PV="${PV}-22494a8d105936785af53235b088fa38112128fc"
DESCRIPTION="MTD userspace tools, based on GIT snapshot from upstream"
HOMEPAGE="http://git.infradead.org/?p=mtd-utils.git;a=summary"
SRC_URI="mirror://gentoo/${PN}-snapshot-${MY_PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~x86"
IUSE="xattr"

# We need libuuid
RDEPEND="!sys-fs/mtd
	dev-libs/lzo
	sys-libs/zlib
	>=sys-apps/util-linux-2.16"
# ACL is only required for the <sys/acl.h> header file to build mkfs.jffs2
# And ACL brings in Attr as well.
DEPEND="${RDEPEND}
	xattr? ( sys-apps/acl )"

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i 's:-Werror::' $(find . -name Makefile)
}

makeopts() {
	# bug 276374 has an interaction that makes the directories not work quite
	# right sometimes. This needs more work.
	[[ "${CTARGET}" != "" && "${CHOST}" != "${CTARGET}" ]] && echo CROSS=${CHOST}-
	use xattr || echo WITHOUT_XATTR=1
}

src_compile() {
	# bug 276374 requires that the contents of ubi-utils gets built BEFORE the
	# rest of the codebase. There is a parallel interference in the Makefile.
	pushd ubi-utils
	emake $(makeopts) || die
	popd
	emake $(makeopts) || die
}

src_install() {
	emake $(makeopts) install DESTDIR="${D}" || die
	dodoc *.txt
	newdoc mkfs.ubifs/README README.mkfs.ubifs
	# TODO: check ubi-utils for docs+scripts
}
