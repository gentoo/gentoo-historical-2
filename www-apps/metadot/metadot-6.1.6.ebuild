# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/metadot/metadot-6.1.6.ebuild,v 1.4 2004/09/03 17:17:20 pvdabeel Exp $

inherit webapp
MY_P=${P/-/}
S=${WORKDIR}/${PN}

IUSE=""

DESCRIPTION="Metadot is a CMS with file, page and link management, and collaboration features."
HOMEPAGE="http://www.metadot.com"
SRC_URI="http://download.metadot.com/${MY_P}.tar.gz"

KEYWORDS="~x86 ppc"

RDEPEND="
	>=dev-db/mysql-3.23
	>=net-www/apache-1.3.6
	>=dev-lang/perl-5.005
	>=dev-perl/mod_perl-1.21
	dev-perl/DBI
	dev-perl/DBD-mysql
	dev-perl/Apache-DBI
	dev-perl/XML-RSS
	dev-perl/Storable
	dev-perl/perl-ldap
	dev-perl/Log-Agent
	dev-perl/Mail-POP3Client
	dev-perl/IO-stringy
	dev-perl/MailTools
	dev-perl/MIME-tools
	dev-perl/Unicode-String
	dev-perl/Spreadsheet-WriteExcel
	dev-perl/Date-Calc
	dev-perl/AppConfig
	dev-perl/ImageSize
	dev-perl/Template-Toolkit
	dev-perl/Time-HiRes
	dev-perl/Lingua-EN-NameParse
	dev-perl/Number-Format
	dev-perl/XML-Simple
	dev-perl/Text-CSV
	dev-perl/Archive-Zip
"

LICENSE="GPL-2"

src_install() {
	webapp_src_preinst
	dodir ${MY_HOSTROOTDIR}/${PN}

	dodoc CHANGELOG README
	cp -R [[:lower:]][[:lower:]]* ${D}/${MY_HTDOCSDIR}
	webapp_postinst_txt en ${FILESDIR}/postinstall-en.txt
	webapp_hook_script ${FILESDIR}/reconfig
	webapp_src_install
}
