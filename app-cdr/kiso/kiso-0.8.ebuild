# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/kiso/kiso-0.8.ebuild,v 1.1 2005/05/01 13:45:57 carlo Exp $

inherit kde

DESCRIPTION="KIso is a fronted for KDE to make it as easy as possible to create manipulate and extract CD Image files."
HOMEPAGE="http://kiso.sourceforge.net/"
SRC_URI="mirror://sourceforge/kiso/${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64 ~ppc"

SLOT="0"
IUSE=""

DEPEND=">=dev-libs/libcdio-0.73"
RDEPEND="${DEPEND}
	app-cdr/cdrtools
	app-admin/sudo"

need-kde 3.2