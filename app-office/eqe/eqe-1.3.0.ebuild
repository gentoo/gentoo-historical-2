# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/eqe/eqe-1.3.0.ebuild,v 1.1 2006/02/14 10:33:20 ehmsen Exp $

inherit eutils

DESCRIPTION="A small LaTeX editor that produces images, with drag and drop
support."
HOMEPAGE="http://rlehy.free.fr/"
SRC_URI="http://rlehy.free.fr/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc ~x86 ~amd64"

IUSE=""
DEPEND="dev-perl/gtk2-perl
	dev-perl/File-Slurp
	dev-perl/Template-Toolkit
	media-gfx/imagemagick
	virtual/tetex"

src_unpack() {
	unpack ${A} || die
	cd ${S}

	# Fix install loction and conform to the Gentoo way
	epatch ${FILESDIR}/${P}-Makefile.patch || die
}

src_install() {
	make DESTDIR=${D} install || die
}
