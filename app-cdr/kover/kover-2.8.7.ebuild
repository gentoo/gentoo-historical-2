# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/kover/kover-2.8.7.ebuild,v 1.5 2003/03/28 12:01:42 pvdabeel Exp $

inherit kde-base || die

need-kde 3

IUSE=""
DESCRIPTION="KDE CD Writing Software"
SRC_URI="http://lisas.de/${PN}/${P}.tar.gz"
HOMEPAGE="http://lisas.de/kover"
LICENSE="GPL-2"
KEYWORDS="x86 ppc"

newdepend "media-libs/libvorbis"

