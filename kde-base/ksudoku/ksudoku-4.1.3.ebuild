# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/ksudoku/ksudoku-4.1.3.ebuild,v 1.2 2008/11/16 08:05:48 vapier Exp $

EAPI="2"

KMNAME=kdegames
OPENGL_REQUIRED="always"
inherit kde4-meta

DESCRIPTION="KDE Sudoku"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="debug htmlhandbook"

RDEPEND="!kdeprefix? ( !games-puzzle/ksudoku )"
