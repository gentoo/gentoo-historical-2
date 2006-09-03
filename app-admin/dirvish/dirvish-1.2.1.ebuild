# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/dirvish/dirvish-1.2.1.ebuild,v 1.4 2006/09/03 01:15:28 weeve Exp $

DESCRIPTION="Dirvish is a fast, disk based, rotating network backup system."
HOMEPAGE="http://www.dirvish.org/"
SRC_URI="http://dirvish.org/${P}.tgz"

LICENSE="OSL-2.0"
SLOT="0"
KEYWORDS="~ppc ~sparc x86"
IUSE=""

DEPEND="app-arch/tar"
RDEPEND="dev-perl/Time-modules
	dev-perl/Period
	>=net-misc/rsync-2.5.7"

src_compile() {
	for f in dirvish dirvish-runall dirvish-expire dirvish-locate ; do
		cat > $f  <<-EOF
		#!/usr/bin/perl

		\$CONFDIR = "/etc/dirvish";

		EOF
		cat $f.pl >> $f
		cat loadconfig.pl >> $f
	done
}

src_install() {
	dosbin dirvish dirvish-runall dirvish-expire dirvish-locate
	doman dirvish.8 dirvish-runall.8 dirvish-expire.8 dirvish-locate.8 dirvish.conf.5
	dohtml FAQ.html INSTALL RELEASE.html TODO.html
	dodoc CHANGELOG COPYING

	insinto /etc/dirvish; doins ${FILESDIR}/master.conf.example
}
