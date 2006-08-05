# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdesdk-kfile-plugins/kdesdk-kfile-plugins-3.5.1.ebuild,v 1.9 2006/08/05 00:22:57 weeve Exp $

KMNAME=kdesdk
KMMODULE="kfile-plugins"
MAXKDEVER=3.5.2
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="kfile plugins for .cpp, .h, .diff and .ts files"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"
IUSE=""
