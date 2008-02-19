# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/showimg/showimg-0.9.4.1.ebuild,v 1.7 2008/02/19 01:41:17 ingmar Exp $

inherit kde

MY_PV="${PV/?.?.?.?/${PV%.*}-${PV##*.}}"
MY_P="${PN}-${MY_PV}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="feature-rich image viewer for KDE"
HOMEPAGE="http://www.jalix.org/projects/showimg/"
SRC_URI="http://www.jalix.org/projects/showimg/download/${MY_PV}/${MY_P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~sparc ~ppc amd64"
IUSE=""

DEPEND="|| ( =kde-base/libkonq-3.5* =kde-base/kdebase-3.5* )
	media-libs/libkexif
	media-plugins/kipi-plugins"
need-kde 3.1

src_compile(){
	local myconf="--enable-libkipi"
	kde_src_compile all
}
