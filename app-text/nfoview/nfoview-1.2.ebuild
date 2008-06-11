# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/nfoview/nfoview-1.2.ebuild,v 1.1 2008/06/11 00:20:43 vapier Exp $

ESVN_REPO_URI="svn://svn.gna.org/svn/nfoview/trunk"
inherit distutils
[[ ${PV} == "9999" ]] && inherit subversion

DESCRIPTION="simple viewer for NFO files, which are ASCII art in the CP437 codepage"
HOMEPAGE="http://home.gna.org/nfoview/"
[[ ${PV} != "9999" ]] && SRC_URI="http://download.gna.org/nfoview/${PV}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/pygtk"
