# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/rekonq/rekonq-0.3.90.ebuild,v 1.1 2010/02/12 08:42:17 ssuominen Exp $

EAPI=2
WEBKIT_REQUIRED=always
KDE_DOC_DIRS="docs"
inherit kde4-base

DESCRIPTION="A browser based on qt-webkit"
HOMEPAGE="http://rekonq.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug +handbook"

DEPEND=">=x11-libs/qt-gui-4.5:4[dbus]"

DOCS="AUTHORS ChangeLog TODO"
