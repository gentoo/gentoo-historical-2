# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/krecipes/krecipes-2.0_alpha6.ebuild,v 1.2 2010/02/04 21:27:39 ssuominen Exp $

EAPI=2
KDE_LINGUAS="ca ca@valencia cs da de el en_GB eo es et fr ga gl hi hne is it ja
lt nb nds nl nn pl pt pt_BR ro sk sv tr uk zh_TW"
KDE_DOC_DIRS="doc doc-translations/%lingua_${PN}"
inherit kde4-base

DESCRIPTION="A KDE4 recipe application"
HOMEPAGE="http://krecipes.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P/_/-}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="4"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug +handbook"

DEPEND="
	dev-db/sqlite:3
	dev-libs/libxml2
	dev-libs/libxslt
	kde-base/qimageblitz
	>=kde-base/kdelibs-${KDE_MINIMAL}[semantic-desktop]
"

S=${WORKDIR}/${P/_/-}

DOCS="AUTHORS BUGS README TODO"
