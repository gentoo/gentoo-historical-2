# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/gpytage/gpytage-0.2.0.ebuild,v 1.1 2008/08/06 02:54:50 ken69267 Exp $

NEED_PYTHON="2.4"

inherit distutils

DESCRIPTION="GTK Utility to help manage Portage's user config files"
HOMEPAGE="https://gna.org/projects/gpytage"
SRC_URI="http://download.gna.org/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="dev-python/pygtk
	gnome-base/libglade"
