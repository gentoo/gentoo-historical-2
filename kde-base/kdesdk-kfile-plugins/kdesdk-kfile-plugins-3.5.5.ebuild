# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdesdk-kfile-plugins/kdesdk-kfile-plugins-3.5.5.ebuild,v 1.2 2006/11/13 10:37:27 opfer Exp $

KMNAME=kdesdk
KMMODULE="kfile-plugins"
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="kfile plugins for .cpp, .h, .diff and .ts files"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc x86 ~x86-fbsd"
IUSE=""
