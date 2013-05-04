# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/zinnia-tomoe/zinnia-tomoe-0.6.0_p20080911.ebuild,v 1.1 2013/05/04 05:22:49 naota Exp $

EAPI=4

inherit autotools-utils

MY_P=${P/_p/-}

DESCRIPTION="Handwriting model files trained with Tomoe data"
HOMEPAGE="http://zinnia.sourceforge.net/index.html"
SRC_URI="mirror://sourceforge/zinnia/${MY_P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${MY_P}

AUTOTOOLS_IN_SOURCE_BUILD=1
