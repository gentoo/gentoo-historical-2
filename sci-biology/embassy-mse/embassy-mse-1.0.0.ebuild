# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/embassy-mse/embassy-mse-1.0.0.ebuild,v 1.1 2004/12/23 23:04:28 ribosome Exp $

inherit embassy

DESCRIPTION="EMBOSS integrated version of MSE - Multiple Sequence Editor"

KEYWORDS="x86 ~ppc"

src_install() {
	embassy_src_install
	insinto /usr/include/emboss/mse
	doins h/*.h
}
