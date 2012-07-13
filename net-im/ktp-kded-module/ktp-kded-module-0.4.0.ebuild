# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/ktp-kded-module/ktp-kded-module-0.4.0.ebuild,v 1.1 2012/07/13 14:30:32 johu Exp $

EAPI=4

KDE_LINGUAS="ca cs da de el es et fi fr ga gl hu it ja lt nb nds nl pl pt pt_BR
sk sr sr@ijekavian sr@ijekavianlatin sr@latin sv uk zh_CN zh_TW"
KDE_SCM="git"
MY_P=${PN/kded/kded-integration}-${PV}
inherit kde4-base

DESCRIPTION="KDE Telepathy workspace integration"
HOMEPAGE="http://community.kde.org/Real-Time_Communication_and_Collaboration"
if [[ ${PV} != *9999* ]]; then
	SRC_URI="mirror://kde/unstable/kde-telepathy/${PV}/src/${MY_P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
else
	KEYWORDS=""
fi

LICENSE="LGPL-2.1"
SLOT="4"
IUSE="debug"

DEPEND="
	>=net-im/ktp-common-internals-${PV}
	>=net-libs/telepathy-qt-0.9.1
"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}
