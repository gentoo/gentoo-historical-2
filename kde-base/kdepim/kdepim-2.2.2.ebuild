# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Dan Armak <danarmak@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdepim/kdepim-2.2.2.ebuild,v 1.1 2001/11/22 17:32:27 verwilst Exp $
. /usr/portage/eclass/inherit.eclass || die
inherit kde-dist || die

DESCRIPTION="${DESCRIPTION}PIM"

DEPEND="$DEPEND >=dev-libs/pilot-link-0.9.0 sys-devel/perl"

RDEPEND="$RDEPEND >=dev-libs/pilot-link-0.9.0"

src_install() {
	kde_src_install all
	docinto html
	dodoc *.html
}
