# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/raster3d/raster3d-2.9.2.ebuild,v 1.1 2010/04/02 08:31:46 jlec Exp $

EAPI="3"

inherit fortran flag-o-matic multilib toolchain-funcs versionator

MY_PN="Raster3D"
MY_PV=$(replace_version_separator 2 -)
MY_P="${MY_PN}_${MY_PV}"

DESCRIPTION="A set of tools for generating high quality raster images of proteins or other molecules"
HOMEPAGE="http://www.bmsc.washington.edu/raster3d/raster3d.html"
SRC_URI="http://www.bmsc.washington.edu/${PN}/${MY_P}.tar.gz -> ${MY_P}.tar"

LICENSE="as-is"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	media-libs/jpeg
	media-libs/libpng
	media-libs/tiff"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}"/2.9.1-as-needed.patch
}

src_compile() {
	sed -e "s:prefix  = /usr/local:prefix  = ${EPREFIX}/usr:" \
		-i Makefile.template || \
		die "Failed to patch makefile.template"

	if [[ ${FORTRANC} == gfortran ]]; then
		append-cflags -Dgfortran
	fi

	append-fflags -ffixed-line-length-132

	for target in linux-gfortran all; do
		emake \
			CFLAGS="${CFLAGS}" \
			LDFLAGS="${LDFLAGS}" \
			FFLAGS="${FFLAGS}" \
			CC="$(tc-getCC)"\
			FC="${FORTRANC}" \
			INCDIRS="-I${EPREFIX}"/usr/include \
			LIBDIRS="-L${EPREFIX}"/usr/$(get_libdir) \
			${target} || die
	done
}

src_install() {
	emake prefix="${ED}"/usr \
			bindir="${ED}"/usr/bin \
			datadir="${ED}"/usr/share/Raster3D/materials \
			mandir="${ED}"/usr/share/man/man1 \
			htmldir="${ED}"/usr/share/Raster3D/html \
			examdir="${ED}"/usr/share/Raster3D/examples \
			install || die "Failed to install application."

	dodir /etc/env.d
	echo -e "R3D_LIB=${EPREFIX}/usr/share/${NAME}/materials" > \
		"${ED}"/etc/env.d/10raster3d || \
		die "Failed to install env file."
}

pkg_postinst() {
	elog "Add following line:"
	elog "<delegate decode=\"r3d\" command='\"render\" < \"%i\" > \"%o\"' />"
	elog "to ${EPREFIX}/usr/$(get_libdir)/ImageMagick-6.5.8/config/delegates.xml"
	elog "to make imagemagick use raster3d for .r3d files"
}
