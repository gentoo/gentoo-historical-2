# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/sleuthkit/sleuthkit-1.68.ebuild,v 1.2 2004/05/06 12:05:18 fmccor Exp $

DESCRIPTION="A collection of file system and media management forensic analysis tools"
SRC_URI="mirror://sourceforge/sleuthkit/${P}.tar.gz"
HOMEPAGE="http://www.sleuthkit.org/sleuthkit/"
RESTRICT="nomirror"

KEYWORDS="~x86 ~sparc"
LICENSE="GPL-2 IBM"
SLOT="0"

RDEPEND="dev-lang/perl
	dev-perl/DateManip
	virtual/glibc
	sys-libs/zlib"

DEPEND="${RDEPEND}
	>=sys-apps/sed-4
	sys-devel/gcc"

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i '63,69d' src/timeline/config-perl
	sed -i 's:`cd ../..; pwd`:/usr:' src/sorter/install
}

src_compile() {
	export OPT="${CFLAGS}"
	unset CFLAGS
	make -e no-perl sorter mactime || die "make failed"
}

src_install() {
	dobin bin/*
	dodoc CHANGES README docs/*
	docinto tct.docs
	dodoc tct.docs/*
	insinto /usr/share/sorter
	doins share/sorter/*
	doman man/man1/*
}
