# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/kemistry/kemistry-0.7.ebuild,v 1.5 2006/07/09 18:51:05 markusle Exp $

ARTS_REQUIRED="yes"
inherit kde eutils

DESCRIPTION="Kemistry--a set of chemistry related tools for KDE."
HOMEPAGE="http://kemistry.sourceforge.net"
SRC_URI="mirror://sourceforge/kemistry/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 sparc x86"
IUSE=""

DEPEND="kde-base/kdelibs
	|| ( kde-base/kdesdk-misc kde-base/kdesdk-meta kde-base/kdesdk )"
need-kde 3

src_unpack() {
	kde_src_unpack

	epatch ${FILESDIR}/${P}-gcc3.4.patch
	if use amd64; then
		epatch ${FILESDIR}/${P}-fPIC.patch
	fi
}

