# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/ApE/ApE-1.17.ebuild,v 1.1 2009/02/17 03:54:29 je_fro Exp $

inherit eutils

DESCRIPTION="ApE - A Plasmid Editor"
HOMEPAGE="http://www.biology.utah.edu/jorgensen/wayned/ape/"
SRC_URI="http://www.biology.utah.edu/jorgensen/wayned/ape/Download/ApE_linux_current.zip"

LICENSE="ApE"
RESTRICT="mirror"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="dev-lang/tcl"

src_compile() {
	echo
	einfo "Nothing to compile."
	echo
}

src_install() {

cat >> "${T}/ApE" << EOF
#!/bin/bash
exec tclsh /usr/share/${P}/AppMain.tcl
EOF

exeinto /usr/bin
doexe "${T}/ApE"
insinto "/usr/share/${P}"
doins -r "${WORKDIR}"/ApE\ Linux/*
make_desktop_entry ${PN} \
		ApE \
		"/usr/share/${P}/Accessory Files/Icons and images/monkey_icon.gif" \
		"Application;Graphics;Science"
}
