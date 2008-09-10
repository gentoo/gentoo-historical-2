# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/twiki/twiki-4.2.2.ebuild,v 1.1 2008/09/10 08:15:49 wrobel Exp $

WEBAPP_NO_AUTO_INSTALL="yes"

inherit webapp

MY_PN="TWiki"

DESCRIPTION="A Web Based Collaboration Platform"
HOMEPAGE="http://twiki.org/"
SRC_URI="mirror://sourceforge/${PN}/${MY_PN}-${PV}.tgz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

S="${WORKDIR}"

RDEPEND=">=app-text/rcs-5.7
	sys-apps/diffutils
	>=dev-lang/perl-5.8
	dev-perl/Algorithm-Diff
	dev-perl/CGI-Session
	dev-perl/Digest-SHA1
	dev-perl/HTML-Parser
	dev-perl/locale-maketext-lexicon
	dev-perl/Text-Diff
	dev-perl/URI
	virtual/cron
	>=virtual/perl-CGI-3.20
	virtual/perl-digest-base
	virtual/perl-File-Spec
	virtual/perl-libnet
	virtual/perl-Time-Local"

need_httpd_cgi

src_install() {
	webapp_src_preinst

	dodoc AUTHORS COPYRIGHT readme.txt
	dohtml T*.html INSTALL.html
	rm -f readme.txt T*.html INSTALL.html

	mv bin/LocalLib.cfg{.txt,}

	insinto "${MY_HTDOCSDIR}"
	doins -r .

	for f in $(find data pub); do
		webapp_serverowned "${MY_HTDOCSDIR}"/${f}
	done

	for f in bin/setlib.cfg bin/LocalLib.cfg; do
		webapp_configfile "${MY_HTDOCSDIR}"/${f}
	done

	webapp_hook_script "${FILESDIR}"/reconfig
	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt
	webapp_postupgrade_txt en "${FILESDIR}"/postupgrade-en.txt

	webapp_src_install
}

pkg_postinst() {
	ewarn
	ewarn "If you are upgrading from an older version of TWiki, back up your"
	ewarn "data/ and pub/ directories and any local changes before upgrading!"
	ewarn
	ewarn "You are _strongly_ encouraged to to read the upgrade guide:"
	ewarn "http://twiki.org/cgi-bin/view/TWiki/TWikiDocumentation"
	ewarn
	webapp_pkg_postinst
}
