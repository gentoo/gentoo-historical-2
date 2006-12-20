# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xarchiver/xarchiver-0.4.6.ebuild,v 1.2 2006/12/20 07:24:17 jer Exp $

inherit xfce44

DESCRIPTION="Xfce4 archiver"
HOMEPAGE="http://xarchiver.xfce.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

KEYWORDS="~amd64 ~ppc ~x86"
IUSE="7zip ace arj lha rar rpm zip"

DEPEND="dev-util/intltool
	>=x11-libs/gtk+-2.6
	>=dev-libs/glib-2.6
	zip? ( app-arch/unzip
		app-arch/zip )
	ace? ( app-arch/unace
		dev-libs/ace )
	rar? ( app-arch/rar )
	7zip? ( app-arch/p7zip )
	rpm? ( app-arch/rpm )
	arj? ( app-arch/arj
		app-arch/unarj )
	lha? ( app-arch/lha )"
