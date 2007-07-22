# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmmp3/wmmp3-0.12.ebuild,v 1.10 2007/07/22 04:47:39 dberkholz Exp $

inherit eutils

IUSE=""

DESCRIPTION="Mp3 player dock app for WindowMaker; frontend to mpg123"
HOMEPAGE="http://www.dotfiles.com/software/wmmp3/"
SRC_URI="http://www.dotfiles.com/software/wmmp3/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc ~sparc x86"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xextproto
	>=media-sound/mpg123-0.59s-r2"

src_unpack()
{
	unpack ${A}
	cd ${S}

	# Fix #103531
	epatch ${FILESDIR}/${P}-x_includes_n_libraries.patch
}

src_compile()
{
	# override wmmp3 self-calculated cflags
	econf || die "Configuration failed"
	emake prefix="/usr/" || die "Compilation failed"
}

src_install()
{
	einstall || die "Installation failed"
	dodoc AUTHORS ChangeLog sample.wmmp3 README TODO
}

pkg_postinst()
{
	einfo "Please copy the sample.wmmp3 to your home directory and change it to fit your needs."
}
