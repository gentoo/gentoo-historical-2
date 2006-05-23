# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/memtester/memtester-4.0.3.ebuild,v 1.9 2006/05/23 20:18:04 corsair Exp $

inherit fixheadtails toolchain-funcs

DESCRIPTION="userspace utility for testing the memory subsystem for faults"
HOMEPAGE="http://pyropus.ca/software/memtester/"
SRC_URI="http://pyropus.ca/software/memtester/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"
IUSE=""

DEPEND=""

src_unpack() {
	unpack ${A}
	cd ${S}
	echo "$(tc-getCC) ${CFLAGS} -DPOSIX -c" > conf-cc
	ht_fix_file Makefile
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	dosbin memtester || die "dosbin failed"
	doman memtester.8
	dodoc BUGS CHANGELOG README README.tests
}
