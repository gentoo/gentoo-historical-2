# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/less/less-378-r1.ebuild,v 1.5 2003/02/13 16:02:40 vapier Exp $

IUSE=""

S="${WORKDIR}/${P}"
DESCRIPTION="Excellent text file viewer"
HOMEPAGE="http://www.greenwoodsoftware.com/"
SRC_URI="http://www.greenwoodsoftware.com/less/${P}.tar.gz"

KEYWORDS="x86 ~ppc ~sparc alpha hppa"
SLOT="0"
LICENSE="GPL-2"

DEPEND="virtual/glibc >=sys-libs/ncurses-5.2"

src_compile() {
	./configure --host=${CHOST} --prefix=/usr \
		    --sysconfdir=/etc || die
	
	emake || die
}

src_install() {
	dobin less lessecho lesskey
	exeinto /usr/bin
	newexe ${FILESDIR}/lesspipe.sh-r1 lesspipe.sh

	# Needed for groff-1.18 and later ...
	dodir /etc/env.d
	echo "LESS=\"-r\"" > ${D}/etc/env.d/70less
	
	newman lesskey.nro lesskey.1
	newman less.nro less.1

	dodoc COPYING NEWS README LICENSE
}

