# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-sci/klogic/klogic-1.6.ebuild,v 1.3 2004/06/24 22:04:55 agriffis Exp $

inherit kde-base

DESCRIPTION="KLogic is an application for easy creation and simulation of electrical circuits"
HOMEPAGE="http://www.a-rostin.de/klogic/"
KEYWORDS="~x86 ~ppc"
SRC_URI="http://www.a-rostin.de/klogic/Version/${P}.tar.gz"

LICENSE="GPL-2"

need-kde 3
