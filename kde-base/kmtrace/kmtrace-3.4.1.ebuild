# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kmtrace/kmtrace-3.4.1.ebuild,v 1.8 2005/12/09 10:08:23 josejx Exp $

KMNAME=kdesdk
MAXKDEVER=3.4.3
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta

DESCRIPTION="kmtrace - A KDE tool to assist with malloc debugging using glibc's \"mtrace\" functionality"
KEYWORDS="amd64 ppc ppc64 sparc x86"
IUSE=""
DEPEND="sys-libs/glibc" # any other libc won't work, says the README file

