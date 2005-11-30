# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/klapjack/klapjack-0.4.2.ebuild,v 1.1.1.1 2005/11/30 09:55:12 chriswhite Exp $

inherit kde-base

LICENSE="GPL-2"
DESCRIPTION="KLapJack - a KDE client for the popular online journal site LiveJournal."
SRC_URI="mirror://sourceforge/klapjack/${P}.tar.gz"
HOMEPAGE="http://klapjack.sourceforge.net/"
KEYWORDS="~x86"
DEPEND=">=kde-base/kdebase-3.0
	$(qt_min_version 3.1)
	>=media-sound/xmms-1.2.7
	>=dev-libs/xmlrpc-c-0.9.9"
