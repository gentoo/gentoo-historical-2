# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Goo-Canvas/Goo-Canvas-0.06.ebuild,v 1.3 2010/03/22 11:15:36 phajdan.jr Exp $

EAPI=2

MODULE_AUTHOR=YEWENBIN
inherit perl-module

DESCRIPTION="Perl interface to the GooCanvas"

SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

RDEPEND="x11-libs/goocanvas
	dev-perl/gtk2-perl
	dev-perl/glib-perl
	dev-perl/Cairo"
DEPEND="${RDEPEND}
	dev-perl/extutils-depends
	dev-perl/extutils-pkgconfig"

PATCHES=(
	# this patch fixes segfaults on amd64 platforms
	"${FILESDIR}"/fix_implicit_pointer_declaration.patch
)
