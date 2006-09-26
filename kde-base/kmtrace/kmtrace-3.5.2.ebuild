# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kmtrace/kmtrace-3.5.2.ebuild,v 1.12 2006/09/26 19:21:22 deathwing00 Exp $

KMNAME=kdesdk
MAXKDEVER=3.5.4
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta

DESCRIPTION="kmtrace - A KDE tool to assist with malloc debugging using glibc's \"mtrace\" functionality"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"
IUSE=""
DEPEND="sys-libs/glibc" # any other libc won't work, says the README file

RDEPEND="${DEPEND}"

