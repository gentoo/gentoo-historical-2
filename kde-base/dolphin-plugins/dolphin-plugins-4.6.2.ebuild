# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/dolphin-plugins/dolphin-plugins-4.6.2.ebuild,v 1.3 2011/05/09 08:48:24 tomka Exp $

EAPI=3

KMNAME="kdesdk"
inherit kde4-meta

DESCRIPTION="Extra Dolphin plugins"
KEYWORDS="~amd64 ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug +git +subversion"

DEPEND="
	$(add_kdebase_dep libkonq)
"
RDEPEND="${DEPEND}
	$(add_kdebase_dep kompare)
	git? ( dev-vcs/git )
	subversion? ( dev-vcs/subversion )
"

# SCM plugins moved from dolphin somewhere before 4.4.75
add_blocker dolphin '<4.4.75'

KMLOADLIBS="libkonq"

src_prepare() {
	echo 'macro_optional_add_subdirectory ( dolphin-plugins )' >> CMakeLists.txt || die
	echo > dolphin-plugins/CMakeLists.txt || die
	use git && echo 'add_subdirectory ( git )' >> dolphin-plugins/CMakeLists.txt
	use subversion && echo 'add_subdirectory ( svn )' >> dolphin-plugins/CMakeLists.txt

	kde4-meta_src_prepare
}

src_install() {
	( ! use git && ! use subversion ) || kde4-meta_src_install
}
