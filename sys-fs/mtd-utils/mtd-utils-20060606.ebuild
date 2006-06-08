# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/mtd-utils/mtd-utils-20060606.ebuild,v 1.2 2006/06/08 03:41:36 robbat2 Exp $

inherit toolchain-funcs flag-o-matic

DESCRIPTION="MTD userspace tools, based on GIT snapshot from upstream"
HOMEPAGE="http://sources.redhat.com/jffs2/"
SRC_URI="mirror://gentoo/${PN}-snapshot-${PV}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~mips ~arm ~amd64 ~ppc"
IUSE=""

S="${WORKDIR}/${PN}"

DEPEND="sys-libs/zlib
		virtual/libc
		!sys-fs/mtd"

src_unpack() {
	unpack ${A}
	sed -i.orig \
		-e 's!^MANDIR.*!MANDIR = /usr/share/man!g' \
		-e 's!-include.*!!g' \
		${S}/Makefile
}

src_compile() {
	append-flags -I./include -Wall
	emake DESTDIR="${D}" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" CC="$(tc-getCC)" || die
}

src_install() {
	emake install DESTDIR="${D}"
	dodoc *.txt
}
