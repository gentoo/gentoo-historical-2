# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/gdl/gdl-0.9_rc2.ebuild,v 1.1 2009/08/26 02:46:16 markusle Exp $

EAPI="2"

inherit eutils flag-o-matic autotools

MYP=${P/_/}
DESCRIPTION="An Interactive Data Language compatible incremental compiler"
LICENSE="GPL-2"
HOMEPAGE="http://gnudatalanguage.sourceforge.net/"
SRC_URI="mirror://sourceforge/gnudatalanguage/${MYP}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="python fftw hdf hdf5 netcdf imagemagick proj"

RDEPEND=">=sys-libs/readline-4.3
	sci-libs/gsl
	=dev-java/antlr-2.7*[cxx]
	>=sci-libs/plplot-5.3
	imagemagick? ( media-gfx/imagemagick )
	hdf? ( sci-libs/hdf )
	hdf5? ( sci-libs/hdf5 )
	netcdf? ( sci-libs/netcdf )
	python? ( dev-python/numarray dev-python/matplotlib )
	fftw? ( >=sci-libs/fftw-3 )
	proj? ( sci-libs/proj )"

DEPEND="${RDEPEND}
	sys-devel/libtool"

S="${WORKDIR}/${MYP}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.9_rc1-proj4.patch
	epatch "${FILESDIR}"/${PN}-0.9_rc1-magick.patch
	epatch "${FILESDIR}"/${P}-gcc4.4.patch
	epatch "${FILESDIR}"/${P}-antlr.patch

	# we need to blow away the directory with antlr
	# otherwise the build system picks up bogus
	# header files
	rm -fr "${S}"/src/antlr || die "failed to remove antlr directory"

	eautoreconf
}

src_configure() {
	# need to check for old plplot
	local myconf
	if has_version '<sci-libs/plplot-5.9.0'; then
		myconf="${myconf} --enable-oldplplot"
	fi

	# sorry, but even configure barfs with --as-needed
	# when linking against imagemagick - have yet to
	# figure out what the problem is
	use imagemagick && append-ldflags -Wl,--no-as-needed

	# make sure we're hdf5-1.6 backward compatible
	use hdf5 && append-flags -DH5_USE_16_API

	use proj && append-cppflags -DPJ_LIB__
	econf \
	  $(use_with python) \
	  $(use_with fftw) \
	  $(use_with hdf) \
	  $(use_with hdf5) \
	  $(use_with netcdf) \
	  $(use_with imagemagick Magick) \
	  $(use_with proj libproj4) \
	  ${myconf} \
	  || die "econf failed"

}

src_test() {
	cd "${S}"/testsuite
	PATH="${S}"/src gdl <<-EOF
		test_suite
	EOF
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	insinto /usr/share/${PN}
	doins -r src/pro src/py || die "install pro and py files failed"
	dodoc README PYTHON.txt AUTHORS ChangeLog NEWS TODO HACKING \
		|| die "Failed to install docs"

	# add GDL provided routines to IDL_PATH
	echo "GDL_STARTUP=/usr/share/${PN}/pro" > 99gdl
	echo "GDL_PATH=/usr/share/${PN}" >> 99gdl
	doenvd 99gdl || die "doenvd failed"
}
