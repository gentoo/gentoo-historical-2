# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/kopete-otr/kopete-otr-0.2.ebuild,v 1.4 2007/05/02 20:32:43 gustavoz Exp $

inherit kde

DESCRIPTION="This plugin enables Off-The-Record encryption for the KDE instant messenger Kopete."
HOMEPAGE="http://kopete-otr.follefuder.org/"
SRC_URI="http://kopete-otr.follefuder.org/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

#FIXME Fix deps before KDE-4
DEPEND=">=net-libs/libotr-3.0.0
		|| ( >=kde-base/kopete-3.5.5-r2 >=kde-base/kdenetwork-3.5.5-r2 )"

PATCHES="${FILESDIR}"/${P}-as-needed.patch

need-kde 3.5.5

src_unpack() {
	kde_src_unpack
	rm -f "${S}/configure"
}
