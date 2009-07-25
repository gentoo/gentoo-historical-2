# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/freemat/freemat-3.6.ebuild,v 1.7 2009/07/25 02:31:15 halcy0n Exp $

EAPI="2"
inherit eutils autotools fdo-mime

MY_PN=FreeMat
MY_P=${MY_PN}-${PV}

DESCRIPTION="Environment for rapid engineering and scientific processing"
HOMEPAGE="http://freemat.sourceforge.net/"
SRC_URI="mirror://sourceforge/freemat/${MY_P}.tar.gz"

IUSE="+arpack ffcall +fftw ncurses portaudio +umfpack"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="|| ( ( x11-libs/qt-gui:4 x11-libs/qt-opengl:4 x11-libs/qt-svg:4 )
		 x11-libs/qt:4[opengl] )
	dev-libs/libpcre
	virtual/lapack
	virtual/opengl
	ncurses? ( >=sys-libs/ncurses-5.4 )
	umfpack? ( sci-libs/umfpack )
	arpack? ( sci-libs/arpack )
	fftw? ( sci-libs/fftw:3.0 )
	portaudio? ( media-libs/portaudio )
	ffcall? ( dev-libs/ffcall )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	# allow enable/disable for configure
	epatch "${FILESDIR}"/${P}-optional-deps.patch
	epatch "${FILESDIR}"/${P}-includes.patch
	epatch "${FILESDIR}"/${P}-gcc44.patch
	eautoreconf
}

src_configure() {
	econf \
		--with-blas="$(pkg-config --libs blas)" \
		--with-lapack="$(pkg-config --libs lapack)" \
		$(use_with ncurses) \
		$(use_enable umfpack) \
		$(use_enable arpack) \
		$(use_enable fftw) \
		$(use_enable portaudio) \
		$(use_enable ffcall)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog || die "dodoc failed"
	newicon images/freemat_small_mod_64.png ${PN}.png
	make_desktop_entry FreeMat FreeMat
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	elog "Before using ${MY_PN}, do (as a normal user)"
	elog "FreeMat -i /usr/share/${MY_P}"
	elog "Then start ${MY_PN}, choose Tools -> Path Tool,"
	elog "select /usr/share/${MY_P}/toolbox and Add With Subfolders"
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
