# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/kio-ftps/kio-ftps-0.2.ebuild,v 1.1 2009/05/30 09:45:56 scarabeus Exp $

EAPI="2"

inherit kde4-base

DESCRIPTION="A ftps KIO slave for KDE"
HOMEPAGE="http://kasablanca.berlios.de/kio-ftps/"
SRC_URI="mirror://berlios/kasablanca/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# This is just for some app we can use kio-ftps with
RDEPEND="|| (
	>=kde-base/konqueror-${KDE_MINIMAL}
	>=kde-base/dolphin-${KDE_MINIMAL}
)"

S="${WORKDIR}/${PN}"

src_prepare() {
	# remove all temp files
	rm -rf *~
	# fix linking
	sed -i \
		-e "s:\${KDE4_KDECORE_LIBS}:\${KDE4_KIO_LIBS}:g" \
		CMakeLists.txt || die "sed linking failed"
}
