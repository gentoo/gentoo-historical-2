# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/exiftool/exiftool-6.44.ebuild,v 1.1 2006/10/04 21:40:01 nattfodd Exp $

inherit perl-module

DESCRIPTION="Read and write meta information from EXIF"
HOMEPAGE="http://www.sno.phy.queensu.ca/~phil/exiftool/"
SRC_URI="http://www.sno.phy.queensu.ca/~phil/exiftool/Image-ExifTool-${PV}.tar.gz"

MY_PN="Image-ExifTool"
LICENSE="Artistic GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""
S=${WORKDIR}/${MY_PN}-${PV}


src_compile() {
	perl Makefile.PL DESTDIR="${D}" || die "Invalid Makefile.PL"
	emake || die "Compilation failed"
}

src_install() {
	make install || die "Installation failed"
	fixlocalpod
	dodoc Changes README
	dohtml -r html/
	dobin exiftool
}
