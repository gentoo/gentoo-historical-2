# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/unrar/unrar-3.3.6.ebuild,v 1.6 2004/06/10 05:52:32 mr_bones_ Exp $

MY_PN=${PN}src
DESCRIPTION="Uncompress rar files"
HOMEPAGE="http://www.rarlab.com/rar_add.htm"
SRC_URI="http://www.rarlab.com/rar/${MY_PN}-${PV}.tar.gz"

LICENSE="unRAR"
SLOT="0"
KEYWORDS="x86 ~ppc sparc alpha hppa amd64"
IUSE=""

DEPEND=""

S="${WORKDIR}/unrar"

src_compile() {
	emake -f makefile.unix CXXFLAGS="$CXXFLAGS" || die "emake failed"
}

src_install() {
	dobin unrar || die "dobin failed"
	dodoc readme.txt
}
