# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/gnomesu/gnomesu-0.3.1-r2.ebuild,v 1.2 2006/09/06 04:51:40 kumba Exp $

inherit gnome2 eutils autotools

DESCRIPTION="GNOME2 interface to su, previously xsu and xsu2"
HOMEPAGE="http://sourceforge.net/projects/xsu/"
SRC_URI="mirror://sourceforge/xsu/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2
	>=dev-libs/glib-2
	>=gnome-base/libgnome-2
	>=gnome-base/libgnomeui-2
	>=x11-libs/libzvt-2"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_unpack() {
	unpack ${A}
	cd ${S}

	# add encoding to desktop and menu icon fs location
	# fixes #83949
	# keep other changes from patch before
	epatch ${FILESDIR}/${P}-r1-desktopfix.patch

	# Fix greyed out buttons.  Bug #131290
	epatch ${FILESDIR}/${P}-export-dynamic.patch

	eautoreconf
}

src_install() {
	gnome2_src_install xsudocdir=/usr/share/doc/${PF}
}
