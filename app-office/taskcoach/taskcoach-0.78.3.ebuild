# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/taskcoach/taskcoach-0.78.3.ebuild,v 1.1 2010/01/31 20:18:56 caster Exp $

EAPI=1

inherit distutils eutils

MY_PN="TaskCoach"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Simple personal tasks and todo lists manager"
HOMEPAGE="http://www.taskcoach.org"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND=">=dev-lang/python-2.4
	>=dev-python/wxpython-2.8.9.2:2.8"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

# disappeared in 0.73.2, maybe will appear again?
#DOCS="CHANGES.txt"

src_unpack() {
	distutils_src_unpack

	cd "${S}"
	elog "Removing Funambol support, works only on x86 and python 2.5."
	rm -fv taskcoachlib/bin.in/linux/*.so || die
}

src_compile() {
	# upstream now sets executable to /usr/bin/python2.5
	distutils_src_compile --executable=/usr/bin/python
}

src_install() {
	distutils_src_install

	mv "${D}/usr/bin/taskcoach.py" "${D}/usr/bin/taskcoach" || die

	doicon "icons.in/${PN}.png" || die
	make_desktop_entry ${PN} "Task Coach" ${PN} Office || die
}
