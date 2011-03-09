# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/emboss/emboss-6.3.1.ebuild,v 1.1 2011/03/09 12:00:38 jlec Exp $

EAPI="4"

inherit autotools eutils

DESCRIPTION="The European Molecular Biology Open Software Suite - A sequence analysis package"
HOMEPAGE="http://emboss.sourceforge.net/"
SRC_URI="ftp://${PN}.open-bio.org/pub/EMBOSS/EMBOSS-${PV}.tar.gz"
LICENSE="GPL-2 LGPL-2"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="doc +largefile minimal mysql pdf png postgres static-libs X"

DEPEND="
	dev-libs/expat
	dev-libs/libpcre:3
	sci-libs/plplot
	sys-libs/zlib
	mysql? ( dev-db/mysql )
	pdf? ( media-libs/libharu )
	png? (
		sys-libs/zlib
		media-libs/libpng
		media-libs/gd
		)
	postgres? ( dev-db/postgresql-base )
	!minimal? (
		sci-biology/primer3
		sci-biology/clustalw
		)
	X? ( x11-libs/libXt )"
RDEPEND="${DEPEND}
	!sys-devel/cons"
PDEPEND="
	!minimal? (
		sci-biology/aaindex
		sci-biology/cutg
		sci-biology/prints
		sci-biology/prosite
		sci-biology/rebase
		sci-biology/transfac
		)"

S="${WORKDIR}/EMBOSS-${PV}"

src_prepare() {
	epatch \
		"${FILESDIR}"/${PV}-unbundle-libs.patch
	eautoreconf
}

conf-with() {
	# USE with-option Option
	if use ${1}; then
		echo "--with-${2}=${3}"
	else
		echo "--without-${2}"
	fi
}

src_configure() {
	local myconf
	myconf="--includedir=${ED}/usr/include/emboss --enable-systemlibs"

	myconf="${myconf} $(conf-with png pngdriver ${EPREFIX}/usr)"
	myconf="${myconf} $(conf-with doc docroot ${EPREFIX}/usr)"
	myconf="${myconf} $(conf-with pdf hpdf ${EPREFIX}/usr)"
	myconf="${myconf} $(conf-with mysql mysql ${EPREFIX}/usr/bin/mysql_config)"
	myconf="${myconf} $(conf-with postgresql postgresql ${EPREFIX}/usr/bin/pg_config)"

	econf \
		$(use_with X x) \
		$(use_enable amd64 64) \
		$(use_enable largefile large) \
		$(use_enable static-libs static) \
		--without-java \
		${myconf}
}

src_install() {
	einstall || die "Failed to install program files."

	dodoc AUTHORS ChangeLog FAQ NEWS README THANKS
	sed "s:EPREFIX:${EPREFIX}:g" "${FILESDIR}"/${PN}-README.Gentoo-2 > README.Gentoo && \
	dodoc README.Gentoo

	# Install env file for setting libplplot and acd files path.
	cat <<- EOF > 22emboss
		# plplot libs dir
		PLPLOT_LIB="${EPREFIX}/usr/share/EMBOSS/"
		# ACD files location
		EMBOSS_ACDROOT="${EPREFIX}/usr/share/EMBOSS/acd"
	EOF
	doenvd 22emboss

	# Symlink preinstalled docs to "/usr/share/doc".
	dosym /usr/share/EMBOSS/doc/manuals /usr/share/doc/${PF}/manuals
	dosym /usr/share/EMBOSS/doc/programs /usr/share/doc/${PF}/programs
	dosym /usr/share/EMBOSS/doc/tutorials /usr/share/doc/${PF}/tutorials
	dosym /usr/share/EMBOSS/doc/html /usr/share/doc/${PF}/html

	# Clashes #330507
	mv "${ED}"/usr/bin/{digest,pepdigest} || die

	# Remove useless dummy files from the image.
	find emboss/data -name dummyfile -delete || die "Failed to remove dummy files."

	# Move the provided codon files to a different directory. This will avoid
	# user confusion and file collisions on case-insensitive file systems (see
	# bug #115446). This change is documented in "README.Gentoo".
	mv "${ED}"/usr/share/EMBOSS/data/CODONS{,.orig} || \
			die "Failed to move CODON directory."

	# Move the provided restriction enzyme prototypes file to a different name.
	# This avoids file collisions with versions of rebase that install their
	# own enzyme prototypes file (see bug #118832).
	mv "${ED}"/usr/share/EMBOSS/data/embossre.equ{,.orig} || \
			die "Failed to move enzyme equivalence file."
}
