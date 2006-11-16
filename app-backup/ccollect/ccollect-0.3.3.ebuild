# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-backup/ccollect/ccollect-0.3.3.ebuild,v 1.4 2006/11/16 07:07:10 killerfox Exp $

DESCRIPTION="(pseudo) incremental backup with different exclude lists using
hardlinks and rsync"
HOMEPAGE="http://unix.schottelius.org/ccollect/"
SRC_URI="http://unix.schottelius.org/ccollect/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="hppa ppc x86"
IUSE="doc"

DEPEND="doc? ( >=app-text/asciidoc-7.0.2 )"
RDEPEND="sys-devel/bc
	net-misc/rsync"

src_compile() {
	if use doc; then
		make documentation
	else
		einfo 'Nothing to compile'
	fi
}

src_install() {
	dobin ccollect.sh

	if use doc; then
		dodoc doc/*

		# dodoc is not recursive. So do a workaround.
		insinto /usr/share/doc/${PF}/examples/
		doins -r ${S}/conf
	fi
}

