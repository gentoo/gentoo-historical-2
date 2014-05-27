# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/lxqt-base/lxqt-runner/lxqt-runner-0.7.0.ebuild,v 1.1 2014/05/27 15:37:56 jauhien Exp $

EAPI=5
inherit cmake-utils

DESCRIPTION="LXQt quick launcher"
HOMEPAGE="http://www.lxqt.org/"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://git.lxde.org/git/lxde/${PN}.git"
else
	SRC_URI="http://lxqt.org/downloads/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
	S=${WORKDIR}
fi

LICENSE="GPL-2 LGPL-2.1+"
SLOT="0"

RDEPEND="dev-qt/qtcore:4
	dev-qt/qtdbus:4
	dev-qt/qtgui:4
	dev-qt/qtscript:4
	lxqt-base/liblxqt
	lxqt-base/lxqt-globalkeys
	>=lxde-base/menu-cache-0.5.1
	razorqt-base/libqtxdg
	x11-libs/libX11"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
