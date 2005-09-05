# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/net2ftp/net2ftp-0.82.ebuild,v 1.3 2005/09/05 10:34:59 uberlord Exp $

inherit eutils webapp

IUSE=""

MY_P=${PN}_v${PV}
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Web-based FTP client in php"
SRC_URI="http://www.net2ftp.com/download/${MY_P}.zip"
HOMEPAGE="http://www.net2ftp.com/"

LICENSE="GPL-2"
KEYWORDS="x86"

DEPEND="app-arch/unzip"
RDEPEND="virtual/php"

src_unpack() {
	unzip "${DISTDIR}/${MY_P}.zip" >/dev/null \
		|| die "failed to unpack ${MY_P}.zip"

	# We rename these files as it looks like Windows was
	# development platform
	# We also rename the version number as the doc dir is
	# versioned anyway
	cd "${S}"
	rename "_v${PV}" "" *.txt
	rename _ "" *.txt
	rename .txt "" *.txt

	# Fix footer to point to the new license name
	sed -i -e "s|_LICENSE.txt|LICENSE|" includes/html.inc.php
}

src_install() {
	webapp_src_preinst

	local docs="CREDITS INSTALL CHANGES TODO" doc

	dodoc ${docs} LICENSE
	for doc in ${docs}; do
		rm -f "${doc}"
	done

	rm -f temp/chmod_this_dir_to_777.txt

	insinto "${MY_HTDOCSDIR}"
	doins -r *

	webapp_serverowned "${MY_HTDOCSDIR}/temp"

	webapp_configfile "${MY_HTDOCSDIR}/settings.inc.php"
	webapp_configfile "${MY_HTDOCSDIR}/settings_authorizations.inc.php"
	webapp_configfile "${MY_HTDOCSDIR}/settings_screens.inc.php"

	webapp_sqlscript mysql create_tables.sql

	webapp_src_install
}
