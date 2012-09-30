# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/bwmon/bwmon-1.3-r1.ebuild,v 1.2 2012/09/30 07:56:14 pinkbyte Exp $

EAPI="4"

inherit toolchain-funcs flag-o-matic

DESCRIPTION="Simple ncurses bandwidth monitor"
HOMEPAGE="http://bwmon.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
RESTRICT="mirror"

DEPEND="sys-libs/ncurses"
RDEPEND="${DEPEND}"

SLOT="0"
LICENSE="GPL-2 public-domain"
KEYWORDS="~amd64 ~hppa ~ppc ~sparc ~x86"
IUSE=""

src_prepare() {
	# Respect CC and CFLAGS
	sed -i -e '/^CC/d' \
	-e '/^CFLAGS/d' \
	src/Makefile || die 'sed on CC and CFLAGS failed'
	# Respect LDFLAGS
	sed -i '/^LDFLAGS/s:LDFLAGS:LIBS:' src/Makefile || die 'sed on LDFLAGS failed'
	sed -i 's:$(CC) $(LDFLAGS) -o ../$@ $(OBJS):$(CC) $(CFLAGS) $(LDFLAGS) -o ../$@ $(OBJS) $(LIBS):' src/Makefile || die 'sed on compilation string failed'
}

src_compile() {
	append-cflags -I"${S}"/include -D__THREADS
	emake CC="$(tc-getCC)"
}

src_install () {
	dobin ${PN}
	dodoc README
}
