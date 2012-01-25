# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/ktp-send-file/ktp-send-file-0.3.0.ebuild,v 1.1 2012/01/25 22:53:24 johu Exp $

EAPI=4

KDE_MINIMAL="4.7"
KDE_LINGUAS="cs da de es et ga hu it ja lt nds nl pl pt pt_BR sv uk zh_CN zh_TW"
KDE_SCM="git"
inherit kde4-base

DESCRIPTION="KDE Telepathy file manager plugin to send files to contacts"
HOMEPAGE="http://community.kde.org/Real-Time_Communication_and_Collaboration"
if [[ ${PV} != *9999* ]]; then
	SRC_URI="mirror://kde/unstable/kde-telepathy/${PV}/src/${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
else
	KEYWORDS=""
fi

LICENSE="LGPL-2.1"
SLOT="4"
IUSE="debug"

DEPEND="
	>=net-im/ktp-common-internals-${PV}
	>=net-libs/telepathy-qt-0.9.0
"
RDEPEND="${DEPEND}
	>=net-im/ktp-contact-list-${PV}
	>=net-im/ktp-filetransfer-handler-${PV}
"
