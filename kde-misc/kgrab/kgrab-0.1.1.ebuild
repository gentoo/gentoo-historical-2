# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/kgrab/kgrab-0.1.1.ebuild,v 1.1 2008/04/05 16:50:27 philantrop Exp $

EAPI="1"

KDE_PV="4.0.3"
KDE_LINGUAS="ar be bg de el et fr ga gl it ja km lt nb nds nl nn pa pl pt pt_BR
ro se sk sv th tr uk vi zh_CN"

SLOT="kde-4"
NEED_KDE=":${SLOT}"
inherit kde4-base

DESCRIPTION="KDE Screen Grabbing Utility"
HOMEPAGE="http://www.kde.org/"
LICENSE="GPL-2 LGPL-2"
SRC_URI="mirror://kde/stable/${KDE_PV}/src/extragear/${P}.tar.bz2"

KEYWORDS="~amd64 ~x86"
IUSE="debug"

PREFIX="${KDEDIR}"

RDEPEND=""
DEPEND="${RDEPEND}
	sys-devel/gettext
	x11-proto/xextproto"
