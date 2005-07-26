# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/ksystemlog/ksystemlog-0.3.1.ebuild,v 1.2 2005/07/26 10:05:26 dholm Exp $

inherit kde

DESCRIPTION="KSystemLog is a system log viewer for KDE."
SRC_URI="http://annivernet.free.fr/ksystemlog/archives/src/${P}.tar.bz2"
HOMEPAGE="http://annivernet.free.fr/ksystemlog/"
LICENSE="GPL-2"
RESTRICT="nomirror"

IUSE=""
KEYWORDS="~amd64 ~ppc ~x86"
SLOT="0"

need-kde 3.3
