# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/envtest/envtest-1.2.3-r4.ebuild,v 1.4 2003/03/28 05:36:51 carpaski Exp $

DESCRIPTION="This ebuild display the environment for an ebuild. It's for portage-testing purposes only and will _always_ fail."
HOMEPAGE="http://foo.bar.com/"
SRC_URI="ungabunga? http://www.twobit.net/spork"
LICENSE="as-is"
SLOT="0"
KEYWORDS="x86 sparc ppc alpha mips"
IUSE=""
DEPEND=""
S=${WORKDIR}/${P}

src_compile() {
	set | less
	die "Died on purpose. You aren't supposed to merge this. Have a nice day. :)"
}

src_install() {
	die "Have a nice day!"
}


