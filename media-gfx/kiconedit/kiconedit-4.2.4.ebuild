# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/kiconedit/kiconedit-4.2.4.ebuild,v 1.1 2009/07/22 23:10:28 wired Exp $

EAPI="2"

KDE_LINGUAS="af ar be bg br ca cs cy da de el en_GB eo es et eu fa fi fr ga gl
	he hi hr hu is it ja km ko lt lv mk ms nb nds ne nl nn oc pa pl pt pt_BR
	ro ru se sk sl sv ta tg th tr uk vi wa xh zh_CN zh_HK zh_TW"

KDE_DOC_DIRS="doc doc-translations/%lingua_${PN}"

KMNAME="extragear/graphics"
inherit kde4-base

DESCRIPTION="KDE Icon Editor"
HOMEPAGE="http://www.kde.org/"
SRC_URI="mirror://kde/stable/${PV}/src/extragear/${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="4"
IUSE="debug +handbook"
