# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-sci/ksimus-boolean/ksimus-boolean-0.3.6.ebuild,v 1.6 2004/12/28 15:22:15 ribosome Exp $

inherit kde

HOMEPAGE="http://ksimus.berlios.de/"
DESCRIPTION="The package Boolean contains some boolean components for KSimus."
KEYWORDS="x86"
SRC_URI="http://ksimus.berlios.de/download/ksimus-boolean-3-${PV}.tar.gz"

LICENSE="GPL-2"
IUSE=""
SLOT="0"

DEPEND="sci-mathematics/ksimus"

need-kde 3
