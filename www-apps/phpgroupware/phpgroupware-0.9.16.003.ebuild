# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/phpgroupware/phpgroupware-0.9.16.003.ebuild,v 1.1 2004/09/08 08:13:28 rl03 Exp $

inherit webapp

S=${WORKDIR}/${PN}

DESCRIPTION="intranet/groupware tool and application framework"
HOMEPAGE="http://www.phpgroupware.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
IUSE=""
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~alpha ~amd64 ~sparc ~hppa"

RDEPEND=">=dev-php/mod_php-4.1"

src_unpack() {
	unpack ${A}
	cd ${S}
	# remove CVS directories
	find . -type d -name 'CVS' -print | xargs rm -rf
}

src_install() {
	webapp_src_preinst

	cp -R . ${D}/${MY_HTDOCSDIR}
	dohtml ${PN}/doc/en_US/html/admin/*.html

	webapp_serverowned ${MY_HTDOCSDIR}/fudforum
#	webapp_serverowned ${MY_HTDOCSDIR}/phpgwapi/images

	webapp_postinst_txt en ${FILESDIR}/postinstall-en.txt
	webapp_src_install
}
