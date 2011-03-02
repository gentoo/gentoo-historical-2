# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-geosciences/gpscorrelate/gpscorrelate-1.6.0.ebuild,v 1.3 2011/03/02 20:33:35 jlec Exp $

EAPI="1"

inherit eutils toolchain-funcs

DESCRIPTION="Tool for adjusting EXIF tags of your photos with a recorded GPS trace"
HOMEPAGE="http://freefoote.dview.net/linux_gpscorr.html"
SRC_URI="http://freefoote.dview.net/linux/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86"
IUSE="doc gtk"
DEPEND="dev-libs/libxml2:2
	media-gfx/exiv2
	gtk? ( x11-libs/gtk+:2 )"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${PN}-1.5.8-makefile.diff"
}

src_compile() {
	tc-export CC
	emake gpscorrelate gpscorrelate.1 || die
	if use gtk; then
		emake gpscorrelate-gui || die
	fi
}

src_install() {
	dobin gpscorrelate
	if use gtk; then
		dobin gpscorrelate-gui
		make_desktop_entry gpscorrelate-gui GPSCorrelate "" "Photography;Graphics;Geography;"
	fi
	if use doc; then
		dohtml doc/* || die
	fi
	doman gpscorrelate.1 || die
}
