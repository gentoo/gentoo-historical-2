# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/checkpolicy/checkpolicy-1.16.ebuild,v 1.2 2004/09/09 16:31:40 method Exp $

IUSE=""

inherit eutils

DESCRIPTION="SELinux policy compiler"
HOMEPAGE="http://www.nsa.gov/selinux"
SRC_URI="http://www.nsa.gov/selinux/archives/${P}.tgz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc"

DEPEND="sys-libs/libsepol
	sys-devel/flex
	sys-devel/bison"

RDEPEND="sec-policy/selinux-base-policy"

src_unpack() {
	unpack ${A}
	sed -i -e "s:-Wall:-Wall ${CFLAGS}:g" -e 's/$(LIBS)/$(LIBS) $(LDFLAGS)/' ${S}/Makefile
	epatch ${FILESDIR}/checkpolicy-1.16-no-netlink-warn.diff
}

src_compile() {
	cd ${S}
	emake YACC="bison -y" || die
}

src_install() {
	make DESTDIR="${D}" install
}
