# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/libgdiplus/libgdiplus-2.6.4.ebuild,v 1.3 2010/07/09 17:04:19 pacho Exp $

EAPI=2

inherit eutils go-mono mono flag-o-matic

DESCRIPTION="Library for using System.Drawing with mono"
HOMEPAGE="http://www.go-mono.com/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86 ~x86-freebsd ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="cairo"

RDEPEND=">=dev-libs/glib-2.16
		>=media-libs/freetype-2.3.7
		>=media-libs/fontconfig-2.6
		media-libs/libpng
		x11-libs/libXrender
		x11-libs/libX11
		x11-libs/libXt
		>=x11-libs/cairo-1.8.4[X]
		media-libs/libexif
		>=media-libs/giflib-4.1.3
		media-libs/jpeg
		media-libs/tiff
		!cairo? ( >=x11-libs/pango-1.20 )"
DEPEND="${RDEPEND}"

RESTRICT="test"

src_prepare() {
	go-mono_src_prepare
	sed -i -e 's:ungif:gif:g' configure || die
}

src_configure() {
	append-flags -fno-strict-aliasing
	go-mono_src_configure	--with-cairo=system			\
				$(use !cairo && printf %s --with-pango)	\
				|| die "configure failed"
}
