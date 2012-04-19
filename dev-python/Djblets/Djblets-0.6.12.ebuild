# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/Djblets/Djblets-0.6.12.ebuild,v 1.1 2012/04/19 07:34:09 patrick Exp $

EAPI="3"
PYTHON_DEPEND="2"

inherit distutils versionator

DESCRIPTION="A collection of useful extensions for Django"
HOMEPAGE="http://github.com/djblets"
SRC_URI="http://downloads.reviewboard.org/releases/${PN}/$(get_version_component_range 1-2)/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/django
	dev-python/imaging"

PYTHON_MODNAME="djblets"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}
