# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdebindings-meta/kdebindings-meta-3.4.3.ebuild,v 1.4 2005/12/09 10:24:05 josejx Exp $
MAXKDEVER=$PV

inherit kde-functions
DESCRIPTION="kdebindings - merge this to pull in all kdebindings-derived packages"
HOMEPAGE="http://www.kde.org/"

LICENSE="GPL-2"
SLOT="3.4"
KEYWORDS="amd64 ppc sparc ~x86"
IUSE=""

# Unslotted packages aren't depended on via deprange
RDEPEND="
>=kde-base/dcopperl-3.4.1
>=kde-base/dcoppython-3.4.0_beta2
$(deprange 3.4.2 $MAXKDEVER kde-base/kalyptus)
$(deprange $PV $MAXKDEVER kde-base/kdejava)
$(deprange $PV $MAXKDEVER kde-base/kjsembed)
>=kde-base/korundum-$PV
$(deprange $PV $MAXKDEVER kde-base/qtjava)
>=kde-base/qtruby-$PV
$(deprange 3.4.2 $MAXKDEVER kde-base/smoke)"


# Omitted: qtsharp, dcopc, dcopjava, xparts (considered broken by upstream) 
