# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/libgdiplus/libgdiplus-0.8.ebuild,v 1.5 2004/06/29 17:59:30 agriffis Exp $

DESCRIPTION="Library for using System.Drawing with Mono"
HOMEPAGE="http://www.go-mono.com/"
SRC_URI="http://www.go-mono.com/archive/beta2/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE="tiff gif jpeg png"

DEPEND=">=x11-libs/cairo-0.1.23
	tiff? ( media-libs/tiff )
	gif? ( media-libs/libungif )
	jpeg? ( media-libs/jpeg )
	png? ( media-libs/libpng )
	>=sys-apps/sed-4"
RDEPEND=">=dev-dotnet/mono-0.95"

src_compile() {
	local myconf=""
	use tiff ||  myconf="--without-libtiff ${myconf}"
	use gif ||  myconf="--without-libungif ${myconf}"
	use jpeg ||  myconf="--without-libjpeg ${myconf}"
	use png ||  myconf="--without-libpng ${myconf}"

	econf ${myconf} || die
	# attribute((__stdcall__)) generate warnings on ppc
	use ppc && sed -i -e 's:-Werror::g' src/Makefile
	emake || die
}

src_install() {
	einstall || die
	dodoc AUTHORS ChangeLog NEWS README
}
