# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/chkrootkit/chkrootkit-0.43-r2.ebuild,v 1.7 2004/08/26 23:40:10 weeve Exp $

inherit eutils

DESCRIPTION="a tool to locally check for signs of a rootkit"
HOMEPAGE="http://www.chkrootkit.org/"
SRC_URI="ftp://ftp.pangeia.com.br/pub/seg/pac/${P}.tar.gz
		mirror://gentoo/${PF}-gentoo.diff.gz"

LICENSE="AMS"
SLOT="0"
KEYWORDS="x86 ~ppc sparc alpha ~ia64 ~amd64"
IUSE=""

DEPEND="virtual/libc
	>=sys-apps/sed-4"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${WORKDIR}/${PF}-gentoo.diff
	sed -i 's:${head} -:${head} -n :' chkrootkit
	sed -i 's:/var/adm:/var/log:g' chklastlog.c
}

src_compile() {
	make sense || die
}

src_install() {
	dosbin check_wtmpx chklastlog chkproc chkrootkit chkwtmp ifpromisc \
		strings-static || die
	dodoc README README.chklastlog README.chkwtmp
}
