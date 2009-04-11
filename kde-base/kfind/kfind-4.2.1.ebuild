# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kfind/kfind-4.2.1.ebuild,v 1.6 2009/04/11 04:34:18 jer Exp $
EAPI="2"

KMNAME="kdebase-apps"
inherit kde4-meta

DESCRIPTION="KDE file finder utility"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86"
IUSE="debug"

KMEXTRA="
	doc/${PN}/
"

src_prepare() {
	kde4-meta_src_prepare

	# Note that this is already fixed for 4.2.2
	sed -i -e 's/ konq / /' \
		kfind/CMakeLists.txt || die "failed to disable libkonq from link"
}
