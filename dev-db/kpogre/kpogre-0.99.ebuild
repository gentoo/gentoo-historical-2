# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/kpogre/kpogre-0.99.ebuild,v 1.1 2004/08/22 03:26:33 nakano Exp $

inherit kde eutils

DESCRIPTION="PostgreSQL graphical frontend for KDE"
HOMEPAGE="http://kpogre.sourceforge.net/"
SRC_URI="mirror://sourceforge/kpogre/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc"
IUSE=""

DEPEND="dev-db/postgresql
	>=dev-libs/libpqxx-2.2.1"

need-kde 3.2

