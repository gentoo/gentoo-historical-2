# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/feh/feh-1.1.1.ebuild,v 1.6 2002/10/20 18:48:56 vapier Exp $

S=${WORKDIR}/${P}
DESCRIPTION="A fast, lightweight imageviewer using imlib2"
SRC_URI="http://www.linuxbrit.co.uk/downloads/feh-${PV}.tar.gz"
HOMEPAGE="http://www.linuxbrit.co.uk/feh/"

SLOT="0"
LICENSE="as-is"
KEYWORDS="x86"

DEPEND="media-libs/imlib2"

src_compile() {
	econf || die
	emake || die
}

src_install() {
	einstall \
		docsdir=${D}/usr/share/doc/${PF} || die

	doman feh.1
	# gzip the docs
	gzip ${D}/usr/share/doc/${PF}/*

	dodoc AUTHORS COPYING ChangeLog README TODO
}
