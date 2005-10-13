# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/sylpheed-claws-cachesaver/sylpheed-claws-cachesaver-0.5.ebuild,v 1.2 2005/10/13 04:59:46 weeve Exp $

MY_P="${P##sylpheed-claws-}"
MY_PN="${PN##sylpheed-claws-}"
SC_BASE="1.9.13"

DESCRIPTION="Plugin for sylpheed-claws to automatically save the cache regulary to avoid folder rebuilds in case of a crash"
HOMEPAGE="http://sylpheed-claws.sourceforge.net"
SRC_URI="mirror://sourceforge/sylpheed-claws/sylpheed-claws-plugins-${SC_BASE}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE=""
DEPEND=">=mail-client/sylpheed-claws-${SC_BASE}"

S="${WORKDIR}/${MY_P}"

src_compile() {
	econf || die
	emake || die
}

src_install() {
	make DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog NEWS README
}
