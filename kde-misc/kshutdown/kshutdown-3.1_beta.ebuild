# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/kshutdown/kshutdown-3.1_beta.ebuild,v 1.1 2013/12/20 01:35:21 mrueg Exp $

EAPI=5

KDE_MINIMAL="4.8"
KDE_LINGUAS="ar bg cs da de el es fr hu it nb nl pl pt pt_BR ru sk sr
sr@ijekavian sr@ijekavianlatin sr@latin sv tr zh_CN"
inherit kde4-base

MY_P=${PN}-source-${PV/_}

DESCRIPTION="A shutdown manager for KDE"
HOMEPAGE="http://kshutdown.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.zip"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug"

RDEPEND="
	$(add_kdebase_dep libkworkspace)
"
DEPEND="${RDEPEND}
	app-arch/unzip
"

S=${WORKDIR}/${P/_}
