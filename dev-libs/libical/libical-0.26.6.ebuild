# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libical/libical-0.26.6.ebuild,v 1.15 2007/07/25 17:26:55 jer Exp $

DESCRIPTION="libical is an implementation of basic iCAL protocols"
HOMEPAGE="http://www.aurore.net/projects/libical/"
SRC_URI="http://www.aurore.net/projects/libical/${PN}-0.26-6.aurore.tar.bz2"
SLOT="0"
LICENSE="|| ( MPL-1.1 LGPL-2 )"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND="virtual/libc"
DEPEND="${RDEPEND}
	>=sys-devel/bison-1.875d
	>=sys-devel/flex-2.5.4a-r6
	>=sys-apps/gawk-3.1.4-r4
	>=dev-lang/perl-5.8.7-r3"

S=${WORKDIR}/libical-0.26

src_compile() {
	# Fix 66377
	LDFLAGS="${LDFLAGS} -lpthread" econf || die "Configuration failed"
	emake || die "Compilation failed"
}

src_install () {
	einstall || die "Installation failed..."
}
