# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Jerry A! <jerry@thehutt.org>
# $Header: /var/cvsroot/gentoo-x86/x11-misc/gkrellmlaunch/gkrellmlaunch-0.3.ebuild,v 1.3 2002/04/14 14:07:27 seemant Exp $

S=${WORKDIR}/${P}
DESCRIPTION="a Program-Launcher Plugin for GKrellM"
SRC_URI="http://prdownloads.sourceforge.net/gkrellmlaunch/${P}.tar.gz"

HOMEPAGE="http://gkrellmlaunch.sourceforge.net/"
DEPEND=">=app-admin/gkrellm-1.2.1"

src_compile() {
	make || die
}

src_install () {
	insinto /usr/lib/gkrellm/plugins
	doins gkrellmlaunch.so

	dodoc README  
}
