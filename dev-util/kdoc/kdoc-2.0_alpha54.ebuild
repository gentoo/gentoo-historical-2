# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/kdoc/kdoc-2.0_alpha54.ebuild,v 1.16 2009/10/17 12:26:59 ssuominen Exp $

inherit kde

MY_P=${P/_alph/}

DESCRIPTION="KDE/QT documentation processing/generation tools"
HOMEPAGE="http://www.ph.unimelb.edu.au/~ssk/kde/kdoc/"
SRC_URI="mirror://gentoo/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 sparc ppc amd64"
IUSE="kdeenablefinal"

DEPEND="dev-lang/perl"

# Bug 279709.
RESTRICT="test"

S=${WORKDIR}/${MY_P}
