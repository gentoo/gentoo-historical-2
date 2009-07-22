# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/checkpolicy/checkpolicy-2.0.16.ebuild,v 1.3 2009/07/22 13:21:18 pebenito Exp $

IUSE="debug"

inherit eutils

SEMNG_VER="2.0"

# BUGFIX_PATCH="${FILESDIR}/checkpolicy-1.30.4.diff"

DESCRIPTION="SELinux policy compiler"
HOMEPAGE="http://userspace.selinuxproject.org"
SRC_URI="http://userspace.selinuxproject.org/releases/current/devel/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="=sys-libs/libsemanage-${SEMNG_VER}*
	sys-devel/flex
	sys-devel/bison"

RDEPEND="=sys-libs/libsemanage-${SEMNG_VER}*"

src_unpack() {
	unpack ${A}

	[ ! -z "${BUGFIX_PATCH}" ] && epatch "${BUGFIX_PATCH}"
}

src_compile() {
	emake YACC="bison -y" || die
}

src_install() {
	make DESTDIR="${D}" install

	if useq debug; then
		dobin "${S}/test/dismod"
		dobin "${S}/test/dispol"
	fi
}

pkg_postinst() {
	einfo "This checkpolicy can compile version `checkpolicy -V |cut -f 1 -d ' '` policy."
}
