# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/taglib/taglib-1.0_beta2.ebuild,v 1.1 2003/12/09 13:04:38 caleb Exp $
inherit kde flag-o-matic

need-kde 3

LICENSE="GPL-2"
KEYWORDS="x86"
DESCRIPTION="A library for reading and editing audio meta data"
HOMEPAGE="http://ktown.kde.org/~wheeler/taglib"
SRC_URI="http://ktown.kde.org/~wheeler/${PN}/${PN}-0.96.tar.gz"

replace-flags "-O3 -O2"
