# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/Apache-Gallery/Apache-Gallery-0.8-r1.ebuild,v 1.7 2005/10/23 14:59:08 rl03 Exp $

inherit perl-module webapp

DESCRIPTION="Apache gallery for mod_perl"
SRC_URI="http://cpan.org/modules/by-module/Apache/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/author/LEGART/${P}"

LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~x86 ~amd64 ~ppc ~alpha ~sparc"
IUSE="apache2"

DEPEND="${DEPEND}
	>=www-apache/libapreq-1.0
	>=media-libs/imlib2-1.0.6-r1
	>=www-apache/mod_perl-1.27-r1
	>=dev-perl/ImageInfo-1.04-r2
	>=dev-perl/ImageSize-2.99-r1
	dev-perl/Image-Imlib2
	>=perl-core/CGI-2.93
	>=dev-perl/CGI-FastTemplate-1.09
	>=dev-perl/Parse-RecDescent-1.80-r3
	dev-perl/URI
	dev-perl/text-template
	>=dev-perl/Inline-0.43-r1
	virtual/x11
	!apache2? ( >=net-www/apache-1.3.26-r2 )
	apache2? ( >=net-www/apache-2.0.43-r1 ) "

src_install() {
	webapp_src_preinst
	mydoc="INSTALL"

	perl-module_src_install

	insinto ${MY_ICONSDIR}/gallery
	doins htdocs/*.png

	dodir ${MY_HOSTROOTDIR}/${PN}/templates/default
	dodir ${MY_HOSTROOTDIR}/${PN}/templates/new

	insinto ${MY_HOSTROOTDIR}/${PN}/templates/default
	doins templates/default/*
	insinto ${MY_HOSTROOTDIR}/${PN}/templates/new
	doins templates/new/*

	if use apache2; then
		insinto /etc/apache2/conf/modules.d
		doins ${FILESDIR}/76_apache-gallery.conf
	else
		insinto /etc/apache/conf/addon-modules
		doins ${FILESDIR}/apache-gallery.conf
	fi
	webapp_src_install
}

pkg_postinst() {
	if use apache2; then
		einfo
		einfo "You should edit your /etc/apache2/conf/modules.d/76_apache-gallery.conf file to suit."
	else
		einfo
		einfo "Execute \"emerge --config =${PF}\""
		einfo "to have your apache.conf auto-updated."
		einfo "You should then edit your /etc/apache/conf/addon-modules/apache-gallery.conf file to suit."
		einfo
	fi
	webapp_pkg_postinst
}

pkg_config() {
	use apache2 || \
		echo "Include  /etc/apache/conf/addon-modules/apache-gallery.conf" \
			>> ${ROOT}/etc/apache/conf/apache.conf
}
