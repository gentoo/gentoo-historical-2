# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Tk-JPEG-Lite/Tk-JPEG-Lite-2.01403.ebuild,v 1.11 2006/10/24 22:05:32 mcummings Exp $

inherit perl-module

IUSE=""

DESCRIPTION="lite JPEG loader for Tk::Photo"
SRC_URI="mirror://cpan/authors/id/S/SR/SREZIC/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-authors/id/S/SR/SREZIC/"

SLOT="0"
LICENSE="Artistic GPL-2"
KEYWORDS="amd64 ia64 ~ppc sparc x86"

DEPEND="media-libs/jpeg
	dev-perl/perl-tk
	dev-lang/perl"

src_unpack() {
	unpack ${A}
	cd ${S}
	for i in Makefile.PL tkjpeg MANIFEST; do
	 	sed -e 's:tkjpeg:tkjpeg-lite:' ${i} > ${i}.new \
		   	&& mv ${i}.new ${i} || die "sed on ${i} failed!"
	done
	mv tkjpeg tkjpeg-lite
}

pkg_postinst() {
	elog
	elog "To avoid collisions, the command line program has been renamed from tkjpeg to tkjpeg-lite"
	elog
}
