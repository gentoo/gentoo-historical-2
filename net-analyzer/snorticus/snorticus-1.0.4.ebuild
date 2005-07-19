# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/snorticus/snorticus-1.0.4.ebuild,v 1.9 2005/07/19 16:34:10 dholm Exp $

inherit eutils

DESCRIPTION="Snorticus is a collection of shell scripts designed to allow easy management of Snort sensors."
HOMEPAGE="http://snorticus.baysoft.net/"
SRC_URI="http://snorticus.baysoft.net/snorticus/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc x86"
IUSE=""

DEPEND=""
RDEPEND="
	app-shells/tcsh
	net-analyzer/snort
	net-analyzer/snortsnarf
	sys-apps/coreutils
	net-misc/openssh"

src_unpack() {
	unpack ${A}
	cd ${S}

	epatch ${FILESDIR}/${P}-gentoo.patch

	for file in hourly_wrapup.sh push_rules.sh retrieve_wrapup.sh
	do
		sed -i s:/usr/bin/csh:/bin/csh: $file
	done
}

src_install () {
	dodoc COPYING
	dohtml snorticus.html

	dodir /etc/snort/addons/
	dodir /usr/lib/snort/addons/snorticus/

	insinto /usr/lib/snort/addons/snorticus
	doins hourly_wrapup.sh push_rules.sh retrieve_wrapup.sh

	dodir /home/httpd/htdocs/snorticus
	dosym /home/httpd/htdocs/snorticus /usr/lib/snort/addons/snorticus/LOGS
}

pkg_postinst() {
	einfo 'Add the following into a cronjob somewhere for a sensor box.'
	einfo ''
	einfo '01 * * * * /usr/lib/snort/addons/snorticus/hourly_wrapup.sh > /dev/null 2>&1'
	einfo ''
	einfo 'Add the following into a cronjob somewhere for an analyst box.'
	einfo ''
	einfo '15 * * * * /usr/lib/snort/addons/snorticus/retrieve_wrapup.sh MySite1 mysensor.blah.blah > /dev/null 2>&1'
}
