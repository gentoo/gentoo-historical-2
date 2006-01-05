# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/editobj/editobj-0.5.6.ebuild,v 1.3 2006/01/05 14:43:29 metalgod Exp $

inherit distutils

MY_P=${P/editobj/EditObj}
IUSE=""
DESCRIPTION="EditObj can create a dialog box to edit ANY Python object. It also includes a Tk tree widget, an event and a multiple undo-redo frameworks."
SRC_URI="http://download.gna.org/songwrite/${MY_P}.tar.gz"
HOMEPAGE="http://home.gna.org/oomadness/en/editobj/index.html"
KEYWORDS="~amd64 ~ppc x86"
SLOT="0"
LICENSE="GPL-2"
DEPEND="virtual/x11
	virtual/opengl
	>=dev-lang/python-2.2.2
	>=dev-lang/tk-8.3"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	distutils_python_tkinter
}
