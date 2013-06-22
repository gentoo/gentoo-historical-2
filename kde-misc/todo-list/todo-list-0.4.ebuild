# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/todo-list/todo-list-0.4.ebuild,v 1.1 2013/06/22 21:50:42 creffett Exp $

EAPI=5

inherit kde4-base

MY_PN="todo_plasmoid"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="KDE4 plasmoid that shows a 'todo' list, using the korganizer 'Active calendar' resource file."
HOMEPAGE="http://kde-look.org/content/show.php/todo+list?content=90706"
SRC_URI="http://kde-look.org/CONTENT/content-files/90706-${MY_P}.tar.bz"

LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
SLOT="4"
IUSE="debug"

RDEPEND="
	$(add_kdebase_dep plasma-workspace)
"

S="${WORKDIR}/${MY_PN}"
