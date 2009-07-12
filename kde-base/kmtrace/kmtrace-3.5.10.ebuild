# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kmtrace/kmtrace-3.5.10.ebuild,v 1.6 2009/07/12 10:42:37 armin76 Exp $

KMNAME=kdesdk
EAPI="1"
inherit kde-meta

DESCRIPTION="kmtrace - A KDE tool to assist with malloc debugging using glibc's \"mtrace\" functionality"
KEYWORDS="alpha amd64 hppa ~ia64 ppc ppc64 sparc x86"
IUSE="kdehiddenvisibility"

DEPEND="sys-libs/glibc" # any other libc won't work, says the README file
RDEPEND="${DEPEND}"
