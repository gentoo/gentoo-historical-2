# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/GD/GD-2.35-r1.ebuild,v 1.4 2007/01/11 14:14:36 gustavoz Exp $

inherit eutils perl-module

DESCRIPTION="interface to Thomas Boutell's gd library"
HOMEPAGE="http://www.cpan.org/modules/by-module/GD/${P}.readme"
SRC_URI="mirror://cpan/authors/id/L/LD/LDS/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~mips ~ppc ~ppc64 sparc ~x86 ~x86-fbsd"
IUSE="animgif gif jpeg png truetype xpm"

DEPEND=">=media-libs/gd-2.0.33
	png? ( media-libs/libpng sys-libs/zlib )
	jpeg? ( media-libs/jpeg )
	truetype? ( =media-libs/freetype-2* )
	xpm? ( || ( x11-libs/libXpm virtual/x11 ) )
	gif? ( media-libs/giflib )
	dev-lang/perl"

src_compile() {
	myconf=""
	use gif && use animgif && myconf="${myconf},ANIMGIF"
	use jpeg && myconf="${myconf},JPEG"
	use truetype && myconf="${myconf},FREETYPE"
	use png && myconf="${myconf},PNG"
	use xpm && myconf="${myconf},XPM"
	use gif && myconf="${myconf},GIF"
	myconf="-options \"${myconf:1}\""
	perl-module_src_compile
}

mydoc="GD.html"


