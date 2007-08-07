# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kwin/kwin-3.5.7.ebuild,v 1.3 2007/08/07 22:48:24 josejx Exp $

KMNAME=kdebase
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KDE window manager"
KEYWORDS="~alpha ~amd64 ~ia64 ppc ~ppc64 sparc ~x86 ~x86-fbsd"
IUSE="kdehiddenvisibility xcomposite"
RDEPEND="xcomposite? ( x11-libs/libXcomposite x11-libs/libXdamage )"
DEPEND="${RDEPEND}"

SRC_URI="${SRC_URI}
	mirror://gentoo/kdebase-3.5-patchset-05.tar.bz2"

src_compile() {
	myconf="$myconf $(use_with xcomposite composite)"
	kde-meta_src_compile
}
