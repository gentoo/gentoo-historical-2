# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/sdl-perl/sdl-perl-2.1.2.ebuild,v 1.1 2004/12/15 15:00:59 vapier Exp $

style=builder
inherit perl-module

DESCRIPTION="SDL binding for perl"
HOMEPAGE="http://sdl.perl.org/"
SRC_URI="http://search.cpan.org/CPAN/authors/id/D/DG/DGOEHRIG/SDL_Perl-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~sparc ~x86"
IUSE="truetype mpeg"

DEPEND="virtual/opengl
	>=media-libs/libsdl-1.2.6
	>=media-libs/sdl-mixer-1.2.5
	>=media-libs/sdl-image-1.2.2
	>=media-libs/sdl-gfx-2.0.3
	>=media-libs/sdl-net-1.2.4
	mpeg? ( media-libs/smpeg )
	truetype? ( >=media-libs/sdl-ttf-2.0.5 )"

S=${WORKDIR}/SDL_Perl-${PV}
