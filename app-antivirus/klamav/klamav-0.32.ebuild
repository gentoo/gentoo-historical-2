# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-antivirus/klamav/klamav-0.32.ebuild,v 1.1 2005/12/03 21:09:24 carlo Exp $

inherit kde

MY_P="${P}-source"
S="${WORKDIR}/${MY_P}/${P}"

DESCRIPTION="KDE frontend for the ClamAV antivirus."
HOMEPAGE="http://klamav.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

DEPEND="app-antivirus/clamav"

need-kde 3
