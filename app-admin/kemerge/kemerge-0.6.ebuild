# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/kemerge/kemerge-0.6.ebuild,v 1.4 2002/10/18 13:31:45 aliz Exp $
inherit kde-base

need-kde 3
DESCRIPTION="Graphical KDE emerge tool"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
HOMEPAGE="http://kemerge.sourceforge.net/"

LICENSE="GPL-2"
KEYWORDS="x86 sparc sparc64" # ppc compilation failure - see Changelog

IUSE=""
