# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/kio_gopher/kio_gopher-0.1.3.ebuild,v 1.1 2009/11/03 13:30:12 ssuominen Exp $

EAPI=2
KDE_LINGUAS="ar bg br ca cs cy da de el en_GB es et fr ga gl is it ka km lt lv
ms nb nds nl nn pa pl pt pt_BR ro ru rw sk sv ta tr uk zh_CN zh_TW"
inherit kde4-base

MY_P=${P}-kde4.3.1

DESCRIPTION="Gopher Kioslave for Konqueror"
HOMEPAGE="http://kgopher.berlios.de/"
SRC_URI="mirror://kde/stable/4.3.2/src/extragear/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND=">=kde-base/konqueror-${KDE_MINIMAL}"

S=${WORKDIR}/${MY_P}

DOCS="BUGS ChangeLog FAQ README"
