# Copyright 1999-2004 Gentoo Technologies, Inc. 
# Distributed under the terms of the GNU General Public License, v2 or later 
# $Header: /var/cvsroot/gentoo-x86/x11-themes/baghira/baghira-0.3r.ebuild,v 1.1 2004/06/12 14:58:30 carlo Exp $ 

inherit kde

S=${WORKDIR}/${PN}

DESCRIPTION="Baghira - an OS-X like style for KDE-3.2"
SRC_URI="mirror://sourceforge/baghira/${P}.tar.bz2"
HOMEPAGE="http://www.kde-look.org/content/show.php?content=8692"

LICENSE="BSD"
KEYWORDS="~x86"
IUSE=""

need-kde 3.2

src_unpack() {
	unpack "${A}"
	epatch ${FILESDIR}/gcc34-baghira-03r.patch
	cd "${S}"
}
