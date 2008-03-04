# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/konq-plugins/konq-plugins-3.5.8.ebuild,v 1.7 2008/03/04 06:59:36 jer Exp $

KMNAME=kdeaddons
KMNODOCS=true
MAXKDEVER=$PV
inherit kde-meta

DESCRIPTION="Various plugins for Konqueror."
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""
DEPEND="$(deprange-dual 3.5.6-r1 $MAXKDEVER kde-base/konqueror)
	!kde-misc/metabar"
RDEPEND="${DEPEND}
$(deprange 3.5.7 $MAXKDEVER kde-base/kdeaddons-docs-konq-plugins)"

# Don't install the akregator plugin, since it depends on akregator, which is
# a heavy dep.
KMEXTRACTONLY="konq-plugins/akregator"

# Fixes a parallel make issue (bug 112214)
PATCHES="${FILESDIR}/${PN}-parallel-make.patch"
