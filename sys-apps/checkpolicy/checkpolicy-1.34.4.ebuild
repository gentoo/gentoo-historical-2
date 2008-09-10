# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/checkpolicy/checkpolicy-1.34.4.ebuild,v 1.4 2008/09/10 18:06:49 pebenito Exp $

IUSE="debug"

inherit eutils

SEMNG_VER="1.10.9"

# BUGFIX_PATCH="${FILESDIR}/checkpolicy-1.30.4.diff"

DESCRIPTION="SELinux policy compiler"
HOMEPAGE="http://www.nsa.gov/selinux"
SRC_URI="http://www.nsa.gov/selinux/archives/${P}.tgz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 mips ppc sparc x86"

DEPEND="=sys-libs/libsemanage-${SEMNG_VER}*
	sys-devel/flex
	sys-devel/bison"

RDEPEND="=sys-libs/libsemanage-${SEMNG_VER}*"

src_unpack() {
	unpack ${A}
	cd "${S}"

	[ ! -z "${BUGFIX_PATCH}" ] && epatch "${BUGFIX_PATCH}"
}

src_compile() {
	emake YACC="bison -y" || die
}

src_install() {
	make DESTDIR="${D}" install

	if useq debug; then
		dobin "${S}/test/{dismod,dispol}"
	fi
}

pkg_postinst() {
	einfo "This checkpolicy can compile version `checkpolicy -V |cut -f 1 -d ' '` policy."
}
