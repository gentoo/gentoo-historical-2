# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/abcm2ps/abcm2ps-3.7.21.ebuild,v 1.1 2004/12/19 01:32:59 eradicator Exp $

IUSE=""

inherit eutils gnuconfig

DESCRIPTION="A program to convert abc files to Postscript files"
HOMEPAGE="http://moinejf.free.fr/"
SRC_URI="http://moinejf.free.fr/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 sparc x86"

DEPEND=""

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-destdir.patch
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc README abc-draft.txt Changes INSTALL
}
