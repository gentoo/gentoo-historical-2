# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdesdk-kfile-plugins/kdesdk-kfile-plugins-3.5.1.ebuild,v 1.1 2006/01/22 22:52:58 danarmak Exp $

KMNAME=kdesdk
KMMODULE="kfile-plugins"
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="kfile plugins for .cpp, .h, .diff and .ts files"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""
