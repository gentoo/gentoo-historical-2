# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/ppc-dev-sources/ppc-dev-sources-2.6.ebuild,v 1.1 2004/05/30 23:10:08 pvdabeel Exp $

KEYWORDS="ppc"
DESCRIPTION="Dummy ebuild pointing the user to gentoo-dev-sources as 2.6 kernel (incl pegasos)"

src_unpack() {
	ewarn "Benh, upstream ppc kernel maintainer, has merged his tree with linus' tree"
	ewarn "this means a separate ppc 2.6 ebuild is no longer necessary. Use one of the"
	ewarn "following kernels:"
	ewarn " - gentoo-dev-sources (2.6 vanilla + performance enhancing patches + pegasos support"
	ewarn " - development-sources (2.6 vanilla - without pegasos support)"
	die
}
