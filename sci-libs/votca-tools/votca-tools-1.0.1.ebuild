# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/votca-tools/votca-tools-1.0.1.ebuild,v 1.1 2011/02/12 16:12:08 ottxor Exp $

EAPI="3"

inherit eutils autotools

if [ "${PV}" != "9999" ]; then
	SRC_URI="http://votca.googlecode.com/files/${PF}.tar.gz"
else
	SRC_URI=""
	inherit mercurial
	EHG_REPO_URI="https://tools.votca.googlecode.com/hg"
	S="${WORKDIR}/${EHG_REPO_URI##*/}"
fi

DESCRIPTION="Votca tools library"
HOMEPAGE="http://www.votca.org"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86"
IUSE="boost doc +fftw +gsl static-libs"

RDEPEND="fftw? ( sci-libs/fftw:3.0 )
	dev-libs/expat
	gsl? ( sci-libs/gsl )
	boost? ( dev-libs/boost )
	doc? ( >=app-text/txt2tags-2.5 )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_prepare() {
	use gsl || ewarn "Disabling gsl will lead to reduced functionality"
	use fftw || ewarn "Disabling fftw will lead to reduced functionality"

	#remove bundled libs
	rm -rf src/libexpat
	use boost && rm -rf src/libboost

	eautoreconf || die "eautoreconf failed"
}

src_configure() {
	local myconf="--disable-la-files --disable-rc-files"

	use boost \
		&&  myconf="${myconf} $(use_with boost) --disable-votca-boost" \
		||  myconf="${myconf} $(use_with boost) --enable-votca-boost"

	myconf="${myconf} $(use_with gsl) $(use_with fftw) $(use_enable static-libs	static)"

	econf ${myconf} || die "econf failed"
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc NOTICE
	if use doc; then
		emake CHANGELOG || die "emake CHANGELOG failed"
		dodoc CHANGELOG
	fi
}
