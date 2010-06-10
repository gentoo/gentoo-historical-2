# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/mythbrowser/mythbrowser-0.23_p25065.ebuild,v 1.1 2010/06/10 14:43:44 cardoe Exp $

EAPI=2
inherit qt4 mythtv-plugins

DESCRIPTION="Web browser module for MythTV."
IUSE=""
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND=">=x11-libs/qt-webkit-4.5:4"
DEPEND="${RDEPEND}"
