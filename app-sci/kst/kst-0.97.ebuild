# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-sci/kst/kst-0.97.ebuild,v 1.5 2004/07/03 22:09:06 carlo Exp $

inherit kde

DESCRIPTION="A plotting and data viewing program for KDE"
HOMEPAGE="http://omega.astro.utoronto.ca/kst/"
SRC_URI="http://omega.astro.utoronto.ca/kst/${P}.tar.gz"

KEYWORDS="~x86 ~ppc ~sparc amd64"
LICENSE="GPL-2"

SLOT="0"
IUSE=""

DEPEND=">=kde-base/kdebase-3.1"
need-kde 3.1