# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/knoda/knoda-0.6.1_alpha3.ebuild,v 1.2 2003/10/02 18:30:05 mr_bones_ Exp $

inherit kde-base
need-kde 3

S=${WORKDIR}/knoda-0.6.1-test3

IUSE=""
DESCRIPTION="KDE database frontend based on the hk_classes library"
SRC_URI="mirror://sourceforge/sourceforge/knoda/knoda-0.6.1-test3.tar.bz2"
HOMEPAGE="http://hk-classes.sourceforge.net/"
LICENSE="GPL-2"
KEYWORDS="x86"

newdepend ">=dev-db/hk_classes-0.6"
