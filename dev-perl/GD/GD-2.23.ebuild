# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/GD/GD-2.23.ebuild,v 1.4 2005/08/13 23:23:48 hansmi Exp $

inherit eutils perl-module

DESCRIPTION="interface to Thomas Boutell's gd library"
HOMEPAGE="http://www.cpan.org/modules/by-module/GD/${P}.readme"
SRC_URI="mirror://cpan/authors/id/L/LD/LDS/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~mips ppc ~ppc64 sparc x86"
IUSE="jpeg truetype X gif png"

DEPEND=">=media-libs/gd-2.0.12
	png? ( media-libs/libpng sys-libs/zlib )
	jpeg? ( media-libs/jpeg )
	truetype? ( =media-libs/freetype-2* )
	X? ( virtual/x11 )
	gif? ( media-libs/giflib )"

src_compile() {
	myconf=""
	use jpeg && myconf="${myconf},JPEG"
	use truetype && myconf="${myconf},FREETYPE"
	use png && myconf="${myconf},PNG"
	use X && myconf="${myconf},XPM"
	use gif && myconf="${myconf},GIF"
	myconf="-options \"${myconf:1}\""
	perl-module_src_compile
}

mydoc="GD.html"
