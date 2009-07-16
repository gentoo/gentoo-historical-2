# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/vkeybd/vkeybd-0.1.17b-r1.ebuild,v 1.2 2009/07/16 08:05:18 fauli Exp $

EAPI=2
inherit toolchain-funcs eutils

DESCRIPTION="A virtual MIDI keyboard for X"
HOMEPAGE="http://www.alsa-project.org/~iwai/alsa.html"
SRC_URI="http://www.gtlib.gatech.edu/pub/suse/people/tiwai/vkeybd/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~sparc x86"
IUSE="alsa lash oss"

RDEPEND="alsa? ( media-libs/alsa-lib )
	>=dev-lang/tk-8.3
	lash? ( media-sound/lash )
	x11-libs/libX11"
DEPEND="${RDEPEND}
	x11-proto/xf86bigfontproto
	x11-proto/bigreqsproto
	x11-proto/xextproto
	x11-proto/xcmiscproto"

S=${WORKDIR}/${PN}

pkg_setup() {
	TCL_VERSION=`echo 'puts [info tclversion]' | tclsh`

	vkeybconf="PREFIX=/usr"

	if use alsa; then
		vkeybconf+=" USE_ALSA=1"
		use oss || vkeybconf+=" USE_AWE=0 USE_MIDI=0"
	else
		vkeybconf+=" USE_ALSA=0 USE_AWE=1 USE_MIDI=1"
	fi

	use lash && vkeybconf+=" USE_LASH=1"

	vkeybconf+=" TCL_VERSION=${TCL_VERSION}"
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-makefile.patch \
		"${FILESDIR}"/${P}-desktop-entry.patch \
		"${FILESDIR}"/${P}-lash.patch
}

src_compile() {
	tc-export CC
	emake ${vkeybconf} COPTFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" || die "emake failed"
}

src_install() {
	emake ${vkeybconf} DESTDIR="${D}" \
		install-all || die "emake install failed"
	dodoc ChangeLog README
}
