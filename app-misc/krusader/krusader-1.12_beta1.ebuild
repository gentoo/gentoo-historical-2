# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/krusader/krusader-1.12_beta1.ebuild,v 1.1 2003/01/02 20:06:01 hannes Exp $

IUSE=""

inherit kde-base

need-kde 3

MY_P=${P/_/-}
DESCRIPTION="An oldschool Filemanager for KDE"
HOMEPAGE="http:/krusader.sourceforge.net/"
SRC_URI="http://krusader.sourceforge.net/dev/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"
LICENSE="GPL-2"
KEYWORDS="~x86"
