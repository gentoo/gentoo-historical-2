# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/furball/furball-0.5.ebuild,v 1.4 2002/07/11 06:30:09 drobbins Exp $

S=${WORKDIR}/${P}

DESCRIPTION="A handy backup script utilizing tar."
SRC_URI="http://www.claws-and-paws.com/software/furball/${P}.tgz"
HOMEPAGE="http://www.claws-and-paws.com/software/furball/index.shtml"
LICENSE="GPL-2"

RDEPEND="sys-devel/perl
	sys-apps/tar"

src_install() {

	cd ${S}

	dobin furball
	doman furball.1
	dodoc README NEWS THANKS

}
