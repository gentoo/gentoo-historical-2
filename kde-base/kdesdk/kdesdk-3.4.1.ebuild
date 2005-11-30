# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdesdk/kdesdk-3.4.1.ebuild,v 1.1.1.1 2005/11/30 10:12:47 chriswhite Exp $

inherit kde-dist

DESCRIPTION="KDE SDK: Cervisia, KBabel, KCachegrind, Kompare, Umbrello,..."

KEYWORDS="amd64 hppa ppc sparc x86"
IUSE="subversion"

DEPEND="x86? ( dev-util/callgrind )
	media-gfx/graphviz
	sys-devel/flex
	subversion? ( dev-util/subversion )"

RDEPEND="${DEPEND}
	dev-util/cvs"
