# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/liberation-fonts/liberation-fonts-1.03.ebuild,v 1.2 2009/09/07 21:24:39 dirtyepic Exp $

inherit font

DESCRIPTION="A GPL-2 Helvetica/Times/Courier replacement TrueType font set, courtesy of Red Hat"
SRC_URI="https://fedorahosted.org/releases/l/i/${PN}/${P}.tar.gz"
HOMEPAGE="https://fedorahosted.org/liberation-fonts"
KEYWORDS="alpha amd64 ~ia64 ppc ppc64 sparc x86 ~x86-fbsd"
SLOT="0"
LICENSE="GPL-2-with-exceptions"
IUSE="X"
RDEPEND="${DEPEND}"

FONT_SUFFIX="ttf"
DOCS="License.txt"

FONT_CONF=( "${FILESDIR}/60-liberation.conf" )
