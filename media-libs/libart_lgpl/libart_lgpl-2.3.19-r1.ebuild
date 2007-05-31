# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libart_lgpl/libart_lgpl-2.3.19-r1.ebuild,v 1.8 2007/05/31 14:27:07 jer Exp $

inherit gnome2 eutils

DESCRIPTION="a LGPL version of libart"
HOMEPAGE="http://www.levien.com/libart"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ~m68k mips ~ppc ppc64 ~s390 ~sh sparc x86 ~x86-fbsd"
IUSE=""

DEPEND="dev-util/pkgconfig"
RDEPEND=""

DOCS="AUTHORS ChangeLog INSTALL NEWS README"

src_unpack() {
	gnome2_src_unpack

	epatch "${FILESDIR}"/${P}-alloc.patch
}
