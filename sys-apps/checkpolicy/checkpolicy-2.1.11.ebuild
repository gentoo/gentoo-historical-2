# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/checkpolicy/checkpolicy-2.1.11.ebuild,v 1.1 2012/10/09 20:04:47 swift Exp $

inherit toolchain-funcs

SEPOL_VER="2.1.8"
SEMNG_VER="2.1.9"

DESCRIPTION="SELinux policy compiler"
HOMEPAGE="http://userspace.selinuxproject.org"
SRC_URI="http://userspace.selinuxproject.org/releases/20120924/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND=">=sys-libs/libsepol-${SEPOL_VER}
	>=sys-libs/libsemanage-${SEMNG_VER}
	sys-devel/flex
	sys-devel/bison"

RDEPEND=">=sys-libs/libsemanage-${SEMNG_VER}"

src_compile() {
	emake CC="$(tc-getCC)" YACC="bison -y" || die
}

src_install() {
	emake DESTDIR="${D}" install || die

	if use debug; then
		dobin "${S}/test/dismod"
		dobin "${S}/test/dispol"
	fi
}

pkg_postinst() {
	einfo "This checkpolicy can compile version `checkpolicy -V |cut -f 1 -d ' '` policy."
}
