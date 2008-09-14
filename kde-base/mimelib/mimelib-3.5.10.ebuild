# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/mimelib/mimelib-3.5.10.ebuild,v 1.1 2008/09/14 00:00:31 carlo Exp $

KMNAME=kdepim
EAPI="1"
inherit kde-meta eutils

DESCRIPTION="KDE mime library"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

PATCHES="${FILESDIR}/mimelib-3.5.9-gcc-4.3-testsuite.patch"
