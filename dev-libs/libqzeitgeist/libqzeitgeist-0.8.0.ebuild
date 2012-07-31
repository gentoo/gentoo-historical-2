# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libqzeitgeist/libqzeitgeist-0.8.0.ebuild,v 1.2 2012/07/31 10:46:15 kensington Exp $

EAPI=4

KDE_SCM="git"
PYTHON_DEPEND="2"

inherit python kde4-base

DESCRIPTION="Qt interface to the Zeitgeist event tracking system"
HOMEPAGE="https://projects.kde.org/projects/kdesupport/libqzeitgeist"
if [[ ${PV} != *9999* ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
else
	KEYWORDS=""
fi

LICENSE="GPL-2"
SLOT="4"
IUSE="debug"

RDEPEND="
	dev-libs/libzeitgeist
	x11-libs/qt-declarative:4
"
DEPEND="
	${RDEPEND}
	gnome-extra/zeitgeist
"

pkg_setup() {
	# gnome-extra/zeitgeist currently only
	# supports python-2
	python_set_active_version 2
	python_pkg_setup
	kde4-base_pkg_setup
}
