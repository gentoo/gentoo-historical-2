# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdesdk/kdesdk-3.5.6.ebuild,v 1.4 2007/02/16 21:56:33 flameeyes Exp $

inherit db-use kde-dist

DESCRIPTION="KDE SDK: Cervisia, KBabel, KCachegrind, Kompare, Umbrello,..."

KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc ~x86"
IUSE="berkdb kdehiddenvisibility subversion"

DEPEND="x86? ( >=dev-util/valgrind-3.2.0 )
	subversion? ( dev-util/subversion )
	berkdb? ( =sys-libs/db-4* )"

RDEPEND="${DEPEND}
	dev-util/cvs
	media-gfx/graphviz"

DEPEND="${RDEPEND}
	sys-devel/flex"

src_compile() {
	local myconf="$(use_with subversion)"

	if use berkdb; then
		myconf="${myconf} --with-berkeley-db --with-db-lib="$(db_libname)"
			--with-extra-includes=$(db_includedir)"
	else
		myconf="${myconf} --without-berkeley-db"
	fi

	kde_src_compile
}
