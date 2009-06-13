# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/kcdlabel/kcdlabel-2.13.ebuild,v 1.6 2009/06/13 13:04:23 tampakrap Exp $

inherit flag-o-matic kde eutils

DESCRIPTION="cd label printing tool for kde"
HOMEPAGE="http://kcdlabel.sourceforge.net/"
SRC_URI="http://kcdlabel.sourceforge.net/download/${P}-KDE3.tar.gz
	mirror://gentoo/kde-admindir-3.5.5.tar.bz2"

SLOT="3.5"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc sparc x86"
IUSE=""

need-kde 3.5

S="${WORKDIR}/${P}-KDE3"

src_unpack() {
	kde_src_unpack

	# Fix the desktop file
	epatch "${FILESDIR}/${P}-desktop_file.patch"
}

src_compile(){
	append-flags -fpermissive
	kde_src_compile all
}
