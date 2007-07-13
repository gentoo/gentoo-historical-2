# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/koverartist/koverartist-0.5.ebuild,v 1.4 2007/07/13 05:40:32 mr_bones_ Exp $

inherit kde eutils

S=${WORKDIR}/${PN}
DESCRIPTION="Koverartist is a KDE program for fast creation of covers for cd/dvd cases and boxes."
HOMEPAGE="http://www.kde-apps.org/content/show.php?content=38195"
SRC_URI="http://members.inode.at/499177/software/${PN}/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="cddb"

DEPEND="!app-cdr/kover
	cddb?  ( || ( ( kde-base/libkcddb kde-base/kdemultimedia-kioslaves )
			kde-base/kdemultimedia ) )"

need-kde 3.3

src_compile() {
	if ! use cddb ; then
	        myconf="$myconf --without-audiocd"
	fi
	kde_src_compile
}
