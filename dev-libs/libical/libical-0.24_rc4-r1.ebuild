# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libical/libical-0.24_rc4-r1.ebuild,v 1.8 2006/02/16 10:06:34 s4t4n Exp $

IUSE=""

DESCRIPTION="libical is an implementation of basic iCAL protocols"
HOMEPAGE="http://softwarestudio.org/libical/"
SRC_URI="mirror://sourceforge/freeassociation/${PN}-0.24.RC4.tar.gz"

RDEPEND="virtual/libc"

DEPEND="${RDEPEND}
	>=sys-devel/bison-1.35
	>=sys-devel/flex-2.5.4a-r5
	>=sys-apps/gawk-3.1.3
	>=dev-lang/perl-5.8.0-r12"

SLOT="0"
LICENSE="MPL-1.1 LGPL-2"
KEYWORDS="alpha amd64 ppc ppc64 ~sparc x86"

S=${WORKDIR}/libical-0.24

src_compile()
{
	# Fix 66377
	LDFLAGS="${LDFLAGS} -lpthread" econf || die "Configuration failed"
	emake || die "Compilation failed"
}

src_install ()
{
	einstall || die "Installation failed..."
}
