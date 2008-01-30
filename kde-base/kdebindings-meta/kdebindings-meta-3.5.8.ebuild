# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdebindings-meta/kdebindings-meta-3.5.8.ebuild,v 1.4 2008/01/30 17:23:37 ranger Exp $
MAXKDEVER=$PV

inherit kde-functions
DESCRIPTION="kdebindings - merge this to pull in all kdebindings-derived packages"
HOMEPAGE="http://www.kde.org/"

LICENSE="GPL-2"
SLOT="3.5"
KEYWORDS="amd64 ~ppc ppc64 x86"
IUSE=""

# Unslotted packages aren't depended on via deprange
RDEPEND="
	$(deprange $PV $MAXKDEVER kde-base/kalyptus)
	$(deprange $PV $MAXKDEVER kde-base/smoke)
	$(deprange $PV $MAXKDEVER kde-base/kdejava)
	$(deprange $PV $MAXKDEVER kde-base/qtjava)
	$(deprange $PV $MAXKDEVER kde-base/kjsembed)
	>=kde-base/dcopperl-3.5.0_beta2
	>=kde-base/dcoppython-3.5.0_beta2
	>=kde-base/korundum-$PV
	>=kde-base/qtruby-$PV"

# Omitted: qtsharp, dcopc, dcopjava, xparts (considered broken by upstream)
